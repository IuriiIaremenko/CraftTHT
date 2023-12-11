//
//  GradientView.swift
//  CraftTestTask
//
//  Created by iurii iaremenko on 09.12.2023.
//

import Foundation
import UIKit

final class GradientView: UIView {
    var start: UIColor
    var end: UIColor
    private let gradient: CAGradientLayer = CAGradientLayer()

    private var cgColors: [CGColor] {
        [start.cgColor, end.cgColor]
    }

    init(start: UIColor, end: UIColor) {
        self.start = start
        self.end = end
        super.init(frame: .zero)
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override public func draw(_ rect: CGRect) {
        gradient.frame = self.bounds
        gradient.colors = cgColors

        if gradient.superlayer == nil {
            layer.insertSublayer(gradient, at: 0)
        }
    }
}
