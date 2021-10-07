//
//  KnobStyleKit.swift
//  Oscillator1-Sine
//
//  Created by Jeff Cooper on 4/28/21.
//

import UIKit

public class KnobStyleKit : NSObject {

    //// Drawing Methods
    @objc dynamic public class func drawKnobCanvas(targetFrame: CGRect = CGRect(x: 0, y: 0, width: 150, height: 150),
                                                   resizing: ResizingBehavior = .aspectFit,
                                                   startingAngle: CGFloat = 211, endingAngle: CGFloat = -32,
                                                   knobValue: CGFloat = 0,
                                                   indicatorColor: UIColor = #colorLiteral(red: 0.8862745098, green: 0.5019607843, blue: 0.2274509804, alpha: 1), //909orang
                                                   indicatorBlurColor: UIColor = #colorLiteral(red: 1, green: 0.5019607843, blue: 0, alpha: 1),
                                                   highlightColor: UIColor = #colorLiteral(red: 0.6431372549, green: 0.6431372549, blue: 0.6431372549, alpha: 1),
                                                   highlightColor2: UIColor = #colorLiteral(red: 0.3607843137, green: 0.3607843137, blue: 0.3607843137, alpha: 1),
                                                   bottomEdgeColor: UIColor = #colorLiteral(red: 0.3137254902, green: 0.3137254902, blue: 0.3137254902, alpha: 1),
                                                   edgeColor: UIColor = #colorLiteral(red: 0.4196078431, green: 0.4196078431, blue: 0.4196078431, alpha: 1),
                                                   edgeColor2: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
                                                   borderColor: UIColor = #colorLiteral(red: 0.6078431373, green: 0.6078431373, blue: 0.6078431373, alpha: 1),
                                                   outerRingImage: UIImage? = nil) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!

        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 150, height: 150), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 150, y: resizedFrame.height / 150)
        let resizedShadowScale: CGFloat = min(resizedFrame.width / 150, resizedFrame.height / 150)

        //// Gradient Declarations
        let edge = CGGradient(colorsSpace: nil, colors: [edgeColor2.cgColor, edgeColor2.blended(withFraction: 0.5, of: UIColor.black).cgColor, UIColor.black.cgColor, edgeColor.cgColor] as CFArray, locations: [0, 0.15, 0.35, 1])!
        let top = CGGradient(colorsSpace: nil, colors: [
            bottomEdgeColor.cgColor,
            bottomEdgeColor.blended(withFraction: 0.5, of: highlightColor2).cgColor,
            highlightColor2.cgColor,
            highlightColor2.blended(withFraction: 0.5, of: highlightColor).cgColor,
            highlightColor.cgColor
        ] as CFArray, locations: [0, 0.27, 0.58, 0.89, 1])!

        //// Shadow Declarations
        let shadow = NSShadow()
        shadow.shadowColor = indicatorBlurColor.withAlphaComponent(0.8 * indicatorBlurColor.cgColor.alpha)
        shadow.shadowOffset = CGSize(width: 0, height: 0)
        shadow.shadowBlurRadius = 16
        let shadow2 = NSShadow()
        shadow2.shadowColor = UIColor.black
        shadow2.shadowOffset = CGSize(width: 0, height: 0)
        shadow2.shadowBlurRadius = 2.5
        let shadow3 = NSShadow()
        shadow3.shadowColor = UIColor.black.withAlphaComponent(0.3)
        shadow3.shadowOffset = CGSize(width: 3, height: 3)
        shadow3.shadowBlurRadius = 10

        //// Variable Declarations
        let expression: CGFloat = knobValue * (endingAngle - startingAngle) + startingAngle

        //// Knob
        //// GradientKnob 2 Drawing
        let gradientKnob2Path = UIBezierPath(ovalIn: CGRect(x: 22, y: 22, width: 106, height: 106))
        context.saveGState()
        context.setShadow(offset: CGSize(width: shadow3.shadowOffset.width * resizedShadowScale, height: shadow3.shadowOffset.height * resizedShadowScale), blur: shadow3.shadowBlurRadius * resizedShadowScale, color: (shadow3.shadowColor as! UIColor).cgColor)
        context.beginTransparencyLayer(auxiliaryInfo: nil)
        gradientKnob2Path.addClip()
        context.drawLinearGradient(top, start: CGPoint(x: 101.5, y: 120.91), end: CGPoint(x: 48.5, y: 29.09), options: [])
        context.endTransparencyLayer()
        context.restoreGState()

        borderColor.setStroke()
        gradientKnob2Path.lineWidth = 1
        gradientKnob2Path.stroke()


        //// GradientKnob Drawing
        let gradientKnobPath = UIBezierPath(ovalIn: CGRect(x: 25, y: 25, width: 100, height: 100))
        context.saveGState()
        gradientKnobPath.addClip()
        context.drawLinearGradient(edge, start: CGPoint(x: 75, y: 125), end: CGPoint(x: 75, y: 25), options: [])
        context.restoreGState()


        //// Indicator Drawing
        context.saveGState()
        context.translateBy(x: 75, y: 75)
        context.rotate(by: -expression * CGFloat.pi/180)

        let indicatorPath = UIBezierPath(rect: CGRect(x: 13.5, y: -4.51, width: 36, height: 8))
        context.saveGState()
        context.setShadow(offset: CGSize(width: shadow.shadowOffset.width * resizedShadowScale, height: shadow.shadowOffset.height * resizedShadowScale), blur: shadow.shadowBlurRadius * resizedShadowScale, color: (shadow.shadowColor as! UIColor).cgColor)
        indicatorColor.setFill()
        indicatorPath.fill()

        ////// Indicator Inner Shadow
        context.saveGState()
        context.clip(to: indicatorPath.bounds)
        context.setShadow(offset: CGSize.zero, blur: 0)
        context.setAlpha((shadow2.shadowColor as! UIColor).cgColor.alpha)
        context.beginTransparencyLayer(auxiliaryInfo: nil)
        let indicatorOpaqueShadow = (shadow2.shadowColor as! UIColor).withAlphaComponent(1)
        context.setShadow(offset: CGSize(width: shadow2.shadowOffset.width * resizedShadowScale, height: shadow2.shadowOffset.height * resizedShadowScale), blur: shadow2.shadowBlurRadius * resizedShadowScale, color: indicatorOpaqueShadow.cgColor)
        context.setBlendMode(.sourceOut)
        context.beginTransparencyLayer(auxiliaryInfo: nil)

        indicatorOpaqueShadow.setFill()
        indicatorPath.fill()

        context.endTransparencyLayer()
        context.endTransparencyLayer()
        context.restoreGState()

        context.restoreGState()

        highlightColor2.setStroke()
        indicatorPath.lineWidth = 1
        indicatorPath.lineJoinStyle = .bevel
        indicatorPath.stroke()

        context.restoreGState()

        //// Picture Drawing
        let picturePath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 150, height: 113))
        context.saveGState()
        picturePath.addClip()
        context.translateBy(x: 0, y: 0)
        context.scaleBy(x: 1, y: -1)
        context.translateBy(x: 0, y: -(outerRingImage?.size.height ?? 0))
        if let ringImage = outerRingImage,
           let ringCgImage = ringImage.cgImage {
            context.draw(ringCgImage, in: CGRect(x: 0, y: 0,
                                                       width: ringImage.size.width,
                                                       height: ringImage.size.height))
        }
        context.restoreGState()

        context.restoreGState()

    }




    @objc(AK909KnobStyleKitResizingBehavior)
    public enum ResizingBehavior: Int {
        case aspectFit /// The content is proportionally resized to fit into the target rectangle.
        case aspectFill /// The content is proportionally resized to completely fill the target rectangle.
        case stretch /// The content is stretched to match the entire target rectangle.
        case center /// The content is centered in the target rectangle, but it is NOT resized.

        public func apply(rect: CGRect, target: CGRect) -> CGRect {
            if rect == target || target == CGRect.zero {
                return rect
            }

            var scales = CGSize.zero
            scales.width = abs(target.width / rect.width)
            scales.height = abs(target.height / rect.height)

            switch self {
                case .aspectFit:
                    scales.width = min(scales.width, scales.height)
                    scales.height = scales.width
                case .aspectFill:
                    scales.width = max(scales.width, scales.height)
                    scales.height = scales.width
                case .stretch:
                    break
                case .center:
                    scales.width = 1
                    scales.height = 1
            }

            var result = rect.standardized
            result.size.width *= scales.width
            result.size.height *= scales.height
            result.origin.x = target.minX + (target.width - result.width) / 2
            result.origin.y = target.minY + (target.height - result.height) / 2
            return result
        }
    }
}



private extension UIColor {
    func blended(withFraction fraction: CGFloat, of color: UIColor) -> UIColor {
        var r1: CGFloat = 1, g1: CGFloat = 1, b1: CGFloat = 1, a1: CGFloat = 1
        var r2: CGFloat = 1, g2: CGFloat = 1, b2: CGFloat = 1, a2: CGFloat = 1

        self.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)

        return UIColor(red: r1 * (1 - fraction) + r2 * fraction,
            green: g1 * (1 - fraction) + g2 * fraction,
            blue: b1 * (1 - fraction) + b2 * fraction,
            alpha: a1 * (1 - fraction) + a2 * fraction);
    }
}

