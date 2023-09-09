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
                List(competitions, id: \.id) { competition in
                    Text(competition.name)
                }

            case .failure(let error):
                Text(error.description) // TODO: - Error handling
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
        LeaguesView(viewModel: LeaguesViewModel())
    }
}
