//
//  XYPadControl.swift
//  
//
//  Created by Jeff Cooper on 3/3/22.
//

import UIKit

@IBDesignable
open class XYPadControl: UIControl {
    private var backgroundView: BorderedView!
    
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
