//
//  DefaultCoordinatorFactory.swift
//  ProfuctFlow
//
//  Created by Dima Kolesov on 10.04.2025.
//

import Foundation

final class DefaultCoordinatorFactory: CoordinatorFactory {
    private let moduleBuilderFactory: ModuleBuilderFactory
    private let router: RouterProtocol
    
    init(moduleBuilderFactory: ModuleBuilderFactory, router: RouterProtocol) {
        self.moduleBuilderFactory = moduleBuilderFactory
        self.router = router
    }
    
    func makeNewsFlow() -> Coordinator {
        let moduleBuilder = moduleBuilderFactory.makeNewsModuleBuilder()
        return NewsCoordinator(router: router, moduleBuilder: moduleBuilder)
    }
}

