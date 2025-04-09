//
//  RouterProtocol.swift
//  ProfuctFlow
//
//  Created by Dima Kolesov on 08.04.2025.
//

import Foundation
import UIKit

// MARK: - RouterProtocol

protocol RouterProtocol: AnyObject {
    
    // MARK: - Properties
    
    var navigationController: UINavigationController { get }
    var rootViewController: UIViewController? { get }
    
    // MARK: - Navigation Management
    
    func setRoot(_ viewController: UIViewController)
    func push(_ viewController: UIViewController, animated: Bool)
    
    // MARK: - Future Extensions
    // NOTE: Методы навигации легко добавить и реализовать при необходимости
    /*
    func present(
        _ viewController: UIViewController,
        animated: Bool,
        completion: (() -> Void)?
    )
    
    func dismiss(
        animated: Bool,
        completion: (() -> Void)?
    )
    
    func pop(animated: Bool)
    func popToRoot(animated: Bool)
    func setRoots(_ viewController: UIViewController, animated: Bool)
    */
}

