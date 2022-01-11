//
//  BorderedView.swift
//  
//
//  Created by Jeff Cooper on 1/4/22.
//

import UIKit

open class BorderedView: UIView, FancyBorderView {
    public var borderDrawOptions: BorderedViewDrawOptions = .DrawAll
    @IBInspectable public var borderWidth: CGFloat = 10
    @IBInspectable public var borderColor: UIColor = .blue
    @IBInspectable public var leftBorderColor: UIColor?
    @IBInspectable public var topBorderColor: UIColor?
    @IBInspectable public var rightBorderColor: UIColor?
    @IBInspectable public var bottomBorderColor: UIColor?
    @IBInspectable public var leftBorderWidth: CGFloat = 3
    @IBInspectable public var topBorderWidth: CGFloat = 3
    @IBInspectable public var rightBorderWidth: CGFloat = 3
    @IBInspectable public var bottomBorderWidth: CGFloat = 3
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        updateBorders(rect)
    }
}
