//
//  LoadingView.swift
//  FootballLeagues
//
//  Created by Mohamed Abd ElNasser on 10/09/2023.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {}
            .modifier(ActivityIndicatorModifier(isLoading: true))
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
