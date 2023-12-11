//
//  ProfileView.swift
//  CraftTestTask
//
//  Created by iurii iaremenko on 10.12.2023.
//

import Foundation
import SwiftUI

struct ProfileView: UIViewControllerRepresentable {
    typealias UIViewControllerType = ProfileViewController

    func makeUIViewController(context: Context) -> ProfileViewController {
        ProfileViewController()
    }

    func updateUIViewController(_ uiViewController: ProfileViewController, context: Context) {

    }
}

#Preview(body: {
    ProfileView()
})
