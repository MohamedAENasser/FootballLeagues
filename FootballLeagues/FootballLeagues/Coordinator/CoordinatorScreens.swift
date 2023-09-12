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
    case teams(competition: Competition, teams: [Team], matches: [Match])
    case matches(team: Team, matches: [Match])

    var hostingView: UIHostingController<AnyView> {
        switch self {

        case .initialScreen:
            return UIHostingController(rootView: AnyView(LeaguesView())) // Change initial screen if needed

        case .leagues:
            return UIHostingController(rootView: AnyView(LeaguesView()))

        case .teams(_, let teams, let matches):
            return UIHostingController(rootView: AnyView(TeamsView(teams: teams, matches: matches)))

        case .matches(let team, let matches):
            return UIHostingController(rootView: AnyView(MatchesView(team: team, matches: matches)))
        }
    }

    var title: String {
        switch self {

        case .initialScreen, .leagues:
            return "Football Leagues"

        case .teams(let competition, _, _):
            return "\(competition.name) Teams"

        case .matches(let team, _):
            return "\(team.name ?? "") Matches"
        }
    }
}
