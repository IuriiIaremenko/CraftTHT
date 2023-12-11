//
//  AvatarFont.swift
//  CraftTestTask
//
//  Created by iurii iaremenko on 11.12.2023.
//

import Foundation
import UIKit

public enum AvatarFont {
    case system
    case serif
    case mono
    case round

    var style: (String, String, UIFontDescriptor.SystemDesign) {
        switch self {
        case .system:
            return ("Aa", "System", .default)
        case .serif:
            return ("Ss", "Serif", .serif)
        case .mono:
            return ("00", "Mono", .monospaced)
        case .round:
            return ("Rr", "Round", .rounded)
        }
    }

    var uiFont: UIFont {
        UIFont(descriptor: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .subheadline).withDesign(self.style.2)!, size: 0)
    }
}
