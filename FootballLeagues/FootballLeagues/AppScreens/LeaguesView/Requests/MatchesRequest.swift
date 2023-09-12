//
//  MatchesRequest.swift
//  FootballLeagues
//
//  Created by Mohamed Abd ElNasser on 10/09/2023.
//

import Foundation

struct MatchesRequest: DataRequestProtocol {
    typealias Response = MatchesResponse

    let competitionID: Int
    var urlPath: String {
        "/competitions/\(competitionID)/matches"
    }

    var method: HTTPMethod {
        .get
    }

    var sampleData: MatchesResponse? {
        do {
            return try getModelFromFile(with: "Matches_Stub_\(competitionID)")
        } catch {
            return nil
        }
    }
}
