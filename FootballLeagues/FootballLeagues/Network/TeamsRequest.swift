//
//  TeamsRequest.swift
//  FootballLeagues
//
//  Created by Mohamed Abd ElNasser on 09/09/2023.
//

import Foundation

struct TeamsRequest: DataRequestProtocol {
    typealias Response = CompetitionsResponse

    var url: String {
        let baseURL: String = "https://api.football-data.org/v2"
        let path: String = "/competitions"
        return baseURL + path
    }

    var queryItems: [String : String] {
        [
            "api_key": "" // TODO: - Add the correct api key here.
        ]
    }

    var method: HTTPMethod {
        .get
    }
}
