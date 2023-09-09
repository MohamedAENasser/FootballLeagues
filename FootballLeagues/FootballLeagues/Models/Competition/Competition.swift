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
    let emblemURL: String?
    let lastUpdated: String

    enum CodingKeys: String, CodingKey {
        case id, name, lastUpdated
        case emblemURL = "emblemUrl"
    }
}
