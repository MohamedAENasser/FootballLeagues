//
//  MatchDataStore.swift
//  FootballLeagues
//
//  Created by Mohamed Abd ElNasser on 10/09/2023.
//

import Foundation
import SQLite

class MatchDataStore {

    static let matchDBDirName = "matchDB"
    static let storeName = "match.sqlite3"

    private let matchesTable = Table("matches")

    // match properties
    private let id = Expression<Int64>("id")
    private let matchID = Expression<Int>("matchID")
    private let competitionID = Expression<Int>("competitionID")
    private let matchUtcDate  = Expression<String>("matchUtcDate")
    private let matchStatus  = Expression<String>("matchStatus")
    private let matchLastUpdated  = Expression<String>("matchLastUpdated")
    private let matchScore  = Expression<String>("matchScore")
    private let matchHomeTeamID  = Expression<Int>("matchHomeTeamID")
    private let matchHomeTeamName  = Expression<String>("matchHomeTeamName")
    private let matchAwayTeamID = Expression<Int>("matchAwayTeamID")
    private let matchAwayTeamName = Expression<String>("matchAwayTeamName")

    static let shared = MatchDataStore()

    private var db: Connection? = nil

    private init() {
        guard let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            db = nil
            return
        }
        let dirPath = docDir.appendingPathComponent(Self.matchDBDirName)

        do {
            try FileManager.default.createDirectory(atPath: dirPath.path, withIntermediateDirectories: true, attributes: nil)
            let dbPath = dirPath.appendingPathComponent(Self.storeName).path
            db = try Connection(dbPath)
            createTable()
            print("SQLiteDataStorage init successfully at: \(dbPath) ")
        } catch {
            db = nil
            print("SQLiteDataStorage init error: \(error)")
        }
    }

    private func createTable() {
        guard let database = db else {
            return
        }
        do {
            try database.run(matchesTable.create { table in
                table.column(id, primaryKey: .autoincrement)
                table.column(matchID)
                table.column(competitionID)
                table.column(matchUtcDate)
                table.column(matchStatus)
                table.column(matchLastUpdated)
                table.column(matchScore)
                table.column(matchHomeTeamID)
                table.column(matchHomeTeamName)
                table.column(matchAwayTeamID)
                table.column(matchAwayTeamName)

                // Linking matches table with competitions table with the foreign key as a competition id.
                table.foreignKey(competitionID, references: CompetitionDataStore.shared.competitionsTable, competitionID)
            })
            print("Matches Table Created...")
        } catch {
            print(error)
        }
    }

    @discardableResult func insert(match: Match, competitionID: Int) -> Int64? {
        guard let database = db else { return nil }

        let insert = matchesTable.insert(matchID <- match.id,
                                         matchUtcDate <- match.utcDate ?? "",
                                         matchStatus <- match.status?.rawValue ?? "",
                                         matchLastUpdated <- match.lastUpdated ?? "",
                                         matchScore <- match.score?.winner?.rawValue ?? "",
                                         matchHomeTeamID <- match.homeTeam?.id ?? 0,
                                         matchHomeTeamName <- match.homeTeam?.name ?? "",
                                         matchAwayTeamID <- match.awayTeam?.id ?? 0,
                                         matchAwayTeamName <- match.awayTeam?.name ?? "",
                                         self.competitionID <- competitionID)
        do {
            let rowID = try database.run(insert)
            return rowID
        } catch {
            print(error)
            return nil
        }
    }

    func getAllMatches(for competitionID: Int) -> [Match] {
        var matches: [Match] = []
        guard let database = db else { return [] }

        do {
            for match in try database.prepare(self.matchesTable) {
                if match[self.competitionID] == competitionID {
                    matches.append(Match(
                        id: match[matchID],
                        utcDate: match[matchUtcDate],
                        status: Status(rawValue: match[matchStatus]),
                        lastUpdated: match[matchLastUpdated],
                        score: Score(winner: Winner(rawValue: match[matchScore])),
                        homeTeam: Area(id: match[matchHomeTeamID], name: match[matchHomeTeamName]),
                        awayTeam: Area(id: match[matchAwayTeamID], name: match[matchAwayTeamName]))
                    )
                }
            }
        } catch {
            print(error)
        }
        return matches
    }
}
