//
//  Constants.swift
//  FootballLeagues
//
//  Created by Mohamed Abd ElNasser on 09/09/2023.
//

import Foundation

enum Constants {
    enum Network {
        static let apiKey = "API_Key"
        static let baseURL = "https://api.football-data.org/v2"
    }

    enum UserDefaultsKeys {
        static let numberOfCompetitions = "NumberOfCompetitionsKey"
        static let numberOfTeams = "NumberOfTeamsKey"
        static let numberOfMatches = "NumberOfMatchesKey"
    }
}
