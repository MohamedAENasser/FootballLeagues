//
//  NetworkService.swift
//  FootballLeagues
//
//  Created by Mohamed Abd ElNasser on 09/09/2023.
//

import Foundation

protocol NetworkServiceProtocol {
    func request<Request: DataRequestProtocol>(_ request: Request) async -> Result<Request.Response, AppError>
}

final class NetworkService: NetworkServiceProtocol {

    func request<Request: DataRequestProtocol>(_ request: Request) async -> Result<Request.Response, AppError> {
        return await withCheckedContinuation { continuation in

            guard let url = URLComponents(string: request.url)?.url else {
                return continuation.resume(returning: .failure(.failedToLoadData))
            }

            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = request.method.rawValue
            urlRequest.allHTTPHeaderFields = request.headers

            URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                if error != nil {
                    return continuation.resume(returning: .failure(.invalidEndpoint))
                }

                guard let response = response as? HTTPURLResponse, 200..<300 ~= response.statusCode,
                      let data = data else {
                    return continuation.resume(returning: .failure(.failedToLoadData))
                }

                do {
                    try continuation.resume(returning: .success(request.decode(data)))
                } catch  {
                    return continuation.resume(returning: .failure(.failedToLoadData))
                }
            }
            .resume()

        }
    }
}
