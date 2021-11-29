//
//  User.swift
//  RouteTracker
//
//  Created by Мария Коханчик on 09.11.2021.
//

import Foundation
import RealmSwift
import UIKit

final class User: Object {
    
    // MARK: - Object properties
    
    @objc dynamic var login: String
    @objc dynamic var password: String
    @objc dynamic var avatar: UIImage
    
    // MARK: - Inits
    
    init(login: String, password: String, avatar: UIImage) {
        self.login = login
        self.password = password
        self.avatar = avatar
    }
    
    override init() {
        login = "admin"
        password = "123456"
        avatar = ""
    }
    
    // MARK: - Methods
    
    override class func primaryKey() -> String? {
        return "login"
    }

}
