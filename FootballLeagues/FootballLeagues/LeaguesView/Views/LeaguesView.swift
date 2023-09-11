//
//  LeaguesView.swift
//  FootballLeagues
//
//  Created by Mohamed Abd ElNasser on 09/09/2023.
//

import UIPilot
import SwiftUI

struct LeaguesView: View {
    @ObservedObject var viewModel: LeaguesViewModel

    var body: some View {
        ZStack {
            //MARK: - Handle App States
            switch viewModel.state {
            case .success(let competitions):
                List(competitions, id: \.id) { competition in
                    LeagueCell(competition: competition)
                        .onTapGesture {
                            viewModel.showTeams(for: competition)
                        }
                }

            case .failure(let error):
                Text(error.description) // TODO: - Error handling

            case .loading:
                LoadingView()
            }
        }
        .navigationTitle("Football leagues")
        .onAppear {
            Task {
                await viewModel.getCompetitions()
            }
        }
    }
}

struct LeaguesView_Previews: PreviewProvider {
    static var previews: some View {
        LeaguesView(viewModel: LeaguesViewModel(pilot: UIPilot<AppCoordinator>(initial: .leagues)))
    }
}
