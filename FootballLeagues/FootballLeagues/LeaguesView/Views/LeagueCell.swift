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
        viewModel = LeagueCellViewModel(competitionID: competition.id)
    }

    var body: some View {
        HStack {

            logoView

            informationView

            Spacer()

        }
        .onAppear {
            Task {
                await viewModel.getTeams()
                await viewModel.getMatches()
            }
        }
    }

    var logoView: some View {
        HStack {
            Image("DefaultFootballLeague-icon")
                .resizable()
                .leagueLargeImageStyle()

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
            .font(.title3)
            .fontWeight(.bold)
    }

    var numberOfTeamsView: some View {
        VStack(alignment: .center, spacing: 0) {
            Text("\(viewModel.teams?.count ?? 0)")

            Image("team-icon")
                .resizable()
                .leagueSmallImageStyle()
        }
    }

    var numberOfMatchesView: some View {
        VStack(alignment: .center, spacing: 0) {
            Text("\(viewModel.matches?.count ?? 0)")

            Image("match-icon")
                .resizable()
                .leagueSmallImageStyle()
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
