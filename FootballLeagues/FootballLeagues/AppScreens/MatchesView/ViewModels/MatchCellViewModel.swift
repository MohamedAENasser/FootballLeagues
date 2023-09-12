//
//  MatchCellViewModel.swift
//  FootballLeagues
//
//  Created by Mohamed Abd ElNasser on 12/09/2023.
//

import SwiftUI
import Combine

class MatchCellViewModel: ObservableObject {
    private var match: Match?
    @Published var homeTeamScore: String = "-"
    @Published var awayTeamScore: String = "-"
    @Published var homeTeamScoreColor: Color = .black
    @Published var awayTeamScoreColor: Color = .black
    @Published var status: Match.Status = .finished
    @Published var matchTime: String = ""

    // UI properties
    private let drawColor: Color = .black
    private let winnerColor: Color = .green
    private let loserColor: Color = .red

    /// Setup teams details for the match.
    func setup(with match: Match) {
        self.match = match

        // Setup scores if the match finished
        if match.status == .finished {
            if let homeTeamScoreValue = match.score?.fullTime.homeTeam {
                homeTeamScore = "\(homeTeamScoreValue)"
            }

            if let awayTeamScoreValue = match.score?.fullTime.awayTeam {
                awayTeamScore = "\(awayTeamScoreValue)"
            }
        }

        status = match.status ?? .finished

        setupMatchTime()
        setupScoresColors()
    }

    /// Setup the proper format of match time to be in hours and minutes, `hh:mm` format.
    private func setupMatchTime() {
        guard let date = match?.matchDate else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        matchTime = dateFormatter.string(from: date)
    }

    /// Setup the proper colors for each team.
    private func setupScoresColors() {
        guard let winner = match?.score?.winner, winner != Match.Winner.draw else {
            homeTeamScoreColor = drawColor
            awayTeamScoreColor = drawColor
            return
        }
        homeTeamScoreColor = match?.score?.winner == Match.Winner.homeTeam ? winnerColor : loserColor
        awayTeamScoreColor = match?.score?.winner == Match.Winner.awayTeam ? winnerColor : loserColor
    }
}
