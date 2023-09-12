//
//  UserDefaults+Storage.swift
//  FootballLeagues
//
//  Created by Mohamed Abd ElNasser on 12/09/2023.
//

import Foundation

extension UserDefaults {
    static var numberOfCompetitions: Int {
        get {
            UserDefaults.standard.integer(forKey: Constants.UserDefaultsKeys.numberOfCompetitions)
        } set {
            UserDefaults.standard.set(newValue, forKey: Constants.UserDefaultsKeys.numberOfCompetitions)
        }
    }

    static var numberOfTeams: [Int: Int] {
        get {
            guard let data = UserDefaults.standard.object(forKey: Constants.UserDefaultsKeys.numberOfTeams) as? Data,
                  let dictionary = try? JSONDecoder().decode([Int: Int].self, from: data) else { return [:] }
            return dictionary
        } set {
            if let encodedValue = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encodedValue, forKey: Constants.UserDefaultsKeys.numberOfTeams)
                UserDefaults.standard.synchronize()
            } else {
                print("Failed to encode teams value")
            }
        }
    }

    static var numberOfMatches: [Int: Int] {
        get {
            guard let data = UserDefaults.standard.object(forKey: Constants.UserDefaultsKeys.numberOfMatches) as? Data,
                  let dictionary = try? JSONDecoder().decode([Int: Int].self, from: data) else { return [:] }
            return dictionary
        } set {
            if let encodedValue = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encodedValue, forKey: Constants.UserDefaultsKeys.numberOfMatches)
                UserDefaults.standard.synchronize()
            } else {
                print("Failed to encode matches value")
            }
        }
    }
}
