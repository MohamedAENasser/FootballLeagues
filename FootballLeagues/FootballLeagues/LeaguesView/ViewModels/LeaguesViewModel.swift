//
//  LeaguesViewModel.swift
//  FootballLeagues
//
//  Created by Mohamed Abd ElNasser on 09/09/2023.
//

import UIPilot
import SwiftUI

class LeaguesViewModel: ObservableObject {
    let networkService: NetworkServiceProtocol
    var request = CompetitionsRequest()
    @Published var state: AppState<[Competition]> = .loading

    let pilot: UIPilot<AppCoordinator>

    init(networkService: NetworkServiceProtocol = NetworkService(), pilot: UIPilot<AppCoordinator>) {
        self.networkService = networkService
        self.pilot = pilot
    }

    /// Get competitions data from the backend.
    @MainActor func getCompetitions() async {
        state = .loading

        // Getting data from local storage
        let storedCompetitions = CompetitionDataStore.shared.getAllCompetitions()
        guard storedCompetitions.isEmpty else {
            state = .success(storedCompetitions)
            return
        }

        // Getting Data from the server
        let result = await networkService.request(request)

        switch result {

        case .success(let response):
            state = .success(response.competitions)

            // Save fetched competitions to local storage
            storeCompetitionsToDB(response.competitions)

        case .failure(let error):
            state = .failure(error)
        }
    }

    func showTeams(for competition: Competition) {
        pilot.push(.teams)
    }

    /// Save competitions to local storage
    private func storeCompetitionsToDB(_ competitions: [Competition]) {
        competitions.forEach {
            CompetitionDataStore.shared.insert(competition: $0)
        }
    }
}
