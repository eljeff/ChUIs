//
//  XYPadControl.swift
//  
//
//  Created by Jeff Cooper on 3/3/22.
//

import UIKit

@IBDesignable
open class XYPadControl: UIControl {
    
    public var xValueNormalised: Float = 0.5 { didSet { updateLayerFrames() } }
    public var yValueNormalised: Float = 0.5 { didSet { updateLayerFrames() } }
    private var minimumValue: CGFloat = 0
    private var maximumValue: CGFloat = 1
    private var backgroundView: BorderedView!
    
    private var previousLocation = CGPoint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundView = BorderedView(frame: frame)
        setupViews()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundView = BorderedView(coder: aDecoder)
        setupViews()
    }
    
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupViews()
//        trackLayer.setNeedsDisplay()
    }
    
    private func setupViews() {
//        trackLayer.slider = self
//        trackLayer.contentsScale = UIScreen.main.scale
//        layer.addSublayer(trackLayer)
        backgroundView.borderColor = .purple
        backgroundView.backgroundColor = .cyan
        backgroundView.frame = bounds
        backgroundView.isUserInteractionEnabled = false
        addSubview(backgroundView)
        updateLayerFrames()
    }
    
    private func updateLayerFrames() {
//        CATransaction.begin()
//        CATransaction.setDisableActions(true)
//        trackLayer.frame = bounds
//        trackLayer.setNeedsDisplay()
//        CATransaction.commit()
    }
}

extension XYPadControl {
    
    private func updateValuesFromTouch(_ touch: UITouch) {
        previousLocation = touch.location(in: self)
        let location = touch.location(in: self)
        xValueNormalised = Float(boundValue(((maximumValue - minimumValue) * location.x / bounds.width), toLowerValue: 0, upperValue: 1))
        yValueNormalised = Float(1.0 - boundValue(((maximumValue - minimumValue) * location.y / bounds.height), toLowerValue: 0, upperValue: 1))
        sendActions(for: .valueChanged)
        print("x: \(xValueNormalised) - y: \(yValueNormalised)")
    }
    
    open override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)
        updateValuesFromTouch(touch)
        return true
    }
    
    open override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.continueTracking(touch, with: event)
        updateValuesFromTouch(touch)
        return true
    }
    
    private func boundValue(_ value: CGFloat, toLowerValue lowerValue: CGFloat,
                            upperValue: CGFloat) -> CGFloat {
        return min(max(value, lowerValue), upperValue)
    }
    
    open override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
    }

}
