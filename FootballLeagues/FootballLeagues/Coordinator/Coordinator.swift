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
        navigationController = UINavigationController(rootViewController: CoordinatorScreens.initialScreen.hostingView)
    }

    func initialViewController() -> UINavigationController {
        navigationController
    }

    func navigate(to screen: CoordinatorScreens) {
        navigationController.pushViewController(screen.hostingView, animated: true)
    }

}
