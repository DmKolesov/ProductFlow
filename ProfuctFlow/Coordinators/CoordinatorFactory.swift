//
//  CoordinatorFactory.swift
//  ProfuctFlow
//
//  Created by Dima Kolesov on 08.04.2025.
//

import Foundation

protocol CoordinatorFactory {
    func makeNewsFlow() -> Coordinator
}
