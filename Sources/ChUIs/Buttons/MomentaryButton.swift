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

    private var _isPressed: Bool = false
    public var isPressed: Bool { return _isPressed }

    public func updateUIState(isPressed: Bool) { // update ui state only - do not send callback
        self._isPressed = isPressed
        backgroundColor = isPressed ? onColor : offColor
        updateImage(image: isPressed ? onImage : offImage)
        setNeedsDisplay()
    }

    public func refreshUIState() {
        updateUIState(isPressed: _isPressed)
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        refreshUIState()
    }

    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        _isPressed = true
        callback(_isPressed)
        refreshUIState()
    }

    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        _isPressed = false
        callback(_isPressed)
        refreshUIState()
    }
}
