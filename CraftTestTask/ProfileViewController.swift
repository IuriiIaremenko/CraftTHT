//
//  ProfileViewController.swift
//  CraftTestTask
//
//  Created by iurii iaremenko on 09.12.2023.
//

import Foundation
import UIKit
import PhotosUI

final class ProfileViewController: UIViewController {
    private lazy var profileEditorView = ProfileEditorView(
        frame: .init(origin: .init(x: 15, y: 15), size: UIScreen.main.bounds.size),
        model: AvatarModel(
            activeStyle: .color(
                .purple,
                initials: "AAA", // should be truncated by the ProfileAvatarPicker
                font: .system
            )
        ),
        recentImages: imageProviderClient.recentImages()
    )

    private weak var colorPickerVC: UIColorPickerViewController?
    private weak var colorPickerSource: UIView?
    private let imageProviderClient = ImageProviderClient()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(profileEditorView)
        profileEditorView.delegate = self
    }

    private func showColorPicker(with color: UIColor) {
        let picker = UIColorPickerViewController()
        picker.selectedColor = color

        picker.delegate = self

#if targetEnvironment(macCatalyst)
        picker.modalPresentationStyle = .popover
        picker.popoverPresentationController?.sourceItem = colorPickerSource
#endif
        present(picker, animated: true)
        self.colorPickerVC = picker
    }

    private func chooseImage() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self

        present(picker, animated: true, completion: nil)
    }
}

extension ProfileViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        defer {
            colorPickerSource = nil
        }
        if let colorPickerSource {
            profileEditorView.setColor(viewController.selectedColor, for: colorPickerSource)
        }
    }

    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        if let colorPickerSource {
            profileEditorView.setColor(viewController.selectedColor, for: colorPickerSource)
        }
    }
}

extension ProfileViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        guard !results.isEmpty else {
            picker.dismiss(animated: true, completion: nil)
            return
        }

        // progress could be tracked here
        _ = results.first?.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
            if let imageData = (image as? UIImage)?.pngData() {
                DispatchQueue.main.async {
                    self?.profileEditorView.setImage(imageData)
                    self?.imageProviderClient.saveImage(data: imageData)
                    self?.profileEditorView.updateRecentImages(self?.imageProviderClient.recentImages() ?? [])
                }
            }
            DispatchQueue.main.async {
                picker.dismiss(animated: true, completion: nil)
            }
        }
    }
}

extension ProfileViewController: ProfileEditorDelegate {
    func colorPickerSelected(_ avatarView: ProfileEditorView, activeColor: UIColor, source: UIView) {
        colorPickerSource = source
        showColorPicker(with: activeColor)
    }
    
    func imagePickerSelected(_ avatarView: ProfileEditorView) {
        chooseImage()
    }
}

#Preview {
    ProfileViewController()
}
