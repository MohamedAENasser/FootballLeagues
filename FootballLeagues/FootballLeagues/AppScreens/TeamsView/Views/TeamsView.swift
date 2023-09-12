//
//  TeamsView.swift
//  FootballLeagues
//
//  Created by Mohamed Abd ElNasser on 12/09/2023.
//

import SwiftUI

struct TeamsView: View {
    let teams: [Team]
    let matches: [Match]

    var body: some View {
        teamsListView(teams: teams)
    }

    func teamsListView(teams: [Team]) -> some View {
        // TODO: Handle Screen Title
        List(teams, id: \.id) { team in
            Button {
                let teamMatches = matches.filter { $0.homeTeam?.id == team.id || $0.awayTeam?.id == team.id }
                if teamMatches.isEmpty {
                    // TODO: Show Alert.
                } else {
                    Coordinator.shared.navigate(to: .matches(team: team, matches: teamMatches))
                }
            } label: {
                TeamCell(team: team)
                    .foregroundColor(Color.black)
            }
        }
    }
}
