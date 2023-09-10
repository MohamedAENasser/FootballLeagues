//
//  LeagueCellViewModel.swift
//  FootballLeagues
//
//  Created by Mohamed Abd ElNasser on 09/09/2023.
//

import SwiftUI

class LeagueCellViewModel: ObservableObject {
    let networkService = NetworkService()
    var teamsRequest: TeamsRequest
    var matchesRequest: MatchesRequest

    let competitionID: Int
    @Published var teamsStatus: AppState<[Team]> = .loading
    @Published var matchesStatus: AppState<[Match]> = .loading

    init(competitionID: Int) {
        self.competitionID = competitionID
        self.teamsRequest = TeamsRequest(competitionID: competitionID)
        self.matchesRequest = MatchesRequest(competitionID: competitionID)
    }

    /// Get teams data from the backend.
    @MainActor func getTeams() async {
        if case .success = teamsStatus { return }

        let result = await networkService.request(teamsRequest)

        switch result {

        case .success(let response):
            teamsStatus = .success(response.teams)

        case .failure(let error):
            teamsStatus = .failure(error)
        }

    }

    /// Get matches data from the backend.
    @MainActor func getMatches() async {
        if case .success = matchesStatus { return }

        let result = await networkService.request(matchesRequest)

        switch result {

        case .success(let response):
            matchesStatus = .success(response.matches)

        case .failure(let error):
            matchesStatus = .failure(error)
        }

    }
}
