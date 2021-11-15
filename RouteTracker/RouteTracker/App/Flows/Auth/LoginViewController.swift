//
//  LoginViewController.swift
//  RouteTracker
//
//  Created by Мария Коханчик on 09.11.2021.
//

import UIKit

final class LoginViewController: UIViewController {
    
    var onSingIn: (() -> Void)?
    var onRecover: (() -> Void)?
    var onSingUp: (() -> Void)?
    
    // MARK: - Outlets
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - Actions
    
    @IBAction func singIn(_ sender: Any) {
        guard let login = loginTextField.text,
              let password = passwordTextField.text,
              let user = RealmService.shared.get(User.self, with: login),
              user.password == password
        else { return }
        
        UserDefaults.standard.set(true, forKey: "isLogin")
        onSingIn?()
    }
    
    @IBAction func recovery(_ sender: Any) {
        onRecover?()
    }
    
    @IBAction func singUp(_ sender: Any) {
        onSingUp?()
    }

}
