//
//  TextSlider.swift
//  
//
//  Created by Jeff Cooper on 6/28/23.
//

import Foundation
import UIKit

@IBDesignable
open class TextSlider: UIControl {
    
    @IBInspectable public var extraHeightPx: CGFloat = 0
    @IBInspectable public var minValueDisplay: Float = 0
    @IBInspectable public var maxValueDisplay: Float = 5
    @IBInspectable public var defaultValue: Float = 0
    @IBInspectable public var currentValue: Float = 0.333 { didSet { updateLayerFrames() } }
    private var minimumValue: CGFloat = 0 { didSet { updateLayerFrames() } }
    private var maximumValue: CGFloat = 1 { didSet { updateLayerFrames() } }
    public var minValue: Float { return Float(minimumValue) }
    public var maxValue: Float { return Float(maximumValue) }
    @IBInspectable var sliderBackgroundColour: UIColor = .systemBackground { didSet { updateLayerFrames() } }
    @IBInspectable var labelColour: UIColor = .gray { didSet { updateLayerFrames() } }
    
    private var valueLabel: UILabel
    
    private var previousLocation = CGPoint()
    private var doubleTapRecogniser: UITapGestureRecognizer {
        let recogniser = UITapGestureRecognizer(target: self,
                                                     action: #selector(doubleTapReceived(sender: )))
        recogniser.numberOfTapsRequired = 2
        return recogniser
    }

    override init(frame: CGRect) {
        valueLabel = UILabel(frame: frame)
        super.init(frame: frame)
        setupViews()
    }

    required public init?(coder aDecoder: NSCoder) {
        valueLabel = UILabel(coder: aDecoder) ?? UILabel()
        super.init(coder: aDecoder)
        setupViews()
    }
    
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupViews()
    }
    
    open override var frame: CGRect {
        didSet {
            updateLayerFrames()
        }
    }
    
    open override func layoutSubviews() {
        updateLayerFrames()
    }
    
    public func resetToDefault()
    {
        currentValue = defaultValue
        sendActions(for: .valueChanged)
    }
    
    @objc public func doubleTapReceived(sender: UIGestureRecognizer)
    {
        resetToDefault()
    }
    
    private func setupViews() {
        addSubview(valueLabel)
        valueLabel.isUserInteractionEnabled = false
        valueLabel.textAlignment = .center
        valueLabel.textColor = labelColour
        addConstraint(NSLayoutConstraint(item: valueLabel, attribute: .centerX, relatedBy: .equal,
                                         toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: valueLabel, attribute: .centerY, relatedBy: .equal,
                                         toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: valueLabel, attribute: .width, relatedBy: .equal,
                                         toItem: self, attribute: .width, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: valueLabel, attribute: .height, relatedBy: .equal,
                                         toItem: self, attribute: .height, multiplier: 1.0, constant: 0))
        addGestureRecognizer(doubleTapRecogniser)
        updateLayerFrames()
        updateValueLabel()
    }
    
    private func updateLayerFrames() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        CATransaction.commit()
        updateValueLabel()
    }
    
    func fullRangePositionForValue(_ value: CGFloat) -> CGFloat {
        return bounds.height - (bounds.height * value)
    }
    
    func updateValueLabel() {
        let denorm = currentValue * (maxValueDisplay - minValueDisplay) + minValueDisplay
        valueLabel.text = "\(String(format: "%.2f", denorm)) secs"
    }
}

extension TextSlider {
    
    open override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        previousLocation = touch.location(in: self)
        
        return true
    }
    
    open override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        let deltaLocation = location.y - previousLocation.y
        let deltaValue = (maximumValue - minimumValue) * deltaLocation / (bounds.height + extraHeightPx)
        
        previousLocation = location
        
        currentValue -= Float(deltaValue)
        currentValue = Float(boundValue(CGFloat(currentValue), toLowerValue: minimumValue,
                                        upperValue: maximumValue))
        updateValueLabel()
        sendActions(for: .valueChanged)
        return true
    }
    
    private func boundValue(_ value: CGFloat, toLowerValue lowerValue: CGFloat,
                            upperValue: CGFloat) -> CGFloat {
        return min(max(value, lowerValue), upperValue)
    }
    
    open override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
    }

}
