//
//  SegmentButton.swift
//  CraftTestTask
//
//  Created by iurii iaremenko on 10.12.2023.
//

import UIKit

final class SegmentButton: UIButton {
    enum Style: String {
        case solid, gradient, image
    }

    let label: UILabel = UILabel()
    let style: Style

    init(frame: CGRect, style: Style) {
        self.style = style
        super.init(frame: frame)
        setupLayout(frame: frame)
    }

    override init(frame: CGRect) {
        self.style = .solid
        super.init(frame: frame)
        setupLayout(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupLayout(frame: CGRect) {
        let rectangleView: UIView
        switch style {
        case .solid:
            rectangleView = UIView()
            rectangleView.backgroundColor = .purple
        case .gradient:
            rectangleView = GradientView(start: .purple, end: .blue)
        case .image:
            rectangleView = UIImageView(image: UIImage(systemName: "photo.fill"))
            rectangleView.tintColor = .purple
        }
        rectangleView.frame = .init(x: 15, y: 10, width: 40, height: 30)
        rectangleView.layer.borderWidth = 2
        rectangleView.layer.cornerRadius = 5
        rectangleView.layer.borderColor = UIColor.white.cgColor
        rectangleView.clipsToBounds = true
        rectangleView.isUserInteractionEnabled = false

        addSubview(rectangleView)

        label.text = self.style.rawValue.capitalized
        label.font = UIFont.preferredFont(forTextStyle: .caption2)
        label.sizeToFit()
        label.frame = .init(
            origin: .init(x: (rectangleView.frame.midX - (label.frame.size.width / 2)), y: 45),
            size: label.frame.size
        )
        addSubview(label)
    }
}

#Preview {
    SegmentButton(frame: .zero, style: .image)
}
#Preview {
    SegmentButton(frame: .zero, style: .gradient)
}
#Preview {
    SegmentButton(frame: .zero, style: .solid)
}
