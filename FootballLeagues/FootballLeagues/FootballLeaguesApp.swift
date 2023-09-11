//
//  FootballLeaguesApp.swift
//  FootballLeagues
//
//  Created by Mohamed Abd ElNasser on 07/09/2023.
//

import UIPilot
import SwiftUI

@main
struct FootballLeaguesApp: App {

    private let pilot: UIPilot<AppCoordinator>

    init() {
        pilot = .init(initial: .leagues)
    }

    var body: some Scene {
        WindowGroup {
            UIPilotHost(pilot) { route in
                switch route {
                case .leagues:
                    AnyView(
                        LeaguesView(viewModel: LeaguesViewModel(pilot: pilot))
                    )
                case .teams:
                    AnyView(
                        TeamsView(viewModel: TeamsViewModel(pilot: pilot))
                    )
                }
            }
        }
    }
}
