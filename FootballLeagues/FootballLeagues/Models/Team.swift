//
//  Team.swift
//  FootballLeagues
//
//  Created by Mohamed Abd ElNasser on 09/09/2023.
//

import Foundation

// MARK: - Team
struct Team: Codable {
    let id: Int?
    let name, code: String?
    let emblemURL: String?
    let plan: String?
    let numberOfAvailableSeasons: Int?
    let lastUpdated: String?

    enum CodingKeys: String, CodingKey {
        case id, name, code, plan, numberOfAvailableSeasons, lastUpdated
        case emblemURL = "emblemUrl"
    }
}
