//
//  AppCoordinator.swift
//  ProfuctFlow
//
//  Created by Dima Kolesov on 14.04.2025.
//

import Foundation

final class AppCoordinator: Coordinator {

    // MARK: - Properties
    
    var childCoordinators: [Coordinator] = []
    private let appNavigation: AppNavigation
    private let coordinatorFactory: CoordinatorFactory

    // MARK: - Initialization
    
    init(
        appNavigation: AppNavigation,
        coordinatorFactory: CoordinatorFactory
    ) {
        self.appNavigation = appNavigation
        self.coordinatorFactory = coordinatorFactory
    }

    // MARK: - Coordinator Lifecycle
    
    func start() {
        startNewsFlow()
    }

    // MARK: - Flow Management
    
    private func startNewsFlow() {
        let coordinator = coordinatorFactory.makeNewsFlow()
        addChild(coordinator)
        appNavigation.setRootCoordinator(coordinator)
    }
}
