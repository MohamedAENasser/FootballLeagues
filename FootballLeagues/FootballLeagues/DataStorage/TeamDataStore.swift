//
//  TeamDataStore.swift
//  FootballLeagues
//
//  Created by Mohamed Abd ElNasser on 10/09/2023.
//

import Foundation
import SQLite

class TeamDataStore {

    static let teamDBDirName = "teamDB"
    static let storeName = "team.sqlite3"

    private let teamsTable = Table("teams")

    // team properties
    private let id = Expression<Int64>("id")
    private let teamID = Expression<Int>("teamID")
    private let competitionID = Expression<Int>("competitionID")
    private let teamAreaID = Expression<Int>("teamAreaID")
    private let teamAreaName = Expression<String>("teamAreaName")
    private let teamName = Expression<String>("teamName")
    private let teamCrestURL = Expression<String>("teamCrestURL")
    private let teamAddress = Expression<String>("teamAddress")
    private let teamPhone = Expression<String>("teamPhone")
    private let teamWebsite = Expression<String>("teamWebsite")
    private let teamEmail = Expression<String>("teamEmail")
    private let teamFounded = Expression<Int>("teamFounded")
    private let teamClubColors = Expression<String>("teamClubColors")
    private let teamLastUpdated = Expression<String>("teamLastUpdated")
    private let teamShortName = Expression<String>("teamShortName")
    private let teamTla = Expression<String>("teamTla")
    private let teamVenue = Expression<String>("teamVenue")

    static let shared = TeamDataStore()

    private var db: Connection? = nil

    private init() {
        guard let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            db = nil
            return
        }
        let dirPath = docDir.appendingPathComponent(Self.teamDBDirName)

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
            try database.run(teamsTable.create { table in
                table.column(id, primaryKey: .autoincrement)
                table.column(teamID)
                table.column(competitionID)
                table.column(teamAreaID)
                table.column(teamAreaName)
                table.column(teamName)
                table.column(teamCrestURL)
                table.column(teamAddress)
                table.column(teamPhone)
                table.column(teamWebsite)
                table.column(teamEmail)
                table.column(teamFounded)
                table.column(teamClubColors)
                table.column(teamLastUpdated)
                table.column(teamShortName)
                table.column(teamTla)
                table.column(teamVenue)

                // Linking teams table with competitions table with the foreign key as a competition id.
                table.foreignKey(competitionID, references: CompetitionDataStore.shared.competitionsTable, competitionID)
            })
            print("Teams Table Created...")
        } catch {
            print(error)
        }
    }

    func insert(team: Team, competitionID: Int) async {
        await withCheckedContinuation { continuation in
            guard let database = db else { return continuation.resume(returning: ()) }

            let insert = teamsTable.insert(teamID <- team.id,
                                           teamAreaID <- team.area?.id ?? 0,
                                           teamAreaName <- team.area?.name ?? "",
                                           teamName <- team.name ?? "",
                                           teamCrestURL <- team.crestURL ?? "",
                                           teamAddress <- team.address ?? "",
                                           teamPhone <- team.phone ?? "",
                                           teamWebsite <- team.website ?? "",
                                           teamEmail <- team.email ?? "",
                                           teamFounded <- team.founded ?? 0,
                                           teamClubColors <- team.clubColors ?? "",
                                           teamLastUpdated <- team.lastUpdated,
                                           teamShortName <- team.shortName ?? "",
                                           teamTla <- team.tla ?? "",
                                           teamVenue <- team.venue ?? "",
                                           self.competitionID <- competitionID)
            do {
                try database.run(insert)
                return continuation.resume(returning: ())
            } catch {
                print(error)
                return continuation.resume(returning: ())
            }
        }
    }

    func getAllTeams(for competitionID: Int) -> [Team] {
        var teams: [Team] = []
        guard let database = db else { return [] }

        do {
            for team in try database.prepare(self.teamsTable) {
                if team[self.competitionID] == competitionID {
                    teams.append(Team(
                        id: team[teamID],
                        area: Area(id: team[teamAreaID], name: team[teamAreaName]),
                        name: team[teamName],
                        shortName: team[teamShortName],
                        tla: team[teamTla],
                        crestURL: team[teamCrestURL],
                        address: team[teamAddress],
                        phone: team[teamPhone],
                        website: team[teamWebsite],
                        email: team[teamEmail],
                        founded: team[teamFounded],
                        clubColors: team[teamClubColors],
                        venue: team[teamVenue],
                        lastUpdated: team[teamLastUpdated])
                    )
                }
            }
        } catch {
            print(error)
        }
        return teams
    }
}
