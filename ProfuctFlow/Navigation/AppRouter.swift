//
//  AppRouter.swift
//  ProfuctFlow
//
//  Created by Dima Kolesov on 08.04.2025.
//

import Foundation
import UIKit

final class AppRouter: RouterProtocol, AppNavigation {

    // MARK: - Properties
    
    private let window: UIWindow
    internal let navigationController: UINavigationController
    private var rootCoordinator: Coordinator?
    
    var rootViewController: UIViewController? {
        navigationController.viewControllers.first
    }

    // MARK: - Initialization
    
    init(
        window: UIWindow,
        navigationController: UINavigationController = UINavigationController()
    ) {
        self.window = window
        self.navigationController = navigationController
        setupNavigationBar()
    }

    // MARK: - Setup
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
    }

    // MARK: - Window Management
    
    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    // MARK: - RouterProtocol
    
    func setRoot(_ viewController: UIViewController) {
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    func push(_ viewController: UIViewController, animated: Bool) {
        navigationController.pushViewController(viewController, animated: animated)
    }

    // MARK: - Coordinator Management
    
    func setRootCoordinator(_ coordinator: Coordinator) {
        rootCoordinator = coordinator
        coordinator.start()
    }
}

