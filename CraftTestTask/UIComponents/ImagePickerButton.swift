//
//  File.swift
//  CraftTestTask
//
//  Created by iurii iaremenko on 10.12.2023.
//

import UIKit

final class ImagePickerButton: UIButton {
    private let thumbnailView: UIImageView = {
        let view = UIImageView(image: UIImage(systemName: "photo.badge.plus"))
        view.tintColor = .purple
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = false
        view.layer.cornerRadius = 6
        view.clipsToBounds = true
        return view
    }()
    private let label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 30))

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func updateImage(to data: Data) {
        thumbnailView.contentMode = .scaleAspectFill
        thumbnailView.image = UIImage(data: data)
    }

    private func setupLayout(frame: CGRect) {
        label.text = "Image"
        label.frame = .init(x: 0, y: 5, width: 30, height: 30)
        label.sizeToFit()
        addSubview(label)

        thumbnailView.frame = .init(x: frame.width - 40, y: 0, width: 30, height: 30)
        addSubview(thumbnailView)
    }
}

#Preview {
    ImagePickerButton(frame: .init(x: 0, y: 0, width: 100, height: 50))
}
