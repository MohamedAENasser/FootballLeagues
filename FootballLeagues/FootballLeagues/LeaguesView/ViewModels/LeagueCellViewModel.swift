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
    @Published var teams: [Team]?
    @Published var matches: [Match]?

    init(competitionID: Int) {
        self.competitionID = competitionID
        self.teamsRequest = TeamsRequest(competitionID: competitionID)
        self.matchesRequest = MatchesRequest(competitionID: competitionID)
    }

    /// Get teams data from the backend.
    @MainActor func getTeams() async {
        if teams != nil { return }

        let result = await networkService.request(teamsRequest)

        switch result {

        case .success(let response):
            teams = response.teams

        case .failure(let error):
            print(error.localizedDescription)
            teams = []
        }

    }

    /// Get matches data from the backend.
    @MainActor func getMatches() async {
        if matches != nil { return }

        let result = await networkService.request(matchesRequest)

        switch result {

        case .success(let response):
            matches = response.matches

        case .failure(let error):
            print(error.localizedDescription)
            matches = []
        }

    }
}
