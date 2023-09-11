//
//  TeamsViewModel.swift
//  FootballLeagues
//
//  Created by Mohamed Abd ElNasser on 11/09/2023.
//

import UIPilot
import Foundation

class TeamsViewModel: ObservableObject {

    private let appPilot: UIPilot<AppCoordinator>

    init(pilot: UIPilot<AppCoordinator>) {
        self.appPilot = pilot
    }
}
