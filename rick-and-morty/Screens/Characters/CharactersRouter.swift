//
//  CharactersRouter.swift
//  training
//
//  Created by Anvar Kayumov on 04/12/23.
//
import UIKit

final class CharactersRouter {
    private weak var navigationController: UINavigationController?

    init(_ navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    func openCharacterDetailsScreen(with id: Int) {
        let viewController = CharacterDetailsFactory().makeCharacterDetailsView(with: id)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
