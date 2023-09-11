//
//  CoordinatorScreens.swift
//  FootballLeagues
//
//  Created by Mohamed Abd ElNasser on 11/09/2023.
//

import SwiftUI

enum CoordinatorScreens {
    case initialScreen
    case leagues

    var hostingView: UIHostingController<AnyView> {
        switch self {

        case .initialScreen:
            return UIHostingController(rootView: AnyView(LeaguesView())) // Change initial screen if needed

        case .leagues:
            return UIHostingController(rootView: AnyView(LeaguesView()))

        }
    }
}
