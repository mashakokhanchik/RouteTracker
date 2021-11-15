//
//  RecoveryPasswordViewController.swift
//  RouteTracker
//
//  Created by Мария Коханчик on 11.11.2021.
//

import UIKit

class RecoveryPasswordViewController: UIViewController {
    
    // MARK: - Properties
    
    lazy var curtainDisplayView: CurtainDisplayView = CurtainDisplayView()
    
    // MARK: - Outlets
    
    @IBOutlet weak var loginTextField: UITextField! {
        didSet {
            loginTextField.autocorrectionType = .no
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
    
    private override func addObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appMovedToBackground),
                                               name: UIApplication.willResignActiveNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appBecomesActive),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
    }
    
    // MARK: - Private methods for password
    
    private func showPassword(_ password: String) {
        let alertController = UIAlertController(title: "Password",
                                                message: password,
                                                preferredStyle: .alert)
        let alertActoin = UIAlertAction(title: "OK",
                                        style: .cancel)
        alertController.addAction(alertActoin)
        present(alertController, animated: true)
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
    }
    
    // MARK: - Actions
    
    @IBAction func recovery(_ sender: Any) {
        guard let login = loginTextField.text,
              let user = RealmService.shared.get(User.self, with: login)
        else { return }
        showPassword(user.password)
    }
    
}
