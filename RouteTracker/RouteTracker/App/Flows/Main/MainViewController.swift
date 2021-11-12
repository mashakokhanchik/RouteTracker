//
//  MainViewController.swift
//  RouteTracker
//
//  Created by Мария Коханчик on 09.11.2021.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - Properties
    
    var onMap: ((String) -> Void)?
    var onSingOut: (() -> Void)?
    
    // MARK: - Actions
    
    @IBAction func showMap(_ sender: Any) {
        onMap?("testing")
    }
    
    @IBAction func singOut(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "isLogin")
        onSingOut?()
    }
}
