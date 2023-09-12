//
//  TeamsView.swift
//  FootballLeagues
//
//  Created by Mohamed Abd ElNasser on 12/09/2023.
//

import SwiftUI

struct TeamsView: View {
    let competition: Competition
    let teams: [Team]
    let matches: [Match]

    var body: some View {
        teamsListView(teams: teams)
            .navigationBarTitle(CoordinatorScreens.teams(competition: competition, teams: teams, matches: matches).title)
    }

    func teamsListView(teams: [Team]) -> some View {
        List(teams, id: \.id) { team in
            Button {
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
            } label: {
                TeamCell(team: team)
                    .foregroundColor(Color.black)
            }
        }
    }
}
