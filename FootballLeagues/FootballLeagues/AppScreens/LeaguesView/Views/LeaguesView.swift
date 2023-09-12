//
//  LeaguesView.swift
//  FootballLeagues
//
//  Created by Mohamed Abd ElNasser on 09/09/2023.
//

import SwiftUI

struct LeaguesView: View {
    @ObservedObject var viewModel = LeaguesViewModel()
    var body: some View {
        ZStack {
            //MARK: - Handle App States
            switch viewModel.state {
            case .success(let competitions):
                competitionListView(competitions: competitions)

            case .failure(let error):
                Text(error.description) // TODO: - Error handling

            case .loading:
                LoadingView()
            }
        }
        .navigationBarTitle(CoordinatorScreens.leagues.title)
        .onAppear {
            Task {
                await viewModel.getCompetitions()
            }
        }
    }

    func competitionListView(competitions: [Competition]) -> some View {
        List(competitions, id: \.id) { competition in
            LeagueCell(competition: competition)
                .foregroundColor(Color.black)
        }
    }
}

struct LeaguesView_Previews: PreviewProvider {
    static var previews: some View {
        LeaguesView(viewModel: LeaguesViewModel())
    }
}
