//
//  LeagueCell.swift
//  FootballLeagues
//
//  Created by Mohamed Abd ElNasser on 09/09/2023.
//

import SwiftUI

struct LeagueCell: View {
    @ObservedObject var viewModel: LeagueCellViewModel
    private var competition: Competition
    @State private var showingEmptyTeamsAlert = false

    init(competition: Competition) {
        self.competition = competition
        viewModel = LeagueCellViewModel(competition: competition)

        loadData()
    }

    func loadData() {
        Task {
            viewModel.getLogoImage()
            await viewModel.getTeams()
            await viewModel.getMatches()
        }
    }

    var body: some View {
        Button {
            var leagueMatches: [Match] = []
            if case .success(let matches) = viewModel.matchesStatus {
                leagueMatches = matches
            }

            var leagueTeams: [Team] = []
            if case .success(let teams) = viewModel.teamsStatus {
                leagueTeams = teams
            }
            if !leagueTeams.isEmpty {
                Coordinator.shared.show(.teams(competition: competition, teams: leagueTeams, matches: leagueMatches))
            }

        } label: {
            HStack {

                logoView

                informationView

                Spacer()

            }
            .foregroundColor(Color.black)
        }
    }

    var logoView: some View {
        HStack {
            if let logoImage = viewModel.logoImage {
                Image(uiImage: logoImage)
                    .resizable()
                    .leagueLargeImageStyle()
            } else {
                Image("DefaultFootballLeague-icon")
                    .resizable()
                    .leagueLargeImageStyle()
            }
            Divider()
        }
        .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
    }

    var informationView: some View {
        VStack(alignment: .center) {

            competitionNameView
                .padding(.bottom, 10)

            HStack {

                Spacer()

                numberOfTeamsView

                Spacer()

                numberOfMatchesView

                Spacer()
            }

        }
    }

    var competitionNameView: some View {
        Text("\(competition.name)")
            .fontWeight(.bold)
    }

    var numberOfTeamsView: some View {
        switch viewModel.teamsStatus {
        case .success(let teams):
            return AnyView(
                VStack(alignment: .center, spacing: 0) {
                    Text("\(teams.count)")

                    Image("team-icon")
                        .resizable()
                        .leagueSmallImageStyle()
                }
            )

        case .loading:
            return AnyView(
                ActivityIndicator(isAnimating: .constant(true), style: .medium)
            )

        case .failure(let error):
            return AnyView(
                Text(error.description) // TODO: Error Handling
            )

        }
    }

    var numberOfMatchesView: some View {
        switch viewModel.matchesStatus {
        case .success(let matches):
            return AnyView(
                VStack(alignment: .center, spacing: 0) {
                    Text("\(matches.count)")

                    Image("match-icon")
                        .resizable()
                        .leagueSmallImageStyle()
                }
            )

        case .loading:
            return AnyView(
                ActivityIndicator(isAnimating: .constant(true), style: .medium)
            )

        case .failure(let error):
            return AnyView(
                Text(error.description) // TODO: Error Handling
            )

        }
    }

}

struct LeagueLargeImageModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 75, height: 75, alignment: .center)
            .clipShape(Circle())
    }
}

struct LeagueSmallImageModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 40, height: 30, alignment: .center)
    }
}

extension View {
    func leagueLargeImageStyle() -> some View {
        modifier(LeagueLargeImageModifier())
    }

    func leagueSmallImageStyle() -> some View {
        modifier(LeagueSmallImageModifier())
    }
}

struct LeagueCell_Previews: PreviewProvider {
    static var previews: some View {
        LeagueCell(competition: Competition(id: 0, name: "Africa", emblemURL: "", lastUpdated: ""))
    }
}
