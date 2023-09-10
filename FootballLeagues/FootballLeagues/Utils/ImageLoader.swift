//
//  ImageLoader.swift
//  FootballLeagues
//
//  Created by Mohamed Abd ElNasser on 10/09/2023.
//

import SwiftUI

protocol ImageLoaderProtocol {
    var didUpdateImagesList: (_ url: String) -> Void { get set }
    func getImage(urlString: String) -> UIImage?
}

class ImageLoader: ImageLoaderProtocol {
    static var cachedImagesList: [String: UIImage] = [:]
    private var imageDownloadQueue: Set<String> = []
    var didUpdateImagesList: (_ url: String) -> Void = { _ in }

    func getImage(urlString: String) -> UIImage? {
        let cachedImage = ImageLoader.cachedImagesList[urlString]

        if let cachedImage {
            return cachedImage
        } else {
            requestImage(urlString: urlString)
            return nil
        }
    }

    private func requestImage(urlString: String)  {
        if imageDownloadQueue.contains(urlString) { return }
        imageDownloadQueue.insert(urlString)

        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { [weak self] (data, _, _) in
            guard let self = self, let data else { return  }

            ImageLoader.cachedImagesList[urlString] = UIImage(data: data)
            imageDownloadQueue.remove(urlString)
            self.didUpdateImagesList(urlString)
        }.resume()
    }
}
