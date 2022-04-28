//
//  XYPadControl.swift
//  
//
//  Created by Jeff Cooper on 3/3/22.
//

import UIKit

@IBDesignable
open class XYPadControl: UIControl {
    
    @IBInspectable public var drawLinesOnTouch: Bool = true
    @IBInspectable public var drawLinesAlways: Bool = false
    
    public var xValueNormalised: Float = 0.5 { didSet { setNeedsDisplay() } }
    public var yValueNormalised: Float = 0.5 { didSet { setNeedsDisplay() } }
    private var minimumValue: CGFloat = 0
    private var maximumValue: CGFloat = 1
    private var backgroundView: BorderedView!
    private var xyFeedbackView: XYFeedbackView!
    
    private var previousLocation = CGPoint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundView = BorderedView(frame: frame)
        xyFeedbackView = XYFeedbackView(frame: frame)
        setupViews()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundView = BorderedView(coder: aDecoder)
        xyFeedbackView = XYFeedbackView(coder: aDecoder)
        setupViews()
    }
    
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupViews()
    }
    
    private func setupViews() {
        backgroundView.borderColor = .purple
        addView(view: backgroundView, backgroundColor: .cyan, frame: bounds)
        xyFeedbackView.drawLines = drawLinesAlways
        addView(view: xyFeedbackView, frame: bounds)
    }
    
    private func addView(view: UIView, backgroundColor: UIColor = .clear, frame: CGRect) {
        view.backgroundColor = backgroundColor
        view.frame = frame
        view.isUserInteractionEnabled = false
        addSubview(view)
    }
}

extension XYPadControl {
    
    private func updateValuesFromTouch(_ touch: UITouch) {
        previousLocation = touch.location(in: self)
        let location = touch.location(in: self)
        xValueNormalised = Float(boundValue(((maximumValue - minimumValue) * location.x / bounds.width), toLowerValue: 0, upperValue: 1))
        yValueNormalised = Float(1.0 - boundValue(((maximumValue - minimumValue) * location.y / bounds.height), toLowerValue: 0, upperValue: 1))
        xyFeedbackView.xValueNormalised = CGFloat(xValueNormalised)
        xyFeedbackView.yValueNormalised = CGFloat(yValueNormalised)
        sendActions(for: .valueChanged)
        print("x: \(xValueNormalised) - y: \(yValueNormalised)")
    }
    
    open override func setNeedsDisplay() {
        super.setNeedsDisplay()
        if xyFeedbackView != nil {
            xyFeedbackView.setNeedsDisplay()
        }
    }
    
    open override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)
        updateValuesFromTouch(touch)
        xyFeedbackView.drawLines = drawLinesAlways || drawLinesOnTouch
        setNeedsDisplay()
        return true
    }
    
    open override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.continueTracking(touch, with: event)
        updateValuesFromTouch(touch)
        xyFeedbackView.drawLines = drawLinesAlways || drawLinesOnTouch
        setNeedsDisplay()
        return true
    }
    
    private func boundValue(_ value: CGFloat, toLowerValue lowerValue: CGFloat,
                            upperValue: CGFloat) -> CGFloat {
        return min(max(value, lowerValue), upperValue)
    }
    
    open override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        xyFeedbackView.drawLines = drawLinesAlways
        setNeedsDisplay()
    }

}

open class XYFeedbackView: UIView {
    @IBInspectable public var lineWidthX: CGFloat = 3
    @IBInspectable public var lineWidthY: CGFloat = 3
    @IBInspectable public var circleRadius: CGFloat = 10
    @IBInspectable public var lineColorX: CGColor = UIColor.red.cgColor
    @IBInspectable public var lineColorY: CGColor = UIColor.red.cgColor
    @IBInspectable public var circleColor: CGColor = UIColor.red.cgColor
    @IBInspectable public var xValueNormalised: CGFloat = 0.5
    @IBInspectable public var yValueNormalised: CGFloat = 0.5
    @IBInspectable public var drawLines: Bool = true
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawFeedback(size: rect.size, xValue: xValueNormalised, yValue: yValueNormalised, drawLines: drawLines)
    }
    
    private func drawFeedback(size: CGSize = CGSize(width: 440, height: 151), xValue: CGFloat = 0.5, yValue: CGFloat = 0.5, drawLines: Bool = true) {
        guard let context = UIGraphicsGetCurrentContext()
        else {
            print("no context in drawFeedback")
            return
        }
        print("drawing feedback at \(xValue):\(yValue)")
        let width = floor(size.width)
        let height = floor(size.height)
        let x = xValue * width
        let y = (1.0 - yValue) * height
        
        if drawLines {
            context.setStrokeColor(lineColorX)
            context.setLineWidth(lineWidthX)
            context.beginPath()
            context.move(to: CGPoint(x: x, y: 0))
            context.addLine(to: CGPoint(x: x, y: height))
            context.strokePath()
            context.setStrokeColor(lineColorY)
            context.setLineWidth(lineWidthY)
            context.beginPath()
            context.move(to: CGPoint(x: 0, y: y))
            context.addLine(to: CGPoint(x: width, y: y))
            context.strokePath()
        }
    
        context.saveGState()
        context.setFillColor(circleColor)
        let circleBounds = CGRect(x: x - (circleRadius), y: y - (circleRadius), width: circleRadius * 2, height: circleRadius * 2)
        context.fillEllipse(in: circleBounds)
        context.restoreGState()
        
    }
}
