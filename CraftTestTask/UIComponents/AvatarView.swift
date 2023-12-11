//
//  AvatarView.swift
//  CraftTestTask
//
//  Created by iurii iaremenko on 10.12.2023.
//

import UIKit

final class AvatarView: UIView {
    private(set) var style: AvatarStyle
    private var gradientView: GradientView?
    private var label: UILabel?
    private let padding: CGFloat = 50

    convenience init(frame: CGRect, style: AvatarStyle) {
        self.init()
        self.style = style
        self.frame = frame
        setupManualLayout(frame: frame)
    }

    override init(frame: CGRect) {
        self.style = .color(.cyan, initials: "AA", font: .system)
        super.init(frame: frame)

        setupManualLayout(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented!")
    }

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        gradientView?.frame = self.bounds
    }

    func updateStyle(_ newState: AvatarStyle) {
        setBackground(for: newState, in: self.frame)
    }

    private func setupManualLayout(frame: CGRect) {
        setBackground(for: self.style, in: frame)
        layer.cornerRadius = 16
        clipsToBounds = true
    }

    private func setBackground(for state: AvatarStyle, in frame: CGRect) {
        self.subviews.forEach { $0.removeFromSuperview() }

        switch state {
        case .image(let data):
            self.backgroundColor = .secondarySystemBackground
            var contentMode: UIView.ContentMode = .scaleAspectFill
            let image: UIImage?

            if let uploadedImage = UIImage(data: data) {
                image = uploadedImage
            } else {
                // default image
                contentMode = .center
                image = UIImage(systemName: "photo.badge.plus")
            }

            let imageView = UIImageView(image: image)
            imageView.contentMode = contentMode
            imageView.tintColor = .purple
            imageView.frame = .init(origin: .zero, size: frame.size)
            imageView.clipsToBounds = true

            self.addSubview(imageView)

        case let .color(uIColor, initials, font):
            self.backgroundColor = uIColor

            let label = buildLabel(with: initials, using: font.uiFont, in: frame)
            self.addSubview(label)

        case let .gradient(startColor, endColor, initials, font):
            self.backgroundColor = .clear
            let gradientView = GradientView(start: startColor, end: endColor)
            gradientView.frame = frame
            insertSubview(gradientView, at: 0)
            self.gradientView = gradientView

            let label = buildLabel(with: initials, using: font.uiFont, in: frame)
            self.addSubview(label)
        }
    }

    private func buildLabel(with initials: String, using font: UIFont, in frame: CGRect) -> UILabel {
        let label = UILabel()
        label.text = String(initials.prefix(2))
        label.textAlignment = .center
        label.textColor = .white
        label.frame = .init(origin: .zero, size: frame.size)
        label.font = font
        label.layer.opacity = 0.8
        scaleFontToFitParent(label: label, in: frame)

        return label
    }

    // Method to scale the font to fit the parent view
    private func scaleFontToFitParent(label: UILabel, in frame: CGRect) {
        let scaleX = (frame.width - padding) / label.intrinsicContentSize.width
        let scaleY = (frame.height - padding) / label.intrinsicContentSize.height
        let minScale = min(scaleX, scaleY)
        let originalFontSize = label.font.pointSize
        let newFontSize = originalFontSize * minScale
        label.font = label.font.withSize(newFontSize)
    }
}
