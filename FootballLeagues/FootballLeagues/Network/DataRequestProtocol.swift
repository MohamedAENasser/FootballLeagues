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

    var url: String { get }
    var method: HTTPMethod { get }
    var headers: [String : String] { get }
    var queryItems: [String : String] { get }

    func decode(_ data: Data) throws -> Response
}

extension DataRequestProtocol where Response: Decodable {
    func decode(_ data: Data) throws -> Response {
        let decoder = JSONDecoder()
        return try decoder.decode(Response.self, from: data)
    }
}

extension DataRequestProtocol {
    var headers: [String : String] {
        [:]
    }

    var NetworkServiceProtocol: [String : String] {
        [:]
    }
}
