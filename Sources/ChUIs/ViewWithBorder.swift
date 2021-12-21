//
//  ViewWithBorder.swift
//  ChUIs
//
//  Created by Jeff Cooper on 12/7/21.
//

import UIKit

public protocol ViewWithBorder {
    var layer: CALayer { get }
    var borderWidth: CGFloat { get set }
    var borderColor: UIColor { get set }
}

public extension ViewWithBorder {
    func updateBorders() {
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }
}
