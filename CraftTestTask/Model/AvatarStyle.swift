//
//  AvatarStyle.swift
//  CraftTestTask
//
//  Created by iurii iaremenko on 11.12.2023.
//

import Foundation
import UIKit

public enum AvatarStyle {
    case image(Data)
    case color(UIColor, initials: String, font: AvatarFont)
    case gradient(startColor: UIColor, endColor: UIColor, initials: String, font: AvatarFont)
}


extension AvatarStyle {
    var isImageStyle: Bool {
        switch self {
        case .image: true
        case .color: false
        case .gradient: false
        }
    }
}
