//
//  ProfileAvatarPicker.swift
//  CraftTestTask
//
//  Created by iurii iaremenko on 11.12.2023.
//

import Foundation
import UIKit

protocol ProfileEditorDelegate: AnyObject {
    func colorPickerSelected(_ avatarView: ProfileEditorView, activeColor: UIColor, source: UIView)
    func imagePickerSelected(_ avatarView: ProfileEditorView)
}

final class ProfileEditorView: UIView {
    var model: AvatarModel
    weak var delegate: ProfileEditorDelegate?

    private lazy var avatarView = AvatarView(
        frame: CGRect(x: 0, y: 0, width: 100, height: 100),
        style: .color(
            model.backgroundColor,
            initials: model.avatarInitials,
            font: .system
        )
    )

    private lazy var segmentPicker = StyleSegmentPickerView(
        frame: .init(
            x: 0,
            y: avatarView.frame.maxY + 10,
            width: 295,
            height: 70
        ), 
        highlightedSegment: model.highlightSegment
    )

    private lazy var colorPickerButton = ColorPickerButton(
        frame: CGRect(
            x: 0,
            y: segmentPicker.frame.maxY + 10,
            width: 295,
            height: 40
        ),
        color: model.backgroundColor,
        text: "Background color"
    )

    private lazy var startGradientButton = ColorPickerButton(
        frame: CGRect(
            x: 0,
            y: segmentPicker.frame.maxY + 10,
            width: 295,
            height: 40
        ),
        color: model.gradientStartColor,
        text: "Start color"
    )

    private lazy var endGradientButton = ColorPickerButton(
        frame: CGRect(
            x: 0,
            y: startGradientButton.frame.maxY,
            width: 295,
            height: 40
        ),
        color: model.gradientEndColor,
        text: "End color"
    )

    private lazy var systemFontButton = FontSelectionButton(frame:  CGRect(x: 0, y: endGradientButton.frame.maxY, width: 70, height: 70))
    private lazy var serifFontButton = FontSelectionButton(frame: .init(origin: .init(x: systemFontButton.frame.maxX + 5, y: systemFontButton.frame.origin.y), size: systemFontButton.frame.size))
    private lazy var monoFontButton = FontSelectionButton(frame: .init(origin: .init(x: serifFontButton.frame.maxX + 5, y: systemFontButton.frame.origin.y), size: systemFontButton.frame.size))
    private lazy var roundFontButton = FontSelectionButton(frame: .init(origin: .init(x: monoFontButton.frame.maxX + 5, y: systemFontButton.frame.origin.y), size: systemFontButton.frame.size))

    private lazy var recentlyUsedSection = RecentlyUsedSection(
        frame: .init(
            origin: .init(x: 0, y: imagePicker.frame.maxY),
            size: .init(width: 295, height: 130)
        ),
        images: recentImages
    )

    var recentImages: [Data]

    private var allFontButtons: [FontSelectionButton] {
        [systemFontButton, serifFontButton, monoFontButton, roundFontButton]
    }

    private var gradientPickerViews: [UIView] {
        [startGradientButton, endGradientButton]
    }

    private lazy var imagePicker = ImagePickerButton(
        frame: CGRect(
            x: 0,
            y: segmentPicker.frame.maxY + 10,
            width: 295,
            height: 40
        )
    )

    init(frame: CGRect, model: AvatarModel, recentImages: [Data]) {
        self.model = model
        self.recentImages = recentImages
        super.init(frame: frame)

        setupStyle()
        setupLayout(frame: frame)
        setupInteraction()
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    public func setColor(_ color: UIColor, for source: UIView) {
        if source === colorPickerButton {
            model.backgroundColor = color
            colorPickerButton.updateColor(to: color)
        } else if source === startGradientButton {
            model.gradientStartColor = color
            startGradientButton.updateColor(to: color)
        } else if source === endGradientButton {
            model.gradientEndColor = color
            endGradientButton.updateColor(to: color)
        } else {
            assertionFailure("Issue in color button logic: \(source) ")
        }

        model.updateActiveStyleData()
        avatarView.updateStyle(model.activeStyle)
    }

    public func setImage(_ data: Data) {
        model.backgroundImageData = data
        model.updateActiveStyleData()
        avatarView.updateStyle(model.activeStyle)
        imagePicker.updateImage(to: data)
    }

    public func updateRecentImages(_ images: [Data]) {
        self.recentImages = images
        recentlyUsedSection.updateImagesList(with: images)
    }

    private func setupStyle() {
        avatarView.updateStyle(model.activeStyle)
        segmentPicker.delegate = self
        systemFontButton.config = .system
        serifFontButton.config = .serif
        monoFontButton.config = .mono
        roundFontButton.config = .round
        recentlyUsedSection.delegate = self
    }

    private func setupLayout(frame: CGRect) {
        addSubview(avatarView)
        addSubview(segmentPicker)

        switch model.activeStyle {
        case .image:
            imagePicker.frame = .init(
                x: 0,
                y: segmentPicker.frame.maxY + 10,
                width: 295,
                height: 40
            )
            addSubview(imagePicker)
        case .color:
            colorPickerButton.frame = .init(
                x: 0,
                y: segmentPicker.frame.maxY + 10,
                width: 295,
                height: 40
            )
            addSubview(colorPickerButton)
        case .gradient:
            startGradientButton.frame = .init(
                x: 0,
                y: segmentPicker.frame.maxY + 10,
                width: 295,
                height: 40
            )
            addSubview(startGradientButton) 

            endGradientButton.frame = .init(
                x: 0,
                y: startGradientButton.frame.maxY,
                width: 295,
                height: 40
            )
            addSubview(endGradientButton)
        }

        if model.activeStyle.isImageStyle {
            addSubview(recentlyUsedSection)
        } else {
            allFontButtons.forEach(addSubview(_:))
            allFontButtons.forEach { button in
                button.updateSelection(button.config == model.initialsFont)
            }
        }
    }

    private func setupInteraction() {
        colorPickerButton.addTarget(self, action: #selector(showColorPicker(_:)), for: .touchUpInside)
        startGradientButton.addTarget(self, action: #selector(showColorPicker(_:)), for: .touchUpInside)
        endGradientButton.addTarget(self, action: #selector(showColorPicker(_:)), for: .touchUpInside)
        imagePicker.addTarget(self, action: #selector(chooseImage), for: .touchUpInside)
        allFontButtons.forEach { button in
            button.addTarget(self, action: #selector(fontButtonTapped(_:)), for: .touchUpInside)
        }
    }

    @objc private func showColorPicker(_ sender: UIView) {
        var color = UIColor.black

        if sender === colorPickerButton {
            color = model.backgroundColor
        } else if sender === startGradientButton {
            color = model.gradientStartColor
        } else if sender === endGradientButton {
            color = model.gradientEndColor
        } else {
            assertionFailure("Issue in color button logic: \(sender) ")
        }
        delegate?.colorPickerSelected(self, activeColor: color, source: sender)
    }

    @objc private func chooseImage() {
        delegate?.imagePickerSelected(self)
    }

    @objc private func fontButtonTapped(_ sender: UIButton) {
        guard let button = sender as? FontSelectionButton else {
            return
        }
        model.initialsFont = button.config
        model.updateActiveStyleData()
        avatarView.updateStyle(model.activeStyle)

        allFontButtons.forEach { button in
            button.updateSelection(button === sender)
        }
    }
}

extension ProfileEditorView: StyleSegmentPickerDelegate {
    func segmentView(_ segment: StyleSegmentPickerView, didSelection data: StyleSegmentPickerView.Selection) {
        model.switchActiveStyle(to: data)
        avatarView.updateStyle(model.activeStyle)

        let viewToRemove: [UIView]
        let viewToAdd: [UIView]

        switch model.activeStyle {
        case .color:
            viewToRemove = [imagePicker, recentlyUsedSection] + gradientPickerViews
            colorPickerButton.frame = CGRect(x: 0, y: segmentPicker.frame.maxY + 10, width: 295, height: 40
            )
            viewToAdd = [colorPickerButton] + allFontButtons

        case .gradient:
            viewToRemove = [imagePicker, colorPickerButton, recentlyUsedSection]
            startGradientButton.frame = CGRect(x: 0, y: segmentPicker.frame.maxY + 10, width: 295, height: 40
            )
            endGradientButton.frame = CGRect(x: 0, y: startGradientButton.frame.maxY, width: 295, height: 40
            )
            viewToAdd = gradientPickerViews + allFontButtons

        case .image:
            viewToRemove = [colorPickerButton] + gradientPickerViews + allFontButtons
            imagePicker.frame = CGRect(x: 0, y: segmentPicker.frame.maxY + 10, width: 295, height: 40
            )
            viewToAdd = [imagePicker, recentlyUsedSection]
        }

        viewToRemove.forEach { $0.removeFromSuperview() }
        viewToAdd.forEach(self.addSubview(_:))
    }
}

extension ProfileEditorView: RecentlyUsedSectionDelegate {
    func picker(_ recentlyUsedSection: RecentlyUsedSection, didSelection data: Data) {
        model.backgroundImageData = data
        model.updateActiveStyleData()
        avatarView.updateStyle(model.activeStyle)
        imagePicker.updateImage(to: data)
    }
}

extension AvatarModel {
    var highlightSegment: SegmentButton.Style {
        switch activeStyle {
        case .color: SegmentButton.Style.solid
        case .gradient: SegmentButton.Style.gradient
        case .image: SegmentButton.Style.image
        }
    }

    mutating func switchActiveStyle(to newStyle: StyleSegmentPickerView.Selection) {
        switch newStyle {
        case .color:
            activeStyle = .color(backgroundColor, initials: avatarInitials, font: initialsFont)
        case .gradient:
            activeStyle = .gradient(startColor: gradientStartColor, endColor: gradientEndColor, initials: avatarInitials, font: initialsFont)
        case .image:
            activeStyle = .image(backgroundImageData)
        }
    }
}

#Preview("Solid") {
    ProfileEditorView(
        frame: .init(origin: .init(x: 0, y: 100), size: .init(width: 300, height: 300)),
        model: AvatarModel(
            activeStyle: .color(
                .purple,
                initials: "AAA",
                font: .system
            )
        ),
        recentImages: ImageProviderClient().recentImages()
    )
}

#Preview("Gradient") {
    ProfileEditorView(
        frame: .init(origin: .init(x: 0, y: 100), size: .init(width: 300, height: 300)),
        model: AvatarModel(
            activeStyle: .gradient(
                startColor: .white,
                endColor: .systemBlue,
                initials: "GR",
                font: .serif
            )
        ),
        recentImages: ImageProviderClient().recentImages()
    )
}


#Preview("Image") {
    ProfileEditorView(
        frame: .init(origin: .init(x: 0, y: 100), size: .init(width: 300, height: 300)),
        model: AvatarModel(activeStyle: .image(Data())),
        recentImages: ImageProviderClient().recentImages()
    )
}
