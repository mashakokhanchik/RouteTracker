//
//  SingUpViewController.swift
//  RouteTracker
//
//  Created by Мария Коханчик on 11.11.2021.
//

import UIKit

class SingUpViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextFielf: UITextField!
    
    // MARK: - Actions
    
    @IBAction func singUp(_ sender: Any) {
        guard let login = loginTextField.text,
              let password = passwordTextFielf.text
        else { return }
        
        if RealmService.shared.get(User.self, with: login) != nil {
            let alertController = UIAlertController(title: "Error",
                                                    message: "User with this login already exists",
                                                    preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK",
                                            style: .default,
                                            handler: { _ in
                RealmService.shared.save([User(login: login, password: password)])
            })
            let cancelAction = UIAlertAction(title: "Cancel",
                                             style: .cancel)
            alertController.addAction(alertAction)
            alertController.addAction(cancelAction)
            present(alertController, animated: true)
        } else {
            RealmService.shared.save([User(login: login, password: password)])
        }
    }
    
    @IBAction func goOut(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
