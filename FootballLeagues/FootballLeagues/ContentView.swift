//
//  ContentView.swift
//  FootballLeagues
//
//  Created by Mohamed Abd ElNasser on 07/09/2023.
//

import SwiftUI

struct ContentView: View {
    let networkService = NetworkService()

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            let request = TeamsRequest()
            networkService.request(request) { result in
                switch result {

                case .success(let model):
                    print(model)

                case .failure(let error):
                    print(error)

                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
