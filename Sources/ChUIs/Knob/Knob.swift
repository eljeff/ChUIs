//
//  Knob.swift
//
//  Created by Jeff Cooper 28 April 2021.
//  Copyright © 2021 AudioKit Pro. All rights reserved.
//
import UIKit

// FIXME: This single knob uses ~20% CPU when being turned - that is probably pretty bad?
// the only part that needs to animate in this particular knob is the indicator, and that can
// likely be accomplished w/ a basic rotation translation.
@IBDesignable
public class StyleKitKnob: Knob {
    @IBInspectable public var outerRingIndicatorImage: UIImage? = nil
    @IBInspectable public var indicatorColor: UIColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
    @IBInspectable public var indicatorBlurColor: UIColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)

    public override func draw(_ rect: CGRect) {
        KnobStyleKit.drawKnobCanvas(targetFrame: CGRect(x: 0, y: 0,
                                                  width: self.bounds.width, height: self.bounds.height),
                                    knobValue: CGFloat(normalisedValue),
                                    indicatorColor: indicatorColor, indicatorBlurColor: indicatorBlurColor,
                                    outerRingImage: outerRingIndicatorImage)
    }

}

@IBDesignable
public class Knob: UIView {

    public var callback: (Float) -> Void = { _ in }

    @IBInspectable public var shouldRound: Bool = false
    @IBInspectable public var knobSensitivity: Float = 0.005   // higher is faster
    @IBInspectable public var upperLimit: Float = 1.0
    @IBInspectable public var lowerLimit: Float = 0.0

    @IBInspectable public var defaultValue: Float = 0.0 // the value knob will return to when double-clicked

    private var range: ClosedRange<Float> { // Not normalised
        guard lowerLimit < upperLimit else {
            fatalError("UpperLimit (\(upperLimit)) must be greater than lowerLimit \(lowerLimit)")
        }
        return lowerLimit...upperLimit
    }

    public var value: Float {
        return (knobValue * fullRange) + range.lowerBound
    }

    public var normalisedValue: Float {
        return knobValue
    }

    private var knobValue: Float = 0.0 //normalised value - used internally

    private var fullRange: Float {
        return range.upperBound - range.lowerBound
    }

    public func updateKnobPosition(normalised: Float) { // simply redraws the knob
        knobValue = (0...1).clamp(normalised)
        self.setNeedsDisplay()
    }

    public func updateUIValue(denormalised: Float) { // this uses the full range of the knob
        let clampedValue = range.clamp(denormalised)
        let offsetRemoved = clampedValue - range.lowerBound
        let normalised = offsetRemoved / fullRange
        updateKnobPosition(normalised: normalised)
    }

    public func setToValue(value: Float) { // updates the knobPosition and sends value to callback
        updateUIValue(denormalised: value)
        callback(range.clamp(value))
    }

    public func resetToDefault() { // sets to default and sends the value to callback
        setToValue(value: defaultValue)
    }

    public func refreshKnobPosition() { // updates knobPosition visually
        updateKnobPosition(normalised: knobValue)
    }

    // Init / Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentMode = .redraw
        setToValue(value: defaultValue)
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
        setToValue(value: defaultValue)
    }

    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        contentMode = .scaleAspectFit
        clipsToBounds = true
        setToValue(value: defaultValue)
    }

    public class override var requiresConstraintBasedLayout: Bool {
        return true
    }

    @objc private func doubleTapped() {
        resetToDefault()
    }

    private var lastX: CGFloat = 0
    private var lastY: CGFloat = 0

    // Helper
    private func setPercentagesWithTouchPoint(_ touchPoint: CGPoint) {
        // Knobs assume up or right is increasing, and down or left is decreasing

        var updatedKnobValue = knobValue + Float(touchPoint.x - lastX) * knobSensitivity
        updatedKnobValue = updatedKnobValue - Float(touchPoint.y - lastY) * knobSensitivity
        knobValue = Float((0...1).clamp(updatedKnobValue))

        setToValue(value: value)
        lastX = touchPoint.x
        lastY = touchPoint.y
    }

    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchPoint = touch.location(in: self)
            lastX = touchPoint.x
            lastY = touchPoint.y
        }
    }

    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchPoint = touch.location(in: self)
            setPercentagesWithTouchPoint(touchPoint)
        }
    }
}

extension ClosedRange {
    /// Clamp value to the range
    /// - parameter value: Value to clamp
    func clamp(_ value: Bound) -> Bound {
        return Swift.min(Swift.max(value, lowerBound), upperBound)
    }
}
