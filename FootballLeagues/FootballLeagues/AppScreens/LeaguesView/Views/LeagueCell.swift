//
//  LeagueCell.swift
//  FootballLeagues
//
//  Created by Mohamed Abd ElNasser on 09/09/2023.
//

import SwiftUI

struct LeagueCell: View {
    @ObservedObject var viewModel: LeagueCellViewModel
    let competition: Competition

    init(competition: Competition) {
        self.competition = competition
        viewModel = LeagueCellViewModel(competition: competition)
    }

    var body: some View {
        Button {
            var leagueMatches: [Match] = []
            if case .success(let matches) = viewModel.matchesStatus {
                leagueMatches = matches
            }
            if case .success(let teams) = viewModel.teamsStatus {
                Coordinator.shared.navigate(to: .teams(competition: competition, teams: teams, matches: leagueMatches))
            } else {
                // TODO: Show alert
            }
        } label: {
            HStack {

                logoView

                informationView

                Spacer()

            }
            .foregroundColor(Color.black)
            .onAppear {
                Task {
                    viewModel.getLogoImage()
                    await viewModel.getTeams()
                    await viewModel.getMatches()
                }
            }
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
                Text("Loading") // TODO: Handle Loading
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
                Text("Loading") // TODO: Handle Loading
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
