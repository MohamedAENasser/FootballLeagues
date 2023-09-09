//
//  DataRequestProtocol.swift
//  FootballLeagues
//
//  Created by Mohamed Abd ElNasser on 09/09/2023.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
}

protocol DataRequestProtocol {
    associatedtype Response

    var baseURL: String { get }
    var urlPath: String { get }
    var method: HTTPMethod { get }
    var headers: [String : String] { get }

    func decode(_ data: Data) throws -> Response
}

extension DataRequestProtocol where Response: Decodable {
    func decode(_ data: Data) throws -> Response {
        let decoder = JSONDecoder()
        return try decoder.decode(Response.self, from: data)
    }
}

extension DataRequestProtocol {
    var url: String {
        baseURL + urlPath
    }

    var baseURL: String {
        Constants.Network.baseURL
    }

    var headers: [String : String] {
        [
            "Content-Type": "application/json",
            "X-Auth-Token": Constants.Network.apiKey
        ]
    }
}
