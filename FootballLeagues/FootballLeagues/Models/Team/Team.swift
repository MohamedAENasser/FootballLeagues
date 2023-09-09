//
//  Team.swift
//  FootballLeagues
//
//  Created by Mohamed Abd ElNasser on 09/09/2023.
//

import Foundation

// MARK: - Team
struct Team: Codable {
    let id: Int
    let area: Area?
    let name, shortName, tla: String?
    let crestURL: String?
    let address, phone: String?
    let website: String?
    let email: String?
    let founded: Int?
    let clubColors, venue: String?
    let lastUpdated: String

    enum CodingKeys: String, CodingKey {
        case id, area, name, shortName, tla
        case crestURL = "crestUrl"
        case address, phone, website, email, founded, clubColors, venue, lastUpdated
    }
}

// MARK: - Area
struct Area: Codable {
    let id: Int?
    let name: String?
}
