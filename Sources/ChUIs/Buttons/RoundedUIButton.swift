//
//  RoundedUIButton.swift
//  VHS Synth AU
//
//  Created by Matthew Fecher on 10/25/21.
//

import UIKit

public class RoundedUIButton: UIButton {
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        initFunctions()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initFunctions()
    }

    private func initFunctions() {
        clipsToBounds = true
        layer.cornerRadius = 4
        layer.borderWidth = 1.5
    }
}
