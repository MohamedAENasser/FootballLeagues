//
//  LeagueCellViewModel.swift
//  FootballLeagues
//
//  Created by Mohamed Abd ElNasser on 09/09/2023.
//

import SwiftUI
import Combine

class LeagueCellViewModel: ObservableObject {
    let networkService: NetworkServiceProtocol
    var teamsRequest: TeamsRequest
    var matchesRequest: MatchesRequest
    private var imageLoader: ImageLoaderProtocol
    let competition: Competition
    @Published var teamsStatus: AppState<[Team]> = .loading
    @Published var matchesStatus: AppState<[Match]> = .loading
    @Published var logoImage: UIImage?
    @Published private var fetchedImage: UIImage?
    

    // Storage
    private var storedTeams: [Team] = []
    private var storedMatches: [Match] = []

    init(competition: Competition, networkService: NetworkServiceProtocol = NetworkService(), imageLoader: ImageLoaderProtocol = ImageLoader()) {
        self.networkService = networkService
        self.competition = competition
        self.teamsRequest = TeamsRequest(competitionID: competition.id)
        self.matchesRequest = MatchesRequest(competitionID: competition.id)
        self.imageLoader = imageLoader

        setupBindings()
    }

    /// Get teams data from the backend.
    func getTeams() async {
        DispatchQueue.main.async {
            self.teamsStatus = .loading
        }

        if case .success = teamsStatus { return }

        // Getting data from local storage

        storedTeams = TeamDataStore.shared.getAllTeams(for: competition.id)

        print("stored count: Teams[\(competition.id)] -> \(storedTeams.count)     -<<< DataBase")
        print("stored count: Teams[\(competition.id)] -> \(UserDefaults.numberOfTeams[competition.id] ?? 0)     -<<< UserDefaults")

        if !storedTeams.isEmpty,
           let savedTeamsCount = UserDefaults.numberOfTeams[competition.id],
           storedTeams.count == savedTeamsCount {
                DispatchQueue.main.async {
                    print("Teams fetched from DataBase")
                    self.teamsStatus = .success(self.storedTeams)
                }
                return
        }

        // Getting Data from the server
        let result = await networkService.request(teamsRequest)

        switch result {

        case .success(let response):
            DispatchQueue.main.async {
                print("Teams fetched from server")
                self.teamsStatus = .success(response.teams)
            }

            // Save fetched teams count to be used later for comparison with stored on database when fetching locally
            UserDefaults.numberOfTeams[competition.id] = response.teams.count

            // Save fetched teams to local storage
            storeTeamsToDB(response.teams)

        case .failure(let error):
            DispatchQueue.main.async {
                print("Teams fetching failed from server")
                self.teamsStatus = .failure(error)
            }
        }

    }

    /// Get matches data from the backend.
    func getMatches() async {
        DispatchQueue.main.async {
            self.matchesStatus = .loading
        }

        if case .success = matchesStatus { return }

        // Getting data from local storage
        storedMatches = MatchDataStore.shared.getAllMatches(for: competition.id)

        print("stored count: Matches[\(competition.id)] -> \(storedMatches.count)     -<<< DataBase")
        print("stored count: Matches[\(competition.id)] -> \(UserDefaults.numberOfMatches[competition.id] ?? 0)     -<<< UserDefaults")

        if !storedMatches.isEmpty,
           let savedMatchesCount = UserDefaults.numberOfMatches[competition.id],
           storedMatches.count == savedMatchesCount {
                DispatchQueue.main.async {
                    print("Matches fetched from DataBase")
                    self.matchesStatus = .success(self.storedMatches)
                }
                return
        }

        // Getting Data from the server
        let result = await networkService.request(matchesRequest)

        switch result {

        case .success(let response):
            DispatchQueue.main.async {
                print("Matches fetched from server")
                self.matchesStatus = .success(response.matches)
            }

            // Save fetched matches count to be used later for comparison with stored on database when fetching locally
            UserDefaults.numberOfMatches[competition.id] = response.matches.count

            // Save fetched matches to local storage
            storeMatchesToDB(response.matches)

        case .failure(let error):
            DispatchQueue.main.async {
                print("Matches fetching failed from server")
                self.matchesStatus = .failure(error)
            }
        }

    }

    func getLogoImage() {
        guard let urlString = competition.emblemURL,
              let cachedImage = imageLoader.getImage(urlString: urlString) else { return }
        DispatchQueue.main.async {
            self.fetchedImage = cachedImage
        }
    }

    private func setupBindings() {
        $fetchedImage.subscribe(Subscribers.Sink(
            receiveCompletion: { _ in
            }, receiveValue: { [weak self] image in
                guard let self else { return }
                self.logoImage = image
            }))
        
        imageLoader.didUpdateImagesList = { [weak self] urlString in
            guard let self,
                  urlString == competition.emblemURL,
                  self.logoImage == nil,
                  let image = self.imageLoader.getImage(urlString: urlString) else { return }
            DispatchQueue.main.async {
                self.fetchedImage = image
            }
        }
    }

    /// Save teams to local storage
    private func storeTeamsToDB(_ teams: [Team]) {
        teams.forEach { team in
            /// Making DB saving as a high priority for quicker saving to DB and avoid networking for the upcoming runs,
            /// Can be adapted as business needs to be lower priority for higher performance
            Task(priority: .high) {
                guard !TeamDataStore.shared.getAllTeams(for: competition.id).contains(where: { team.id == $0.id }) else { return } // Only save teams that not exist on the DB
                await TeamDataStore.shared.insert(team: team, competitionID: competition.id)
                print("SAVING TEAM competitionID - \(competition.id) TEAMID: \(team.id)")
            }
        }
    }

    /// Save matches to local storage
    private func storeMatchesToDB(_ matches: [Match]) {

        matches.forEach { match in
            /// Making DB saving as a high priority for quicker saving to DB and avoid networking for the upcoming runs,
            /// Can be adapted as business needs to be lower priority for higher performance
            Task(priority: .high) {
                guard !MatchDataStore.shared.getAllMatches(for: competition.id).contains(where: { match.id == $0.id }) else { return } // Only save matches that not exist on the DB
                await MatchDataStore.shared.insert(match: match, competitionID: competition.id)
                print("SAVING MATCH competitionID - \(competition.id) MatchID: \(match.id)")
            }
        }
    }
}
