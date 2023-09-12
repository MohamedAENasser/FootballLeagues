//
//  LeagueCellViewModel.swift
//  FootballLeagues
//
//  Created by Mohamed Abd ElNasser on 09/09/2023.
//

import SwiftUI

class LeagueCellViewModel: ObservableObject {
    let networkService: NetworkServiceProtocol
    var teamsRequest: TeamsRequest
    var matchesRequest: MatchesRequest
    private var imageLoader: ImageLoaderProtocol

    let competition: Competition
    @Published var teamsStatus: AppState<[Team]> = .loading
    @Published var matchesStatus: AppState<[Match]> = .loading
    @Published var logoImage: UIImage?

    init(competition: Competition, networkService: NetworkServiceProtocol = NetworkService(), imageLoader: ImageLoaderProtocol = ImageLoader()) {
        self.networkService = networkService
        self.competition = competition
        self.teamsRequest = TeamsRequest(competitionID: competition.id)
        self.matchesRequest = MatchesRequest(competitionID: competition.id)
        self.imageLoader = imageLoader

        setupBindings()
    }

    /// Get teams data from the backend.
    @MainActor func getTeams() async {
        if case .success = teamsStatus { return }

        // Getting data from local storage
        let storedTeams = TeamDataStore.shared.getAllTeams(for: competition.id)
        guard storedTeams.isEmpty else {
            teamsStatus = .success(storedTeams)
            return
        }

        // Getting Data from the server
        let result = await networkService.request(teamsRequest)

        switch result {

        case .success(let response):
            teamsStatus = .success(response.teams)
            // Save fetched teams to local storage
            storeTeamsToDB(response.teams)

        case .failure(let error):
            teamsStatus = .failure(error)
        }

    }

    /// Get matches data from the backend.
    @MainActor func getMatches() async {
        if case .success = matchesStatus { return }

        // Getting data from local storage
        let storedMatches = MatchDataStore.shared.getAllMatches(for: competition.id)
        guard storedMatches.isEmpty else {
            matchesStatus = .success(storedMatches)
            return
        }

        // Getting Data from the server
        let result = await networkService.request(matchesRequest)

        switch result {

        case .success(let response):
            matchesStatus = .success(response.matches)

            // Save fetched matches to local storage
            storeMatchesToDB(response.matches)

        case .failure(let error):
            matchesStatus = .failure(error)
        }

    }

    func getLogoImage() {
        guard let urlString = competition.emblemURL,
              let cachedImage = imageLoader.getImage(urlString: urlString) else { return }
        DispatchQueue.main.async {
            self.logoImage = cachedImage
        }
    }

    private func setupBindings() {
        imageLoader.didUpdateImagesList = { [weak self] urlString in
            guard let self,
                  urlString == competition.emblemURL,
                  self.logoImage == nil,
                  let image = self.imageLoader.getImage(urlString: urlString) else { return }
            DispatchQueue.main.async {
                self.logoImage = image
            }
        }
    }

    /// Save teams to local storage
    private func storeTeamsToDB(_ teams: [Team]) {
        teams.forEach {
            TeamDataStore.shared.insert(team: $0, competitionID: competition.id)
        }
    }

    /// Save matches to local storage
    private func storeMatchesToDB(_ matches: [Match]) {
        matches.forEach {
            MatchDataStore.shared.insert(match: $0, competitionID: competition.id)
        }
    }
}
