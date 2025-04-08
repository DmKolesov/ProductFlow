//
//  AppNavigation.swift
//  ProfuctFlow
//
//  Created by Dima Kolesov on 08.04.2025.
//

import Foundation

protocol AppNavigation: AnyObject {
    func setRootCoordinator(_ coordinator: Coordinator)
}

