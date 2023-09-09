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
    let matchDay: Int?
    let stage: String?
    let lastUpdated: String?
    let score: Score?
    let homeTeam, awayTeam: Area?
    let referees: [Referee]?

    enum CodingKeys: String, CodingKey {
        case id, utcDate, status, stage, lastUpdated, score, homeTeam, awayTeam, referees
        case matchDay = "matchday"
    }
}

// MARK: - Referee
struct Referee: Codable {
    let id: Int?
    let name: String?
    let role: Role?
    let nationality: String?
}

enum Role: String, Codable {
    case referee = "REFEREE"
}

// MARK: - Score
struct Score: Codable {
    let winner: Winner?
    let duration: String?
    let fullTime, halfTime, extraTime, penalties: ExtraTime?
}

// MARK: - ExtraTime
struct ExtraTime: Codable {
    let homeTeam, awayTeam: Int?
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
