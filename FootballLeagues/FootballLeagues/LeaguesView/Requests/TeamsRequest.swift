//
//  TeamsRequest.swift
//  FootballLeagues
//
//  Created by Mohamed Abd ElNasser on 09/09/2023.
//

import Foundation

struct TeamsRequest: DataRequestProtocol {
    typealias Response = TeamsResponse

    let competitionID: Int
    var urlPath: String {
        "/competitions/\(competitionID)/teams"
    }

    var method: HTTPMethod {
        .get
    }

    var sampleData: TeamsResponse? {
        do {
            return try getModelFromFile(with: "Teams_Stub_\(competitionID)")
        } catch {
            return nil
        }
    }
}
