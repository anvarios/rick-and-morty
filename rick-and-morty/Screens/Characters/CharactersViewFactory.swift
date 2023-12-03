//
//  CharactersViewFactory.swift
//  training
//
//  Created by Anvar Kayumov on 03/12/23.
//

import UIKit

final class CharactersViewFactory {
    func makeCharactersView() -> UIViewController {
        let viewModel = CharactersViewModel(apiService: APIService())
        let viewController = CharactersViewController(viewModel: viewModel)

        return viewController
    }
}
