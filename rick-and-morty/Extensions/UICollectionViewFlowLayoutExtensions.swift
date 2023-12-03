//
//  UICollectionViewFlowLayoutExtensions.swift
//  rick-and-morty
//
//  Created by Anvar Kayumov on 03/12/23.
//

import UIKit

extension UICollectionViewFlowLayout {
    static func threeColumnLayout(collectionViewWidth width: CGFloat) -> UICollectionViewFlowLayout {
        let (padding, minimumInterItemSpacing): (CGFloat, CGFloat) = (12, 10)
        let availableWidth = width - padding * 2 - minimumInterItemSpacing * 2
        let itemWidth = availableWidth / 3
        let itemHeight = itemWidth + 40

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)

        return flowLayout
    }
}
