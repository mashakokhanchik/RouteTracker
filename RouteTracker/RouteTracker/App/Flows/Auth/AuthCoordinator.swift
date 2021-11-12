//
//  AuthCoordinator.swift
//  RouteTracker
//
//  Created by Мария Коханчик on 09.11.2021.
//

import UIKit

final class AuthCoordinator: BaseCoordinator {
    
    // MARK: - Properties
    
    var rootController: UINavigationController?
    var onFinishFlow: (() -> Void)?
    
    override func start() {
        showLoginModule()
    }
    
    // MARK: - Private methods
    
    private func showLoginModule() {
        let controller = UIStoryboard(name: "Auth", bundle: nil)
            .instantiateViewController(LoginViewController.self)
        
        controller.onRecover = { [weak self] in
            self?.showRecoverModule()
        }
        controller.onSingIn = { [weak self] in
            self?.onFinishFlow?()
        }
        controller.onSingUp = { [weak self] in
            self?.showSingUpModule()
        }
        
        let rootController = UINavigationController(rootViewController: controller)
        setAsRoot(rootController)
        self.rootController = rootController
    }
    
    private func showRecoverModule() {
        let controller = UIStoryboard(name: "Auth", bundle: nil)
            .instantiateViewController(RecoveryPasswordViewController.self)
        rootController?.pushViewController(controller, animated: true)
    }
    
    private func showSingUpModule() {
        let controller = UIStoryboard(name: "Auth", bundle: nil)
            .instantiateViewController(SingUpViewController.self)
        rootController?.pushViewController(controller, animated: true)
    }
}
