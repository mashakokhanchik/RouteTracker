//
//  RecoveryPasswordViewController.swift
//  RouteTracker
//
//  Created by Мария Коханчик on 11.11.2021.
//

import UIKit

class RecoveryPasswordViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var loginTextField: UITextField!
    
    // MARK: - Private methods
    
    private func showPassword(_ password: String) {
        let alertController = UIAlertController(title: "Password",
                                                message: password,
                                                preferredStyle: .alert)
        let alertActoin = UIAlertAction(title: "OK",
                                        style: .cancel)
        alertController.addAction(alertActoin)
        present(alertController, animated: true)
    }
    
    // MARK: - Actions
    
    @IBAction func recovery(_ sender: Any) {
        guard let login = loginTextField.text,
              let user = RealmService.shared.get(User.self, with: login)
        else { return }
        showPassword(user.password)
    }
    
}
