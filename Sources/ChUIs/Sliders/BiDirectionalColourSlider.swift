//
//  BiDirectionalColourSlider.swift
//  
//
//  Created by Jeff Cooper on 1/4/22.
//
import Foundation
import UIKit

@IBDesignable
open class BiDirectionalColourSlider: UIControl {
    
    @IBInspectable public var defaultValue: Float = 0
    @IBInspectable public var currentValue: Float = 0.5 { didSet { updateLayerFrames() } }
    private var minimumValue: CGFloat = 0
    private var maximumValue: CGFloat = 1
    public var minValue: Float { return Float(minimumValue) }
    public var maxValue: Float { return Float(maximumValue) }
    @IBInspectable var sliderBackgroundColour: UIColor = .systemBackground { didSet { updateLayerFrames() } }
    
    private let trackLayer = BiDirectionalColourSliderTrackLayer()

//    var thumbImage = UIImage(systemName: "mount.fill")
    //    private let thumbImageView = UIImageView()
    
    private var previousLocation = CGPoint()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupViews()
        trackLayer.setNeedsDisplay()
    }
    
    open override var frame: CGRect {
        didSet {
            updateLayerFrames()
        }
    }
    
    open override func layoutSubviews() {
        updateLayerFrames()
    }
    
    private func setupViews() {
        trackLayer.slider = self
        trackLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(trackLayer)
        
//        thumbImageView.image = thumbImage
//        addSubview(thumbImageView)
        
        updateLayerFrames()
    }
    
    private func updateLayerFrames() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)

        trackLayer.frame = bounds//.insetBy(dx: bounds.width / 3, dy: 0)
        trackLayer.setNeedsDisplay()
//        if let thumbImage = thumbImage {
//            thumbImageView.frame = CGRect(origin: thumbOriginForValue(value), size: thumbImage.size)
//        }
        CATransaction.commit()
    }
    
    private func thumbOriginForValue(_ value: CGFloat) -> CGPoint {
        let y = positionForValue(value)
        return CGPoint(x: bounds.width / 2.0, y: y)
    }
    
    func positionForValue(_ value: CGFloat) -> CGFloat {
        return bounds.height * value
    }
    
    
    func fullRangePositionForValue(_ value: CGFloat) -> CGFloat {
        return bounds.height * value
    }
}

extension BiDirectionalColourSlider {
    
    open override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        previousLocation = touch.location(in: self)
        
//        if thumbImageView.frame.contains(previousLocation) {
//            thumbImageView.isHighlighted = true
//        }
        
        return true//thumbImageView.isHighlighted
    }
    
    open override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        let deltaLocation = location.y - previousLocation.y
        let deltaValue = (maximumValue - minimumValue) * deltaLocation / bounds.height
        
        previousLocation = location
        
//        if thumbImageView.isHighlighted {
        currentValue -= Float(deltaValue)
        currentValue = Float(boundValue(CGFloat(currentValue), toLowerValue: minimumValue,
                               upperValue: maximumValue))
//        }
        
        sendActions(for: .valueChanged)
        return true
    }
    
    private func boundValue(_ value: CGFloat, toLowerValue lowerValue: CGFloat,
                            upperValue: CGFloat) -> CGFloat {
        return min(max(value, lowerValue), upperValue)
    }
    
    open override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
//      thumbImageView.isHighlighted = false
    }

}

open class BiDirectionalColourSliderTrackLayer: CALayer {
  weak var slider: BiDirectionalColourSlider?
    
    open override func draw(in ctx: CGContext) {
        super.draw(in: ctx)
        guard let slider = slider else { return }
        
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        ctx.addPath(path.cgPath)
        
        ctx.setFillColor(slider.sliderBackgroundColour.cgColor)
        ctx.fillPath()
        
        ctx.setFillColor(slider.tintColor.cgColor)
        var position = slider.fullRangePositionForValue(CGFloat(slider.currentValue))
        print("drawing slider for \(slider.currentValue)")
        let value = max(min(Double(slider.currentValue), 1.0), 0)
        let minimumHeight = 3.0
        var height = max((bounds.height * max(position, 1.0)), minimumHeight)
        if CGFloat(value) > 0.5 {
            height = (bounds.height / 2) * ((value - 0.5) / 0.5)
            position = (bounds.height / 2) - height
        } else if CGFloat(value) < 0.5 {
            height = (bounds.height / 2) * (1.0 - (value / 0.5))
            position = bounds.height / 2
        } else {
            height = minimumHeight
            position = bounds.height / 2
        }
        height = max(height, minimumHeight)
        let rect = CGRect(x: 0, y: position,
                          width: bounds.width,
                          height: height)
        ctx.fill(rect)
    }
}
