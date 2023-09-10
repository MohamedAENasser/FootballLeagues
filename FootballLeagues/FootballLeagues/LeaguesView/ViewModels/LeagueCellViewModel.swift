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
    private var imageLoader: ImageLoaderProtocol

    let competition: Competition
    @Published var teamsStatus: AppState<[Team]> = .loading
    @Published var matchesStatus: AppState<[Match]> = .loading
    @Published var logoImage: UIImage?

    init(competition: Competition, imageLoader: ImageLoaderProtocol = ImageLoader()) {
        self.competition = competition
        self.teamsRequest = TeamsRequest(competitionID: competition.id)
        self.matchesRequest = MatchesRequest(competitionID: competition.id)
        self.imageLoader = imageLoader

        setupBindings()
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

    func getLogoImage() {
        DispatchQueue.main.async {
            guard let urlString = self.competition.emblemURL else { return }
            self.logoImage = self.imageLoader.getImage(urlString: urlString)
        }
    }

    private func setupBindings() {
        imageLoader.didUpdateImagesList = { [weak self] urlString in
            guard let self = self, urlString == competition.emblemURL, self.logoImage == nil else { return }
            DispatchQueue.main.async {
                self.logoImage = self.imageLoader.getImage(urlString: urlString)
            }
        }
    }
}
