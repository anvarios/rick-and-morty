//
//  CharacterViewCellViewModel.swift
//  training
//
//  Created by Anvar Kayumov on 04/12/23.
//

import UIKit

final class CharacterViewCellViewModel {
    private let imageDownloader: ImageDownloaderProtocol

    init(imageDownloader: ImageDownloaderProtocol) {
        self.imageDownloader = imageDownloader
    }

    func downloadImage(from url: URL, completion: @escaping  (UIImage?) -> Void) {
        imageDownloader.downloadImage(from: url) { result in
            switch result {
            case .success(let data):
                completion(UIImage(data: data))
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }

    func cancelImageDownloading() {
        imageDownloader.cancel()
    }
}
