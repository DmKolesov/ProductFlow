//
//  CollectionViewDataSource.swift
//  ProfuctFlow
//
//  Created by Dima Kolesov on 10.04.2025.
//

import UIKit

protocol SectionIdentifiable: Hashable {
    static var defaultSection: Self { get }
}

enum NewsSection: SectionIdentifiable {
    case main
    case loading

    static var defaultSection: NewsSection { .main }
    
    var id: String {
        switch self {
        case .main: return "main"
        case .loading: return "loading"
        }
    }
}

protocol CollectionViewDataSourceProtocol {
    associatedtype Section: Hashable
    associatedtype Item: Hashable
    
    func updateSnapshot(items: [Item], animating: Bool)
    func getItem(at indexPath: IndexPath) -> Item?
}

final class CollectionViewDataSource<Section: SectionIdentifiable, Item: Hashable>: UICollectionViewDiffableDataSource<Section, Item>, CollectionViewDataSourceProtocol {
    
    func updateSnapshot(items: [Item], animating: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([Section.defaultSection])
        snapshot.appendItems(items)
        apply(snapshot, animatingDifferences: animating)
    }
    
    func getItem(at indexPath: IndexPath) -> Item? {
        return itemIdentifier(for: indexPath)
    }
}
