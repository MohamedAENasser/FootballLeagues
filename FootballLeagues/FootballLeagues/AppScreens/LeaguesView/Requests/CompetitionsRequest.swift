//
//  CompetitionsRequest.swift
//  FootballLeagues
//
//  Created by Mohamed Abd ElNasser on 09/09/2023.
//

import Foundation

struct CompetitionsRequest: DataRequestProtocol {
    typealias Response = CompetitionsResponse

    var urlPath: String {
        "/competitions"
    }

    var method: HTTPMethod {
        .get
    }

    /// UnComment the following if you want to load the data from local stubs
    /*
    var sampleData: CompetitionsResponse? {
        do {
            return try getModelFromFile(with: "Competitions_Stub")
        } catch {
            return nil
        }
    }
     */
}
