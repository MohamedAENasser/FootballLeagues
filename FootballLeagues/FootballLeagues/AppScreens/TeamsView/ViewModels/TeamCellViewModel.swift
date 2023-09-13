//
//  TeamCellViewModel.swift
//  FootballLeagues
//
//  Created by Mohamed Abd ElNasser on 12/09/2023.
//

import SwiftUI
import Combine

class TeamCellViewModel: ObservableObject {
    private var imageLoader: ImageLoaderProtocol
    let team: Team
    @Published private var fetchedImage: UIImage?
    @Published var logoImage: UIImage?

    init(team: Team, imageLoader: ImageLoaderProtocol = ImageLoader()) {
        self.team = team
        self.imageLoader = imageLoader

        setupBindings()
    }

    func getLogoImage() {
        guard let urlString = self.team.crestURL,
            let cachedImage = imageLoader.getImage(urlString: urlString) else { return }
        DispatchQueue.main.async {
            self.fetchedImage = cachedImage
        }
    }

    private func setupBindings() {
        $fetchedImage.subscribe(Subscribers.Sink(
            receiveCompletion: { _ in
            }, receiveValue: { [weak self] image in
                guard let self else { return }
                DispatchQueue.main.async {
                    self.logoImage = image
                }
            }))

        imageLoader.didUpdateImagesList = { [weak self] urlString in
            guard let self,
                urlString == team.crestURL,
                self.logoImage == nil,
                let image = self.imageLoader.getImage(urlString: urlString) else { return }
            DispatchQueue.main.async {
                self.fetchedImage = image
            }
        }
    }
}
