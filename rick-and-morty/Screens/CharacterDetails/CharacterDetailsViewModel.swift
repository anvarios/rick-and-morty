//
//  CharacterDetailsViewModel.swift
//  training
//
//  Created by Anvar Kayumov on 04/12/23.
//

import UIKit
import Combine

final class CharacterDetailsViewModel {

    var characterModel = CurrentValueSubject<RCharacter?, Never>(nil)

    private let apiService: APIServiceProtocol
    private let imageDownloader: ImageDownloaderProtocol
    private let characterId: Int

    init(
        id: Int,
        apiService: APIServiceProtocol,
        imageDownloader: ImageDownloaderProtocol
    ) {
        self.characterId = id
        self.apiService = apiService
        self.imageDownloader = imageDownloader
    }

    func onViewDidLoad() {
        fetchCharacter(by: characterId)
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

    func fetchCharacter(by id: Int) {
        apiService.fetchCharacter(id) { [weak self] result in
            switch result {
            case .success(let character):
                self?.characterModel.value = character
            case .failure(let error):
                print(error)
            }
        }
    }
}
