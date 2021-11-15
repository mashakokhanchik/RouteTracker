//
//  ApplicationCoordinator.swift
//  RouteTracker
//
//  Created by Мария Коханчик on 09.11.2021.
//

import Foundation

final class ApplicationCoordinator: BaseCoordinator {
    
    override func start() {
        if UserDefaults.standard.bool(forKey: "isLogin") {
            toMain()
        } else {
            toAuth()
        }
    }
    
    // MARK: - Private methods
    
    private func toMain() {
        let coordinatior = MainCoordinator()
        coordinatior.onFinishFlow = { [weak self, weak coordinatior] in
            self?.removeDependency(coordinatior)
            self?.start()
        }
        addDependency(coordinatior)
        coordinatior.start()
    }
    
    private func toAuth() {
        let coordinator = AuthCoordinator()
        coordinator.onFinishFlow = { [weak self, weak coordinator] in
            self?.removeDependency(coordinator)
            self?.start()
        }
        addDependency(coordinator)
        coordinator.start()
    }

}
