//
//  LeaguesViewModel.swift
//  FootballLeagues
//
//  Created by Mohamed Abd ElNasser on 09/09/2023.
//

import SwiftUI

class LeaguesViewModel: ObservableObject {
    let networkService: NetworkServiceProtocol
    var request = CompetitionsRequest()
    @Published var state: AppState<[Competition]> = .loading

    // Storage
    private var storedCompetitions: [Competition] = []

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    /// Get competitions data from the backend.
    func getCompetitions() async {
        DispatchQueue.main.async {
            self.state = .loading
        }

        // Getting data from local storage
        storedCompetitions = CompetitionDataStore.shared.getAllCompetitions()

        if !storedCompetitions.isEmpty, storedCompetitions.count == UserDefaults.numberOfCompetitions {
            DispatchQueue.main.async {
                print("Competitions fetched from DataBase")
                self.state = .success(self.storedCompetitions)
            }
            return
        }

        // Getting Data from the server
        let result = await networkService.request(request)

        switch result {

        case .success(let response):
            DispatchQueue.main.async {
                print("Competitions fetched from server")
                self.state = .success(response.competitions)
            }

            // Save fetched data count to compare with stored on database when fetching locally
            UserDefaults.numberOfCompetitions = response.competitions.count

            // Save fetched competitions to local storage
            storeCompetitionsToDB(response.competitions)

        case .failure(let error):
            DispatchQueue.main.async {
                print("Competitions fetching failed")
                self.state = .failure(error)
            }
        }
    }

    /// Save competitions to local storage
    private func storeCompetitionsToDB(_ competitions: [Competition]) {
        competitions.forEach { competitionToStore in
            /// Making DB saving as a high priority for quicker saving to DB and avoid networking for the upcoming runs,
            /// Can be adapted as business needs to be lower priority for higher performance
            Task(priority: .high) {
                guard !CompetitionDataStore.shared.getAllCompetitions().contains(where: { $0.id == competitionToStore.id }) else { return } // Only save competitions that not exist on the DB
                await CompetitionDataStore.shared.insert(competition: competitionToStore)
                print("SAVING COMPETITION competitionID - \(competitionToStore.id)")
            }
        }
    }
}
