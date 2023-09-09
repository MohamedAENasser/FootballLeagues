//
//  MatchesResponse.swift
//  FootballLeagues
//
//  Created by Mohamed Abd ElNasser on 10/09/2023.
//

import Foundation

// MARK: - MatchesResponse
struct MatchesResponse: Codable {
    let count: Int
    let competition: Competition
    let matches: [Match]
}
