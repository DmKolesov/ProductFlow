//
//  SceneDelegate.swift
//  ProfuctFlow
//
//  Created by dmitri kolesov on 08.04.2025.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // MARK: - Properties
    
    var window: UIWindow?
    private var appRouter: AppRouter?
    private var appCoordinator: AppCoordinator?

    // MARK: - UIWindowSceneDelegate
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
      
        let window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController()
        let router = AppRouter(
            window: window,
            navigationController: navigationController
        )
        
        self.window = window
        appRouter = router
        
        appCoordinator = AppCoordinator(
            appNavigation: router,
            coordinatorFactory: DefaultCoordinatorFactory(
                moduleBuilderFactory: DefaultModuleBuilderFactory(),
                router: router
            )
        )
        appCoordinator?.start()
        router.start()
    }
}
