//
//  TeamsView.swift
//  FootballLeagues
//
//  Created by Mohamed Abd ElNasser on 12/09/2023.
//

import SwiftUI

enum TeamsViewSections: Int {
    case competition = 0
    case teams
}

struct TeamsView: View {
    let competition: Competition
    let teams: [Team]
    let matches: [Match]
    private let sections: [TeamsViewSections] = [.competition, .teams]

    var body: some View {
        teamsListView(teams: teams)
            .navigationBarTitle(CoordinatorScreens.teams(competition: competition, teams: teams, matches: matches).title)
    }

    func teamsListView(teams: [Team]) -> some View {
        List {
            ForEach(sections, id: \.self) { section in
                if section == .competition {
                    competitionSection()
                } else if section == .teams {
                    ForEach(teams) { team in
                        teamCell(team)
                    }
                }
            }
        }
    }

    func competitionSection() -> some View {
        Section {
            LeagueCell(competition: competition, isInteractionEnabled: false)
        }
    }

    func teamCell(_ team: Team) -> some View {
        TeamCell(team: team) {
            let teamMatches = matches.filter { $0.homeTeam?.id == team.id || $0.awayTeam?.id == team.id }
            if teamMatches.isEmpty {
                Coordinator.shared.show(
                    .alert(
                        title: "No Matches available",
                        description: "There is no current matches scheduled for \(team.name ?? "")",
                        action: nil
                    )
                )
            } else {
                Coordinator.shared.show(.matches(team: team, matches: teamMatches))
            }
        }
        .foregroundColor(Color.black)
    }
}
