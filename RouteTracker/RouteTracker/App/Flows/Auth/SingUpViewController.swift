//
//  SingUpViewController.swift
//  RouteTracker
//
//  Created by Мария Коханчик on 11.11.2021.
//

import UIKit

class SingUpViewController: UIViewController {
    
    // MARK: - Properties
    
    lazy var curtainDisplayView: CurtainDisplayView = CurtainDisplayView()
    
    // MARK: - Outlets
    
    @IBOutlet weak var loginTextField: UITextField! {
        didSet {
            loginTextField.autocorrectionType = .no
        }
    }
    @IBOutlet weak var passwordTextFielf: UITextField! {
        didSet {
            passwordTextFielf.isSecureTextEntry = true
            passwordTextFielf.autocorrectionType = .no
        }
    }
    
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
        passwordTextFielf.text = ""
    }
    
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
