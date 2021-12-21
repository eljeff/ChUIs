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
    
    var thumbImage = UIImage(systemName: "mount.fill")!

    private let trackLayer = CALayer()
    private let thumbImageView = UIImageView()
    
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
        trackLayer.backgroundColor = UIColor.blue.cgColor
        layer.addSublayer(trackLayer)
        
        thumbImageView.image = thumbImage
        addSubview(thumbImageView)
        
        updateLayerFrames()
    }
    
    private func updateLayerFrames() {
        trackLayer.frame = bounds.insetBy(dx: bounds.width / 3, dy: 0)
        trackLayer.setNeedsDisplay()
        thumbImageView.frame = CGRect(origin: thumbOriginForValue(value), size: thumbImage.size)
    }
    
    func positionForValue(_ value: CGFloat) -> CGFloat {
        return bounds.height * value
    }
    
    private func thumbOriginForValue(_ value: CGFloat) -> CGPoint {
        let y = positionForValue(value) - thumbImage.size.height / 2.0
        return CGPoint(x: (bounds.width - thumbImage.size.width) / 2.0, y: y)
    }
}

extension ColourSlider {
    
    open override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        previousLocation = touch.location(in: self)
        
        if thumbImageView.frame.contains(previousLocation) {
            thumbImageView.isHighlighted = true
        }
        
        return thumbImageView.isHighlighted
    }
    
    open override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        let deltaLocation = location.y - previousLocation.y
        let deltaValue = (maximumValue - minimumValue) * deltaLocation / bounds.height
        
        previousLocation = location
        
        if thumbImageView.isHighlighted {
            value += deltaValue
            value = boundValue(value, toLowerValue: minimumValue,
                               upperValue: maximumValue)
        }
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        updateLayerFrames()
        CATransaction.commit()
        return true
    }
    
    private func boundValue(_ value: CGFloat, toLowerValue lowerValue: CGFloat,
                            upperValue: CGFloat) -> CGFloat {
        return min(max(value, lowerValue), upperValue)
    }
    
    open override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
      thumbImageView.isHighlighted = false
    }

}
