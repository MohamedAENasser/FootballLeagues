//
//  CompetitionDataStore.swift
//  FootballLeagues
//
//  Created by Mohamed Abd ElNasser on 10/09/2023.
//

import Foundation
import SQLite

class CompetitionDataStore {

    static let competitionDBDirName = "CompetitionDB"
    static let storeName = "competition.sqlite3"

    private let competitions = Table("competitions")

    // Competition properties
    private let id = Expression<Int64>("id")
    private let competitionID = Expression<Int>("competitionID")
    private let competitionName = Expression<String>("competitionName")
    private let competitionEmblemURL = Expression<String>("emblemURL")
    private let competitionLastUpdated = Expression<String>("competitionLastUpdated")

    static let shared = CompetitionDataStore()

    private var db: Connection? = nil

    private init() {
        guard let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            db = nil
            return
        }
        let dirPath = docDir.appendingPathComponent(Self.competitionDBDirName)

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
            try database.run(competitions.create { table in
                table.column(id, primaryKey: .autoincrement)
                table.column(competitionID)
                table.column(competitionName)
                table.column(competitionEmblemURL)
                table.column(competitionLastUpdated)
            })
            print("Table Created...")
        } catch {
            print(error)
        }
    }

    @discardableResult func insert(competition: Competition) -> Int64? {
        guard let database = db else { return nil }

        let insert = competitions.insert(competitionID <- competition.id,
                                  competitionName <- competition.name,
                                  competitionEmblemURL <- competition.emblemURL ?? "",
                                  competitionLastUpdated <- competition.lastUpdated)
        do {
            let rowID = try database.run(insert)
            return rowID
        } catch {
            print(error)
            return nil
        }
    }

    func getAllCompetitions() -> [Competition] {
        var competitions: [Competition] = []
        guard let database = db else { return [] }

        do {
            for competition in try database.prepare(self.competitions) {
                competitions.append(
                    Competition(
                        id: competition[competitionID],
                        name: competition[competitionName],
                        emblemURL: competition[competitionEmblemURL],
                        lastUpdated: competition[competitionLastUpdated])
                )
            }
        } catch {
            print(error)
        }
        return competitions
    }
}
