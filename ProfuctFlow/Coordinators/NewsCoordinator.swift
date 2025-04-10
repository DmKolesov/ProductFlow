//
//  NewsCoordinator.swift
//  ProfuctFlow
//
//  Created by Dima Kolesov on 08.04.2025.
//

import Foundation

final class NewsCoordinator: Coordinator {

    // MARK: - Properties
    
    var childCoordinators: [Coordinator] = []
    private let router: RouterProtocol
    private let moduleBuilder: NewsModuleBuilder

    // MARK: - Initialization
    
    init(
        router: RouterProtocol,
        moduleBuilder: NewsModuleBuilder
    ) {
        self.router = router
        self.moduleBuilder = moduleBuilder
    }

    // MARK: - Coordinator Lifecycle
    
    func start() {
        let viewController = moduleBuilder.build(with: .init(coordinator: self))
        router.push(viewController, animated: true)
    }

    // MARK: - Navigation
    
    func showDetail(with url: URL) {
        let detailVC = DetailViewController(url: url)
        router.push(detailVC, animated: true)
    }
}

