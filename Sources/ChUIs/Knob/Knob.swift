//
//  Knob.swift
//
//  Created by Jeff Cooper 28 April 2021.
//  Copyright © 2021 AudioKit Pro. All rights reserved.
//
import UIKit

@IBDesignable
open class Knob: UIControl {

    public var callback: (Float) -> Void = { _ in }

    @IBInspectable public var shouldRound: Bool = false
    @IBInspectable public var knobSensitivity: Float = 0.005   // higher is faster
    @IBInspectable public var maximumValue: CGFloat = 1.0
    @IBInspectable public var minimumValue: CGFloat = 0.0

    @IBInspectable public var defaultValue: Float = 0.0 // the value knob will return to when double-clicked

    private var range: ClosedRange<Float> { // Not normalised
        guard minimumValue < maximumValue else {
            fatalError("UpperLimit (\(maximumValue)) must be greater than lowerLimit \(minimumValue)")
        }
        return Float(minimumValue)...Float(maximumValue)
    }

    public var value: Float {
        return Float(knobValue)
    }

    public var normalisedValue: Float {
        return Float(knobValue - minimumValue) * fullRange
    }

    private var knobValue: CGFloat = 0.0

    private var fullRange: Float {
        return range.upperBound - range.lowerBound
    }

    public func updateUI(normalised: Float) { // simply redraws the knob
        let clampedValue = (0...1.0).clamp(normalised)
        let denormalised = (clampedValue * fullRange) + Float(minimumValue)
        updateUI(denormalised: denormalised)
    }

    public func updateUI(denormalised: Float) { // this uses the full range of the knob
        let clampedValue = range.clamp(denormalised)
        knobValue = CGFloat(clampedValue)
        self.setNeedsDisplay()
    }

    public func setToValue(denormalised: Float) { // updates the knobPosition and sends value to callback
        updateUI(denormalised: denormalised)
//        callback(range.clamp(value))
    }

    public func resetToDefault() { // sets to default and sends the value to callback
        setToValue(denormalised: defaultValue)
    }

    public func refreshKnobPosition() { // updates knobPosition visually
        updateUI(denormalised: Float(knobValue))
    }

    // Init / Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentMode = .redraw
        setToValue(denormalised: defaultValue)
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        self.isUserInteractionEnabled = true
        contentMode = .redraw
        backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        // Add double tap listener
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        self.addGestureRecognizer(tap)
        setToValue(denormalised: defaultValue)
    }

    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        contentMode = .scaleAspectFit
        clipsToBounds = true
        setToValue(denormalised: defaultValue)
    }

    public class override var requiresConstraintBasedLayout: Bool {
        return true
    }

    @objc private func doubleTapped() {
        resetToDefault()
    }

    private var previousLocation: CGPoint = CGPoint()

    // Helper
    private func getUIValueFromTouchPoint(_ touchPoint: CGPoint, previousLocation: CGPoint, previousValue: CGFloat,
                                          range: ClosedRange<CGFloat> = 0...1.0, sensitivity: CGFloat = 0.005) -> CGFloat {
        // Knobs assume up or right is increasing, and down or left is decreasing
        var updatedKnobValue = previousValue + (touchPoint.x - previousLocation.x) * sensitivity
        updatedKnobValue = updatedKnobValue - (touchPoint.y - previousLocation.y) * sensitivity
        return range.clamp(updatedKnobValue)
    }

//    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for touch in touches {
//            let touchPoint = touch.location(in: self)
//            previousLocation = touchPoint
//        }
//    }
//
//    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for touch in touches {
//            let touchPoint = touch.location(in: self)
//            setPercentagesWithTouchPoint(touchPoint)
//        }
//    }
}

extension Knob {
    
    open override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)
        previousLocation = touch.location(in: self)
        return true
    }
    
    open override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.continueTracking(touch, with: event)
        let location = touch.location(in: self)
        knobValue = getUIValueFromTouchPoint(location, previousLocation: previousLocation, previousValue: knobValue, range: minimumValue...maximumValue,
                                             sensitivity: CGFloat(knobSensitivity * fullRange))
        
        previousLocation = location
        updateUI(denormalised: Float(knobValue))
        
        sendActions(for: .valueChanged)
        return true
    }

}

extension ClosedRange {
    /// Clamp value to the range
    /// - parameter value: Value to clamp
    func clamp(_ value: Bound) -> Bound {
        return Swift.min(Swift.max(value, lowerBound), upperBound)
    }
}
