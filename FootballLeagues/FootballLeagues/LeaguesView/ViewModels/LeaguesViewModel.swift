//
//  LeaguesViewModel.swift
//  FootballLeagues
//
//  Created by Mohamed Abd ElNasser on 09/09/2023.
//

import SwiftUI

class LeaguesViewModel: ObservableObject {
    let networkService = NetworkService()
    var request = CompetitionsRequest()
    @Published var state: AppState<[Competition]> = .loading
    
    /// Get competitions data from the backend.
    @MainActor func getCompetitions() async {
        state = .loading

        let result = await networkService.request(request)

        switch result {

        case .success(let response):
            state = .success(response.competitions)

        case .failure(let error):
            state = .failure(error)
        }

    }
}
