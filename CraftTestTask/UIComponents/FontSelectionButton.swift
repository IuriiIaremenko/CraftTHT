//
//  FontSelectionButton.swift
//  CraftTestTask
//
//  Created by iurii iaremenko on 09.12.2023.
//

import Foundation
import UIKit

final class FontSelectionButton: UIButton {
    var config: AvatarFont = .system {
        didSet {
            let (top, bottom, font) = config.style
            label1.font = UIFont(descriptor: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .subheadline).withDesign(font) ?? .preferredFontDescriptor(withTextStyle: .subheadline), size: 0)
            label2.font = UIFont(descriptor: UIFontDescriptor.preferredFontDescriptor(withTextStyle: .caption1).withDesign(font) ?? .preferredFontDescriptor(withTextStyle: .caption1), size: 0)

            setLabel1Text(top)
            setLabel2Text(bottom)
        }
    }

    private let label1: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()

    private let label2: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }

    private func setupButton() {
        backgroundColor = UIColor.secondarySystemBackground
        layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.borderColor = UIColor.clear.cgColor
        label1.frame = CGRect(x: 8, y: 18, width: bounds.width - 16, height: 20)
        label2.frame = CGRect(x: 8, y: 36, width: bounds.width - 16, height: 20)
        addSubview(label1)
        addSubview(label2)
    }

    private func setLabel1Text(_ text: String) {
        label1.text = text
    }

    private func setLabel2Text(_ text: String) {
        label2.text = text
    }

    func updateSelection(_ newState: Bool) {
        layer.borderColor = newState ? UIColor.systemCyan.cgColor : UIColor.clear.cgColor
    }
}
