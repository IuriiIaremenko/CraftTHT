//
//  ColorPickerButton.swift
//  CraftTestTask
//
//  Created by iurii iaremenko on 10.12.2023.
//

import Foundation
import UIKit

final class ColorPickerButton: UIButton {
    private let label = UILabel()
    private var color: UIColor
    private let text: String

    private lazy var circleView: UIView = {
        let circleView = UIView()
        circleView.backgroundColor = color
        circleView.isUserInteractionEnabled = false
        
        return circleView
    }()


    init(frame: CGRect, color: UIColor, text: String) {
        self.color = color
        self.text = text
        super.init(frame: frame)
        setupLayout(frame: frame)
    }

    override init(frame: CGRect) {
        self.color = .clear
        self.text = ""
        super.init(frame: frame)
        setupLayout(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func updateColor(to newColor: UIColor) {
        self.color = newColor
        circleView.backgroundColor = newColor
    }

    private func setupLayout(frame: CGRect) {
        label.text = text
        label.frame = .init(x: 0, y: 0, width: 30, height: 30)
        label.sizeToFit()
        addSubview(label)

        let image = UIImageView(image: UIImage(resource: .rainbow))
        image.frame = .init(x: frame.width - 22, y: 0, width: 22, height: 22)
        image.layer.cornerRadius = image.frame.width / 2
        image.clipsToBounds = true
        image.isUserInteractionEnabled = false

        circleView.addSubview(image)
        addSubview(image)


        circleView.frame = .init(x: frame.width - 20, y: 2, width: 18, height: 18)
        circleView.layer.cornerRadius = circleView.frame.width / 2

        addSubview(circleView)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    ColorPickerButton(frame: .init(x: 0, y: 0, width: 190, height: 40), color: .red, text: "Background Color")
}
