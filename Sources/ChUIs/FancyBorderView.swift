//
//  FancyBorderView.swift
//
//  Created by Andre Siviero on 02/07/15.
//  Updated to protocol by Jeff Cooper on 21 Dec 2021
//  Copyright (c) 2015 Resultate. All rights reserved.
//  License: MIT

import Foundation
import UIKit

public struct BorderedViewDrawOptions: OptionSet {
    public typealias RawValue = UInt
    private var value: UInt = 0
    init(_ value: UInt) { self.value = value }
    public init(rawValue value: UInt) { self.value = value }
    init(nilLiteral: ()) { self.value = 0 }
    static var allZeros: BorderedViewDrawOptions { return self.init(0) }
    static func fromMask(raw: UInt) -> BorderedViewDrawOptions { return self.init(raw) }
    public var rawValue: UInt { return self.value }
    var boolValue: Bool { return self.value != 0 }

    
    static var None: BorderedViewDrawOptions { return self.init(0) }
    static var DrawTop: BorderedViewDrawOptions   { return self.init(1 << 0) }
    static var DrawRight: BorderedViewDrawOptions  { return self.init(1 << 1) }
    static var DrawBottom: BorderedViewDrawOptions   { return self.init(1 << 2) }
    static var DrawLeft: BorderedViewDrawOptions  { return self.init(1 << 3) }
    static var DrawAll: BorderedViewDrawOptions  { return self.init(0b1111) }
}

public protocol FancyBorderView {
    var layer: CALayer { get }
    var borderWidth: CGFloat { get set }
    var borderColor: UIColor { get set }
    
    var borderDrawOptions: BorderedViewDrawOptions { get set }
    var leftBorderColor: UIColor? { get set }
    var topBorderColor: UIColor? { get set }
    var rightBorderColor: UIColor? { get set }
    var bottomBorderColor: UIColor? { get set }
    
    var leftBorderWidth:CGFloat { get set }
    var topBorderWidth:CGFloat { get set }
    var rightBorderWidth:CGFloat { get set }
    var bottomBorderWidth:CGFloat { get set }
}

public extension FancyBorderView {
    func updateBorders(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext()
        else { return }
        
        context.setStrokeColor(borderColor.cgColor)
        context.setLineWidth(borderWidth)
        
        if(borderDrawOptions.contains(.DrawLeft)) {
            context.setStrokeColor(leftBorderColor?.cgColor != nil ? leftBorderColor!.cgColor : borderColor.cgColor)
            context.setLineWidth(leftBorderWidth)

            context.move(to: CGPoint(x: rect.minX, y: rect.minY))
            context.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            context.strokePath()
            borderResetDefaultColorWidth(context: context)
        }
        
        if(borderDrawOptions.contains(.DrawTop)) {
            context.setLineWidth(topBorderWidth)
            context.setStrokeColor(topBorderColor?.cgColor != nil ? topBorderColor!.cgColor : borderColor.cgColor)
            context.move(to: CGPoint(x: rect.minX, y: rect.minY))
            context.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            context.strokePath()
            borderResetDefaultColorWidth(context: context)

        }
        
        if(borderDrawOptions.contains(.DrawRight)) {
            context.setLineWidth(rightBorderWidth)
            context.setStrokeColor(rightBorderColor?.cgColor != nil ? rightBorderColor!.cgColor : borderColor.cgColor)
            context.move(to: CGPoint(x: rect.maxX, y: rect.minY))
            context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            context.strokePath()
            borderResetDefaultColorWidth(context: context)

        }
        
        if(borderDrawOptions.contains(.DrawBottom)) {
            context.setLineWidth(bottomBorderWidth)
            context.setStrokeColor(bottomBorderColor?.cgColor != nil ? bottomBorderColor!.cgColor : borderColor.cgColor)
            context.move(to: CGPoint(x: rect.minX, y: rect.maxY))
            context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            context.strokePath()
            borderResetDefaultColorWidth(context: context)
        }
        
    }
    
    func borderResetDefaultColorWidth(context: CGContext) -> Void {
        context.setStrokeColor(borderColor.cgColor)
        context.setLineWidth(borderWidth)
    }
}

open class BorderedView: UIView, FancyBorderView {
    public var borderWidth: CGFloat = 10
    @IBInspectable public var borderColor: UIColor = .blue
    public var borderDrawOptions: BorderedViewDrawOptions = .DrawAll
    public var leftBorderColor: UIColor?
    public var topBorderColor: UIColor?
    public var rightBorderColor: UIColor?
    public var bottomBorderColor: UIColor?
    public var leftBorderWidth: CGFloat = 3
    public var topBorderWidth: CGFloat = 3
    public var rightBorderWidth: CGFloat = 3
    public var bottomBorderWidth: CGFloat = 3
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        updateBorders(rect)
    }
}
