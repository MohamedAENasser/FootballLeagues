//
//  TeamCell.swift
//  FootballLeagues
//
//  Created by Mohamed Abd ElNasser on 12/09/2023.
//

import SwiftUI

struct TeamCell: View {
    @ObservedObject var viewModel: TeamCellViewModel
    let team: Team
    var isInteractionEnabled: Bool
    let onTapAction: () -> Void

    init(team: Team, onTapAction: @escaping () -> Void = {}, isInteractionEnabled: Bool = true) {
        self.isInteractionEnabled = isInteractionEnabled
        self.team = team
        self.onTapAction = onTapAction
        viewModel = TeamCellViewModel(team: team)

        loadData()
    }

    func loadData() {
        viewModel.getLogoImage()
    }

    var body: some View {
        Button {
            guard isInteractionEnabled else { return }
            onTapAction()
        } label: {
            HStack {

                logoView

                informationView

                Spacer()

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

            teamNameView
                .padding(.bottom, 10)

            VStack(alignment: .leading) {

                Spacer()

                Text("\(team.website ?? "")")

                Spacer()

                Text("Phone: \(team.phone ?? "")")

                Spacer()
            }

        }
    }

    var teamNameView: some View {
        Text(team.name ?? "")
            .fontWeight(.bold)
    }
}

struct TeamCell_Previews: PreviewProvider {
    static var previews: some View {
        TeamCell(team: Team(id: 0, area: nil, name: "Liverpool FC", shortName: nil, tla: nil, crestURL: nil, address: nil, phone: "0000000", website: nil, email: "Liverpool FC@email.com", founded: nil, clubColors: nil, venue: nil, lastUpdated: ""))
    }
}
