//
//  RecentlyUsedSection.swift
//  CraftTestTask
//
//  Created by iurii iaremenko on 10.12.2023.
//

import UIKit

protocol RecentlyUsedSectionDelegate: AnyObject {
    func picker(_ recentlyUsedSection: RecentlyUsedSection, didSelection data: Data)
}

final class RecentlyUsedSection: UIView {
    weak var delegate: RecentlyUsedSectionDelegate?

    private var images: [Data]
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.canCancelContentTouches = false
        return scrollView
    }()

    private let label = UILabel()

    init(frame: CGRect, images: [Data]) {
        self.images = images
        super.init(frame: frame)
        setupLayout(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func updateImagesList(with images: [Data]) {
        scrollView.subviews.forEach { $0.removeFromSuperview() }
        self.images = images

        for (index, data) in images.enumerated() {
            let imageView = UIImageView(image: UIImage(data: data))
            imageView.contentMode = .scaleAspectFill
            imageView.isUserInteractionEnabled = true
            imageView.clipsToBounds = true

            imageView.frame = CGRect(
                x: CGFloat(index) * 100,
                y: 0,
                width: 100,
                height: scrollView.frame.height
            )

            scrollView.contentSize = CGSize(
                width: CGFloat(images.count) * 100,
                height: scrollView.frame.height
            )
            scrollView.addSubview(imageView)
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleImageTap(_:)))
            imageView.addGestureRecognizer(tapRecognizer)
        }
    }

    private func setupLayout(frame: CGRect) {
        label.text = "Recently used:"
        label.font = .preferredFont(forTextStyle: .body)
        label.frame = .init(x: 0, y: 0, width: 30, height: 30)
        label.sizeToFit()

        scrollView.frame = CGRect(x: 0, y: 30, width: frame.width, height: 100)
        updateImagesList(with: images)
        addSubview(label)
        addSubview(scrollView)
    }

    @objc private func handleImageTap(_ sender: UITapGestureRecognizer) {
        print(#function)
        guard let imageView = sender.view as? UIImageView, let data = imageView.image?.pngData() else {
            return
        }

        delegate?.picker(self, didSelection: data)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    let view = RecentlyUsedSection(
        frame: .init(origin: .init(x: 0, y: 300), size: .init(width: UIScreen.main.bounds.width, height: 100)),
        images: [
            UIImage(named: "Image01")!.pngData()!,
            UIImage(named: "Image02")!.pngData()!,
            UIImage(named: "Image03")!.pngData()!,            
            UIImage(named: "Image01")!.pngData()!,
            UIImage(named: "Image02")!.pngData()!,
            UIImage(named: "Image03")!.pngData()!,            
            UIImage(named: "Image01")!.pngData()!,
            UIImage(named: "Image02")!.pngData()!,
            UIImage(named: "Image03")!.pngData()!,
            UIImage(named: "Image01")!.pngData()!,
            UIImage(named: "Image02")!.pngData()!,
            UIImage(named: "Image03")!.pngData()!,
        ]
    )

    view.frame = .init(origin: .init(x: 0, y: 300), size: .init(width: UIScreen.main.bounds.width, height: 100))

    return view
}
