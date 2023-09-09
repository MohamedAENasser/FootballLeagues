//
//  TeamsResponse.swift
//  FootballLeagues
//
//  Created by Mohamed Abd ElNasser on 09/09/2023.
//

import Foundation

struct TeamsResponse: Codable {
    let count: Int
    let teams: [Team]
}
