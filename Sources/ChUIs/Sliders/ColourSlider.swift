//
//  ColourSlider.swift
//
//
//  Created by Jeff Cooper on 12/21/21.
//

import Foundation
import UIKit

open class ColourSlider: UIControl {
    @IBInspectable var sliderColour: UIColor = Colour.allCases.randomElement()?.colour ?? .red
    @IBInspectable var minimumValue: CGFloat = 0
    @IBInspectable var maximumValue: CGFloat = 1
    @IBInspectable var value: CGFloat = 0.333
    
    var trackTintColor = UIColor(white: 0.9, alpha: 1)
    var trackHighlightTintColor = UIColor(red: 0, green: 0.45, blue: 0.94, alpha: 1)
    
    private let trackLayer = ColourSliderTrackLayer()

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
        trackLayer.frame = bounds//.insetBy(dx: bounds.width / 3, dy: 0)
        trackLayer.setNeedsDisplay()
//        if let thumbImage = thumbImage {
//            thumbImageView.frame = CGRect(origin: thumbOriginForValue(value), size: thumbImage.size)
//        }
        print("slider value is \(value)")
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

extension ColourSlider {
    
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
            value += deltaValue
            value = boundValue(value, toLowerValue: minimumValue,
                               upperValue: maximumValue)
//        }
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        updateLayerFrames()
        CATransaction.commit()
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

open class ColourSliderTrackLayer: CALayer {
  weak var slider: ColourSlider?
    
    open override func draw(in ctx: CGContext) {
        guard let slider = slider else { return }
        
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        ctx.addPath(path.cgPath)
        
        ctx.setFillColor(slider.trackTintColor.cgColor)
        ctx.fillPath()
        
        ctx.setFillColor(slider.trackHighlightTintColor.cgColor)
        let position = slider.fullRangePositionForValue(slider.value)
        let rect = CGRect(x: 0, y: position,
                          width: bounds.width,
                          height: bounds.height * max(position, 1.0))
        print(rect)
        ctx.fill(rect)
    }
}
