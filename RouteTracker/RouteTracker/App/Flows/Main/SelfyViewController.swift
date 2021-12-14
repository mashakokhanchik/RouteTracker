//
//  SelfyViewController.swift
//  RouteTracker
//
//  Created by Мария Коханчик on 29.11.2021.
//

import UIKit

class SelfyViewController: UIViewController {

    // MARK: - Properties
    
    var avatarImage: UIImage?
    
    // MARK: - Outlets
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        avatarImageView.image = avatarImage
    }

}
