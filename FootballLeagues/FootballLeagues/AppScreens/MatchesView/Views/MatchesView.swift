//
//  MatchesView.swift
//  FootballLeagues
//
//  Created by Mohamed Abd ElNasser on 12/09/2023.
//

import SwiftUI

enum MatchesViewSections: Int {
    case team = 0
    case matches
}

struct MatchesView: View {
    @ObservedObject private var viewModel: MatchesViewModel
    let team: Team
    let matches: [Match]
    private let sections: [MatchesViewSections] = [.team, .matches]

    init(team: Team, matches: [Match]) {
        self.team = team
        self.matches = matches
        viewModel = MatchesViewModel(matches: matches)
    }

    var body: some View {
        matchesListView(matches: matches)
            .navigationBarTitle(CoordinatorScreens.matches(team: team, matches: matches).title)
            .onAppear {
                viewModel.setupMatchesPerDay()
            }
    }

    func matchesListView(matches: [Match]) -> some View {
        List {
            ForEach(sections, id: \.self) { section in
                if section == .team {
                    Section {
                        TeamCell(team: team, isInteractionEnabled: false)
                    }
                    .foregroundColor(.black)
                } else if section == .matches {
                    ForEach(Array(viewModel.matchesPerDay.keys).sorted(by: <), id: \.self) { day in
                        daySectionView(from: day, matches: viewModel.matchesPerDay[day] ?? [])
                    }
                }
            }
        }
    }

    func daySectionView(from day: String, matches: [Match]) -> some View {
        Section(header: Text(day).font(.body).fontWeight(.bold)) {
            ForEach(matches) { match in
                MatchCell(match: match)
            }
        }
    }
}
