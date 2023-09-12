//
//  ErrorView.swift
//  FootballLeagues
//
//  Created by Mohamed Abd ElNasser on 13/09/2023.
//

import SwiftUI

struct ErrorView: View {
    var error: AppError
    var onTapReTry: () -> Void

    var body: some View {
        VStack {
            Image("Warning-icon")
                .resizable()
                .frame(width: 150, height: 150)
                .padding(.bottom, 50)

            Text(error.description)
                .font(.title)
                .multilineTextAlignment(.center)

            Button {
                onTapReTry()
            } label: {
                HStack {
                    Text("Try Again")

                    Image(systemName: "arrow.counterclockwise")
                }
            }
            .buttonStyle(.borderless)
            .scaleEffect(3)
            .padding(.top, 20)
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(error: AppError.failedToLoadData, onTapReTry: {})
    }
}
