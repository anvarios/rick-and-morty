//
//  CharactersViewModel.swift
//  training
//
//  Created by Anvar Kayumov on 03/12/23.
//

import Combine

protocol CharactersViewModelProtocol {
    func onViewDidLoad()
}

final class CharactersViewModel: CharactersViewModelProtocol {

    var characterModels = CurrentValueSubject<[RCharacter], Never>([])

    private let apiService: APIServiceProtocol
    private var currentPage = 1

    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }

    func onViewDidLoad() {
        fetchNextPage()
    }

    func fetchNextPage() {
        apiService.fetchCharacters(for: currentPage) { [weak self] result in
            switch result {
            case .success(let characters):
                if !characters.results.isEmpty {
                    self?.characterModels.value.append(contentsOf: characters.results)
                    self?.currentPage += 1
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
