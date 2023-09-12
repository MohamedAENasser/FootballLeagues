//
//  CoordinatorScreens.swift
//  FootballLeagues
//
//  Created by Mohamed Abd ElNasser on 11/09/2023.
//

import SwiftUI

typealias AlertAction = (title: String, action: (() -> Void)?)

enum CoordinatorScreens {
    case initialScreen
    case leagues
    case teams(competition: Competition, teams: [Team], matches: [Match])
    case matches(team: Team?, matches: [Match])
    case alert(title: String, description: String, action: AlertAction?)

    var viewController: UIViewController {
        switch self {

        case .initialScreen:
            return UIHostingController(rootView: AnyView(LeaguesView())) // Change initial screen if needed

        case .leagues:
            return UIHostingController(rootView: AnyView(LeaguesView()))

        case .teams(_, let teams, let matches):
            return UIHostingController(rootView: AnyView(TeamsView(teams: teams, matches: matches)))

        case .matches(_, let matches):
            return UIHostingController(rootView: AnyView(MatchesView(matches: matches)))

        case .alert(title: let title, description: let description, let action):
            let alertController = UIAlertController(title: title, message: description, preferredStyle: .alert)
            if let action {
                alertController.addAction(UIAlertAction(title: action.title, style: .default, handler: { _ in
                    action.action?()
                }))
            }
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            return alertController
        }
    }

    var title: String {
        switch self {

        case .initialScreen, .leagues:
            return "Football Leagues"

        case .teams(let competition, _, _):
            return "\(competition.name) Teams"

        case .matches(let team, _):
            return "\(team?.name ?? "All") Matches"

        default:
            return ""
        }
    }
}
