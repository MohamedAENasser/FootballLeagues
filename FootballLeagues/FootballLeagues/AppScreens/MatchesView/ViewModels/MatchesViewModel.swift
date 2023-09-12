//
//  MatchesViewModel.swift
//  FootballLeagues
//
//  Created by Mohamed Abd ElNasser on 12/09/2023.
//

import Foundation

class MatchesViewModel: ObservableObject {
    let matches: [Match]
    @Published var matchesPerDay: [String : [Match]] = [:]

    // MARK: - Helper properties
    var fullMatchesList: [String : [Match]] = [:]
    var fullDaysStringList: [String] = []

    init(matches: [Match]) {
        self.matches = matches

        setupDatesData(from: matches)
    }

    func setupMatchesPerDay() {
        var matchesPerDay: [String : [Match]] = [:]

        fullDaysStringList.forEach { day in
            let matches = fullMatchesList[day]
            if let matches, !matches.isEmpty {
                matchesPerDay[day] = matches
            }
        }

        self.matchesPerDay = matchesPerDay
    }

    /// Setup fetched dates to be able to group matches per day and display them accordingly.
    private func setupDatesData(from matchesList: [Match]) {
        fullMatchesList = Dictionary(grouping: matchesList) { (match) -> String in
            Utils.matchesDateFormatter.string(from: match.matchDate)
        }

        // Setup Helper properties that will be used later for matches presentation/
        fullDaysStringList = Array(fullMatchesList.keys).sorted(by: <)
    }
}
