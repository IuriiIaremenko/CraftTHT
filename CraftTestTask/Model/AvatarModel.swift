//
//  AvatarModel.swift
//  CraftTestTask
//
//  Created by iurii iaremenko on 11.12.2023.
//

import Foundation
import UIKit

public struct AvatarModel {
    var backgroundColor = UIColor.purple

    var gradientStartColor = UIColor.white
    var gradientEndColor = UIColor.blue

    var avatarInitials = "AA"
    var initialsFont = AvatarFont.system

    var backgroundImageData: Data

    var activeStyle: AvatarStyle

    public init(
        backgroundColor: UIColor = UIColor.purple,
        gradientStartColor: UIColor = UIColor.white,
        gradientEndColor: UIColor = UIColor.blue,
        avatarInitials: String = "AA",
        avatarFont: AvatarFont = AvatarFont.system,
        imageData: Data = Data(),
        activeStyle: AvatarStyle
    ) {
        self.backgroundColor = backgroundColor
        self.gradientStartColor = gradientStartColor
        self.gradientEndColor = gradientEndColor
        self.avatarInitials = avatarInitials
        self.initialsFont = avatarFont
        self.activeStyle = activeStyle
        self.backgroundImageData = imageData

        switch activeStyle {
        case .image(let data):
            self.backgroundImageData = data
        case let .color(uIColor, initials, font):
            self.backgroundColor = uIColor
            self.avatarInitials = initials
            self.initialsFont = font
        case let .gradient(startColor, endColor, initials, font):
            self.gradientStartColor = startColor
            self.gradientEndColor = endColor
            self.avatarInitials = initials
            self.initialsFont = font
        }
    }

    mutating func updateActiveStyleData() {
        switch activeStyle {
        case .image:
            self.activeStyle = .image(backgroundImageData)
        case .color:
            self.activeStyle = .color(backgroundColor, initials: avatarInitials, font: initialsFont)
        case .gradient:
            self.activeStyle = .gradient(startColor: gradientStartColor, endColor: gradientEndColor, initials: avatarInitials, font: initialsFont)
        }
    }
}
