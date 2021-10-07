//
//  MomentaryButton.swift
//  
//
//  Created by Jeff Cooper on 8/4/21.
//

import UIKit

@IBDesignable
open class MomentaryButton: ButtonBase {

    public var callback: (Bool) -> Void = { _ in }

    @IBInspectable public var onImage: UIImage? = nil
    @IBInspectable public var offImage: UIImage? = nil
    @IBInspectable public var onColor: UIColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
    @IBInspectable public var offColor: UIColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)

    public var isPressed: Bool = false {  //update state and send callback
        didSet {
            callback(isPressed)
            refreshUIState()
        }
    }

    public func updateUIState(isPressed: Bool) { // update ui state only - do not send callback
        backgroundColor = isPressed ? onColor : offColor
        updateImage(image: isPressed ? onImage : offImage)
        setNeedsDisplay()
    }

    public func refreshUIState() {
        updateUIState(isPressed: isPressed)
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        refreshUIState()
    }

    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isPressed = true
    }

    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isPressed = false
    }
}
