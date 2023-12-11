//
//  ImageProviderClient.swift
//  CraftTestTask
//
//  Created by iurii iaremenko on 11.12.2023.
//

import Foundation
import class UIKit.UIImage

class ImageProviderClient {
    private var images: [Data] =
    // mocks
    [
        UIImage(resource: .image01).pngData()!,
        UIImage(resource: .image02).pngData()!,
        UIImage(resource: .image03).pngData()!,
        UIImage(resource: .image01).pngData()!,
        UIImage(resource: .image02).pngData()!,
        UIImage(resource: .image03).pngData()!,
        UIImage(resource: .image01).pngData()!,
        UIImage(resource: .image02).pngData()!,
        UIImage(resource: .image03).pngData()!,
        UIImage(resource: .image01).pngData()!,
        UIImage(resource: .image02).pngData()!,
        UIImage(resource: .image03).pngData()!
    ]

    func recentImages() -> [Data] {
        images
    }

    func saveImage(data: Data) {
        images.insert(data, at: 0)
        // consume image data from the user
    }
}
