//
//  Match.swift
//  FootballLeagues
//
//  Created by Mohamed Abd ElNasser on 10/09/2023.
//

import Foundation

// MARK: - Match
struct Match: Codable {
    let id: Int
    let utcDate: String?
    let status: Status?
    let lastUpdated: String?
    let score: Score?
    let homeTeam: Area?
    let awayTeam: Area?
}

// MARK: - Score
struct Score: Codable {
    let winner: Winner?
}

enum Winner: String, Codable {
    case awayTeam = "AWAY_TEAM"
    case draw = "DRAW"
    case homeTeam = "HOME_TEAM"
}

enum Status: String, Codable {
    case finished = "FINISHED"
    case scheduled = "SCHEDULED"
}
