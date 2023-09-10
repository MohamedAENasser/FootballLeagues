//
//  LoadingView.swift
//  FootballLeagues
//
//  Created by Mohamed Abd ElNasser on 10/09/2023.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.gray.ignoresSafeArea(.all)

            ProgressView()
                .progressViewStyle(.circular)
                .scaleEffect(4)
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
