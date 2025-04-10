//
//  UICollectionView+Ext.swift
//  ProfuctFlow
//
//  Created by Dima Kolesov on 10.04.2025.
//

import Foundation
import UIKit

protocol ReusableView {
    static var reuseIdentifier: String { get }
}

extension ReusableView {
    static var reuseIdentifier: String { String(describing: self) }
}

extension UICollectionView {
    func register<T: UICollectionViewCell & ReusableView>(_ cellType: T.Type) {
        register(cellType, forCellWithReuseIdentifier: cellType.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell & ReusableView>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(
            withReuseIdentifier: T.reuseIdentifier,
            for: indexPath
        ) as? T else {
            fatalError("Failed to dequeue cell: \(T.reuseIdentifier)")
        }
        return cell
    }
}

