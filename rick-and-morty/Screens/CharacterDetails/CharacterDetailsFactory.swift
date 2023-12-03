//
//  CharacterDetailsFactory.swift
//  rick-and-morty
//
//  Created by Anvar Kayumov on 04/12/23.
//

import UIKit

final class CharacterDetailsFactory {
    func makeCharacterDetailsView(with id: Int) -> UIViewController {
        let viewModel = CharacterDetailsViewModel(id: id, apiService: APIService(), imageDownloader: ImageDownloader())
        let viewController = CharacterDetailsViewController(viewModel: viewModel)

        return viewController
    }
}
