//
//  TeamsView.swift
//  FootballLeagues
//
//  Created by Mohamed Abd ElNasser on 12/09/2023.
//

import SwiftUI

struct TeamsView: View {
    let teams: [Team]

    var body: some View {
        teamsListView(teams: teams)
    }

    func teamsListView(teams: [Team]) -> some View {
        // TODO: Handle Screen Title
        List(teams, id: \.id) { team in
            Button {
                // TODO: Navigate to matches screen
            } label: {
                TeamCell(team: team)
                    .foregroundColor(Color.black)
            }
        }
    }
}
