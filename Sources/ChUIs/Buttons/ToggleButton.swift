//
//  ToggleButton.swift
//  
//
//  Created by Jeff Cooper on 8/4/21.
//

import UIKit

@IBDesignable
open class ToggleButton: MomentaryButton {

    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let isPressed = !isPressed
        updateUIState(isPressed: isPressed)
        callback(isPressed)
    }

    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        return // do nothing for touch up on toggle
    }
}
