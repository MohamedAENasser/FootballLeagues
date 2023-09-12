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
    case teams(competition: Competition, teams: [Team])

    var hostingView: UIHostingController<AnyView> {
        switch self {

        case .initialScreen:
            return UIHostingController(rootView: AnyView(LeaguesView())) // Change initial screen if needed

        case .leagues:
            return UIHostingController(rootView: AnyView(LeaguesView()))

        case .teams(_, let teams):
            return UIHostingController(rootView: AnyView(TeamsView(teams: teams)))
        }
    }

    var title: String {
        switch self {

        case .initialScreen, .leagues:
            return "Football Leagues"

        case .teams(let competition, _):
            return "\(competition.name) Teams"
        }
    }
}
