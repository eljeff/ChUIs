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

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        trackLayer.backgroundColor = UIColor.blue.cgColor
        layer.addSublayer(trackLayer)
        
        thumbImageView.image = thumbImage
        addSubview(thumbImageView)
    }
    
    // 1
    private func updateLayerFrames() {
      trackLayer.frame = bounds.insetBy(dx: 0.0, dy: bounds.height / 3)
      trackLayer.setNeedsDisplay()
        thumbImageView.frame = CGRect(origin: thumbOriginForValue(value),
                                         size: thumbImage.size)
    }
    // 2
    func positionForValue(_ value: CGFloat) -> CGFloat {
      return bounds.width * value
    }
    // 3
    private func thumbOriginForValue(_ value: CGFloat) -> CGPoint {
      let x = positionForValue(value) - thumbImage.size.width / 2.0
      return CGPoint(x: x, y: (bounds.height - thumbImage.size.height) / 2.0)
    }
}
