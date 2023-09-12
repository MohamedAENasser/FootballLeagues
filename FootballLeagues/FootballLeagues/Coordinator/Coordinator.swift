//
//  Coordinator.swift
//  FootballLeagues
//
//  Created by Mohamed Abd ElNasser on 11/09/2023.
//

import SwiftUI

class Coordinator {
    static let shared = Coordinator()
    private let navigationController: UINavigationController

    private init () {
        navigationController = UINavigationController(rootViewController: CoordinatorScreens.initialScreen.viewController)
    }

    func initialViewController() -> UINavigationController {
        navigationController
    }

    func show(_ screen: CoordinatorScreens) {
        switch screen {
        case .alert:
            navigationController.topViewController?.present(screen.viewController, animated: true)
        default:
            navigationController.pushViewController(screen.viewController, animated: true)
        }
    }
}
