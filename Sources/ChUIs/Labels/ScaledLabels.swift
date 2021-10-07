//
//  ScaledLabels.swift
//  VHS Synth AU
//
//  Created by Jeff Cooper on 7/27/21.
//
// This is a semi-hacky way to quickly scale a number of fonts in a VC.
// You can set each label to one of these classes, and then use ScaledLabel.updateFontSizes
// to make all fonts of that class scale to a factor of the width of the view


import UIKit

public class ScaledLabel: UILabel {
    
    @IBInspectable public var fontScale: CGFloat = 0.8
    @IBInspectable public var scaleToWidth: Bool = false

    public override func layoutSubviews() {
        super.layoutSubviews()
        let scaledFontSize = (scaleToWidth ? frame.width : frame.height) * fontScale
        let adjustedFont = font.withSize(scaledFontSize)
        font = adjustedFont
    }
}
