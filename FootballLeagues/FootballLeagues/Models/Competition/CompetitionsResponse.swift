//
//  CompetitionsResponse.swift
//  FootballLeagues
//
//  Created by Mohamed Abd ElNasser on 09/09/2023.
//

import Foundation

struct CompetitionsResponse: Codable {
    let count: Int
    let competitions: [Competition]
}
