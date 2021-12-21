//
//  Colours.swift
//  
//
//  Created by Jeff Cooper on 12/21/21.
//

import Foundation
import UIKit

enum Colour: CaseIterable {
    case red
    case blue
    case green
    case yellow
    
    var colour: UIColor {
        switch self {
        case .red:
            return .red
        case .blue:
            return .blue
        case .green:
            return .green
        case .yellow:
            return .yellow
        }
    }
}
