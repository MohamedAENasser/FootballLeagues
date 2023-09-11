//
//  TeamsView.swift
//  FootballLeagues
//
//  Created by Mohamed Abd ElNasser on 11/09/2023.
//

import SwiftUI
import UIPilot

struct TeamsView: View {

    @ObservedObject var viewModel: TeamsViewModel

    var body: some View {
        Text("Hello, World!")
    }
}

struct TeamsView_Previews: PreviewProvider {
    static var previews: some View {
        TeamsView(viewModel: TeamsViewModel(pilot: UIPilot<AppCoordinator>(initial: .teams)))
    }
}
