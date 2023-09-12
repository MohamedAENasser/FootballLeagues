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

    let competitionsTable = Table("competitions")

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
            try database.run(competitionsTable.create { table in
                table.column(id, primaryKey: .autoincrement)
                table.column(competitionID)
                table.column(competitionName)
                table.column(competitionEmblemURL)
                table.column(competitionLastUpdated)
            })
            print("Competition Table Created...")
        } catch {
            print(error)
        }
    }

    func insert(competition: Competition) async {
        await withCheckedContinuation { continuation in
            guard let database = db else { return continuation.resume(returning: ()) }

            let insert = competitionsTable.insert(competitionID <- competition.id,
                                                  competitionName <- competition.name,
                                                  competitionEmblemURL <- competition.emblemURL ?? "",
                                                  competitionLastUpdated <- competition.lastUpdated)
            do {
                try database.run(insert)
                return continuation.resume(returning: ())
            } catch {
                print(error)
                return continuation.resume(returning: ())
            }
        }
    }

    func getAllCompetitions() -> [Competition] {
        var competitions: [Competition] = []
        guard let database = db else { return [] }

        do {
            for competition in try database.prepare(competitionsTable) {
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
