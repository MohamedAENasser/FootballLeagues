//
//  Match.swift
//  FootballLeagues
//
//  Created by Mohamed Abd ElNasser on 10/09/2023.
//

import Foundation

// MARK: - Match
struct Match: Codable, Identifiable {
    let id: Int
    let utcDate: String?
    let status: Status?
    let lastUpdated: String?
    let score: Score?
    let homeTeam: Area?
    let awayTeam: Area?

    var matchDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from: utcDate ?? "") ?? Date()
    }

    // MARK: - Score
    struct Score: Codable {
        let fullTime: TimeModel
        let winner: Winner?
    }

    // MARK: - ExtraTime
    struct TimeModel: Codable {
        let awayTeam, homeTeam: Int?
    }

    enum Winner: String, Codable {
        case awayTeam = "AWAY_TEAM"
        case draw = "DRAW"
        case homeTeam = "HOME_TEAM"
    }

    enum Status: String, Codable {
        case finished = "FINISHED"
        case scheduled = "SCHEDULED"
        case postponed = "POSTPONED"
    }
}
