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

    let competitionID: Int
    @Published var teams: [Team] = []

    init(competitionID: Int) {
        self.competitionID = competitionID
        self.teamsRequest = TeamsRequest(competitionID: competitionID)
    }

    /// Get teams data from the backend.
    @MainActor func getTeams() async {
        let result = await networkService.request(teamsRequest)

        switch result {

        case .success(let response):
            teams = response.teams

        case .failure(let error):
            print(error.localizedDescription)
            teams = []
        }

    }
}
