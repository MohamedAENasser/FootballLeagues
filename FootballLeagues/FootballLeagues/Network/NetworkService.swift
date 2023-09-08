//
//  NetworkService.swift
//  FootballLeagues
//
//  Created by Mohamed Abd ElNasser on 09/09/2023.
//

import Foundation

protocol NetworkServiceProtocol {
    func request<Request: DataRequestProtocol>(_ request: Request, completion: @escaping (Result<Request.Response, Error>) -> Void)
}

final class NetworkService: NetworkServiceProtocol {

    func request<Request: DataRequestProtocol>(_ request: Request, completion: @escaping (Result<Request.Response, Error>) -> Void) {

        guard var urlComponent = URLComponents(string: request.url) else {
            return completion(.failure(ErrorResponse.invalidEndpoint))
        }

        var queryItems: [URLQueryItem] = []

        request.queryItems.forEach {
            let urlQueryItem = URLQueryItem(name: $0.key, value: $0.value)
            queryItems.append(urlQueryItem)
        }

        urlComponent.queryItems = queryItems

        guard let url = urlComponent.url else {
            return completion(.failure(ErrorResponse.invalidEndpoint))
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headers

        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                return completion(.failure(error))
            }

            guard let response = response as? HTTPURLResponse, 200..<300 ~= response.statusCode,
                let data = data else {
                return completion(.failure(NSError()))
            }

            do {
                try completion(.success(request.decode(data)))
            } catch let error as NSError {
                completion(.failure(error))
            }
        }
        .resume()
    }
}
