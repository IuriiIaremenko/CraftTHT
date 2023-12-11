//
//  StyleSegmentPickerView.swift
//  CraftTestTask
//
//  Created by iurii iaremenko on 10.12.2023.
//

import UIKit

protocol StyleSegmentPickerDelegate: AnyObject {
    func segmentView(_ segment: StyleSegmentPickerView, didSelection data: StyleSegmentPickerView.Selection)
}

final class StyleSegmentPickerView: UIView {
    enum Selection {
        case color, gradient, image
    }

    private var highlightedSegment: SegmentButton.Style {
        didSet {
            let frameToHighlight: CGRect
            switch highlightedSegment {
            case .solid: 
                frameToHighlight = colorSegment.frame
                delegate?.segmentView(self, didSelection: .color)
            case .gradient:
                frameToHighlight = gradientSegment.frame
                delegate?.segmentView(self, didSelection: .gradient)
            case .image:
                frameToHighlight = imageSegment.frame
                delegate?.segmentView(self, didSelection: .image)
            }

            UIView.animate(withDuration: 0.2) {
                self.highlightView.frame = .init(
                    x: frameToHighlight.origin.x + 5,
                    y: frameToHighlight.origin.y + 5,
                    width: frameToHighlight.size.width - 10,
                    height: frameToHighlight.size.height - 10
                )
            }
        }
    }

    private lazy var colorSegment = SegmentButton(
        frame: CGRect(x: 0, y: 0, width: 70, height: 70),
        style: .solid
    )

    private lazy var gradientSegment = SegmentButton(
        frame: colorSegment.frame.offsetBy(dx: colorSegment.frame.width, dy: 0),
        style: .gradient
    )

    private lazy var imageSegment = SegmentButton(
        frame: gradientSegment.frame.offsetBy(dx: gradientSegment.frame.width, dy: 0),
        style: .image
    )

    private lazy var highlightView: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiarySystemBackground
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        return view
    }()

    weak var delegate: StyleSegmentPickerDelegate?

    init(frame: CGRect, highlightedSegment: SegmentButton.Style) {
        self.highlightedSegment = highlightedSegment
        super.init(frame: frame)
        setupLayout(frame: frame)
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 5
        clipsToBounds = true
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupLayout(frame: CGRect) {
        let leadingPadding = (frame.width - (3 * 70)) / 2

        [colorSegment, gradientSegment, imageSegment].forEach { button in
            button.frame = button.frame.offsetBy(dx: leadingPadding, dy: 0)
        }

        let frameToHighlight: CGRect =
        switch highlightedSegment {
        case .solid:
            colorSegment.frame
        case .gradient:
            gradientSegment.frame
        case .image:
            imageSegment.frame
        }

        highlightView.frame = .init(
            x: frameToHighlight.origin.x + 5,
            y: frameToHighlight.origin.y + 5,
            width: frameToHighlight.size.width - 10,
            height: frameToHighlight.size.height - 10
        )
        addSubview(highlightView)

        addSubview(colorSegment)
        addSubview(gradientSegment)
        addSubview(imageSegment)

        colorSegment.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        gradientSegment.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        imageSegment.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }

    @objc private func buttonTapped(_ sender: UIButton) {
        guard let segment = sender as? SegmentButton else {
            return
        }
        highlightedSegment = segment.style
    }
}

#Preview {
    StyleSegmentPickerView(
        frame: .init(x: 10, y: 10, width: 295, height: 70),
        highlightedSegment: .gradient
    )
}
