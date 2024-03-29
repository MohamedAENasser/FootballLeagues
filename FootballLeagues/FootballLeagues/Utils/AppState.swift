//
//  AppState.swift
//  FootballLeagues
//
//  Created by Mohamed Abd ElNasser on 09/09/2023.
//

import Foundation

enum AppState<T> {
    case success(T)
    case failure(AppError)
    case loading

    var value: T? {
        switch self {

        case .success(let t):
            return t

        default:
            return nil
        }
    }
}
