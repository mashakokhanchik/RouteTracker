//
//  MainCoordinator.swift
//  RouteTracker
//
//  Created by Мария Коханчик on 09.11.2021.
//

import UIKit

final class MainCoordinator: BaseCoordinator {
    
    // MARK: - Properties
    
    var rootController: UINavigationController?
    var onFinishFlow: (() -> Void)?
    
    override func start() {
        showMainModule()
    }
    
    // MARK: - Private methods
    
    private func showMainModule() {
        let controller = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(MainViewController.self)
        
        controller.onMap = { [weak self] usseless in
            self?.showMapModule(usseles: usseless)
        }
        controller.onSingOut = { [weak self] in
            self?.onFinishFlow?()
        }
        let rootController = UINavigationController(rootViewController: controller)
        setAsRoot(rootController)
        self.rootController = rootController
    }
    
    private func showMapModule(usseles: String) {
        let controller = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(MapViewController.self)
        controller.usselesExampleVariable = usseles
        rootController?.pushViewController(controller, animated: true)
    }
}
