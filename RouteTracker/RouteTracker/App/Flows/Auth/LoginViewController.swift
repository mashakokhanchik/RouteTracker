//
//  LoginViewController.swift
//  RouteTracker
//
//  Created by Мария Коханчик on 09.11.2021.
//

import UIKit
import RxSwift
import RxCocoa

final class LoginViewController: UIViewController {
    

    // MARK: - Properties
    
    var onSingIn: (() -> Void)?
    var onRecover: (() -> Void)?
    var onSingUp: (() -> Void)?
    
    lazy var curtainDisplayView: CurtainDisplayView = CurtainDisplayView()
    
    // MARK: - Outlets
    
    @IBOutlet weak var loginTextField: UITextField! {
        didSet {
            loginTextField.autocorrectionType = .no
        }
    }
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.isSecureTextEntry = true
            passwordTextField.autocorrectionType = .no
        }
    }
    
    @IBOutlet weak var singInButton: UIButton!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCurtainDisplayView()
    }
    
    // MARK: - Private methods for curtain display
    
    private func setupCurtainDisplayView() {
        curtainDisplayView.frame = view.frame
        curtainDisplayView.frame.origin.y -= curtainDisplayView.frame.size.height
        if #available(iOS 13, *) {
            let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
            sceneDelegate?.window?.addSubview(curtainDisplayView)
        } else {
            UIApplication.shared.keyWindow?.addSubview(curtainDisplayView)
        }
        
        addObserver()
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appMovedToBackground),
                                               name: UIApplication.willResignActiveNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appBecomesActive),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
    }
    
    // MARK: - Methods for active and background
    
    @objc func appMovedToBackground() {
        UIView.animate(withDuration: 1.0) {
            self.curtainDisplayView.frame.origin.y += self.curtainDisplayView.frame.size.height
        }
    }
    
    @objc func appBecomesActive() {
        UIView.animate(withDuration: 1.0) {
            self.curtainDisplayView.frame.origin.y -= self.curtainDisplayView.frame.size.height
        }
        passwordTextField.text = ""
    }
    
    // MARK: - Reactive setup for SingIn button
    
    func configureSingInBindings() {
        Observable
            .combineLatest(loginTextField.rx.text,
                           passwordTextField.rx.text)
            .map { login, password in
                return !(login ?? "").isEmpty && (password ?? "").count >= 6
            }
            .bind { [weak singInButton] inputFilled in
                singInButton?.isEnabled = inputFilled
            }.dispose()
    }
    
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
