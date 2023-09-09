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

    /// Base URL
    var baseURL: String { get }
    /// URL Path
    var urlPath: String { get }
    /// Method type, e.g. GET, PUT etc
    var method: HTTPMethod { get }
    /// Headers of the Request
    var headers: [String : String] { get }
    /// Sample data is used to load data from local file or hardcoded models, mainly used for testing purposes
    var sampleData: Response? { get }

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

    var sampleData: Response? { nil }
}

extension DataRequestProtocol {
    func getModelFromFile(with name: String) throws -> Response {
        guard let path = Bundle.main.path(forResource: name, ofType: "json") else {
            throw AppError.failedToLoadData
        }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            return try decode(data)
        } catch {
            print(error)
            throw AppError.failedToLoadData
        }
    }
}
