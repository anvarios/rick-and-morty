//
//  UICollectionViewLayoutExtensions.swift
//  rick-and-morty
//
//  Created by Anvar Kayumov on 04/12/23.
//

import UIKit

extension UICollectionViewLayout {
    static func makeGridCollectionLayout(itemsInRow: Int) -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()

        let layout = UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection? in
            let fraction: CGFloat = 0.99 / CGFloat(itemsInRow)

            let smallItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )

            let containerGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalWidth(fraction)
                ),
                subitem: smallItem,
                count: itemsInRow
            )
            containerGroup.interItemSpacing = .fixed(3.0)

            let section = NSCollectionLayoutSection(group: containerGroup)
            section.orthogonalScrollingBehavior = .none
            section.interGroupSpacing = 3.0

            return section
        }, configuration: config)

        return layout
    }
}
