//
//  Competition.swift
//  FootballLeagues
//
//  Created by Mohamed Abd ElNasser on 09/09/2023.
//

import Foundation

// MARK: - Competition
struct Competition: Codable {
    let id: Int
    let name: String
    let emblemURL, code: String?
    let plan: String?
    let numberOfAvailableSeasons: Int?
    let lastUpdated: String?

    enum CodingKeys: String, CodingKey {
        case id, name, code, plan, numberOfAvailableSeasons, lastUpdated
        case emblemURL = "emblemUrl"
    }
}
