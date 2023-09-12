//
//  MatchCell.swift
//  FootballLeagues
//
//  Created by Mohamed Abd ElNasser on 12/09/2023.
//

import SwiftUI

struct MatchCell: View {
    @ObservedObject private var viewModel = MatchCellViewModel()
    let match: Match

    // UI Properties
    let teamNameFont = Font.body
    let teamScoreFont = Font.body.bold()

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                homeTeamView
                awayTeamView
            }
            timeDetailsView
        }
        .onAppear {
            viewModel.setup(with: match)
        }
    }

    var homeTeamView: some View {
        HStack {
            Text(match.homeTeam?.name ?? "")
                .font(teamNameFont)

            Spacer()

            Text(viewModel.homeTeamScore)
                .font(teamScoreFont)
                .padding(.trailing)
                .foregroundColor(viewModel.homeTeamScoreColor)

        }
        .padding(.bottom, 1)
    }

    var awayTeamView: some View {
        HStack {
            Text(match.awayTeam?.name ?? "")
                .font(teamNameFont)

            Spacer()

            Text(viewModel.awayTeamScore)
                .font(teamScoreFont)
                .padding(.trailing)
                .foregroundColor(viewModel.awayTeamScoreColor)
        }
    }

    var timeDetailsView: some View {
        HStack {
            Divider()

            VStack {
                if viewModel.status == .finished {
                    Text("FT")
                    Text(viewModel.matchTime)
                } else if viewModel.status == .postponed {
                    Text("PPND")
                        .foregroundColor(.orange)
                } else {
                    Text(viewModel.matchTime)
                }
            }
        }
    }
}
