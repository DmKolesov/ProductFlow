//
//  NewsCollectionLayoutProvider.swift
//  ProfuctFlow
//
//  Created by Dima Kolesov on 14.04.2025.
//

import Foundation
import UIKit

final class NewsCollectionLayoutProvider {
    static func makeLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { sectionIndex, environment in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(300)
            )
            
            let group: NSCollectionLayoutGroup
            if UIDevice.current.userInterfaceIdiom == .pad {
                let containerWidth = environment.container.effectiveContentSize.width
                let columnCount = containerWidth > 800 ? 3 : 2
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .estimated(300)
                    ),
                    subitem: item,
                    count: columnCount
                )
                group.interItemSpacing = .fixed(12)
            } else {
                group = NSCollectionLayoutGroup.vertical(
                    layoutSize: itemSize,
                    subitems: [NSCollectionLayoutItem(layoutSize: itemSize)]
                )
            }
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
            section.interGroupSpacing = 12
            return section
        }
    }
}

