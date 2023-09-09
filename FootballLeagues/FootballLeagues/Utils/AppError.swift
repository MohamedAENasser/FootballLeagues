//
//  AppError.swift
//  FootballLeagues
//
//  Created by Mohamed Abd ElNasser on 09/09/2023.
//

import Foundation

enum AppError: Error {
    case invalidEndpoint
    case failedToLoadData
    case restrictedContent

    var description: String {
        switch self {
        case .invalidEndpoint:
            return "Network server is not ready in the mean time, please try again later"

        case .failedToLoadData:
            return "We couldn't load your data\n please try again"

        case .restrictedContent:
            return "Please upgrade your plan"
        }
    }
}
