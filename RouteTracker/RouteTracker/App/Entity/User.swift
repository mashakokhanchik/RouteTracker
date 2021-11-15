//
//  User.swift
//  RouteTracker
//
//  Created by Мария Коханчик on 09.11.2021.
//

import Foundation
import RealmSwift

final class User: Object {
    
    // MARK: - Object properties
    
    @objc dynamic var login: String
    @objc dynamic var password: String
    
    // MARK: - Inits
    
    init(login: String, password: String) {
        self.login = login
        self.password = password
    }
    
    override init() {
        login = "admin"
        password = "123456"
    }
    
    // MARK: - Methods
    
    override class func primaryKey() -> String? {
        return "login"
    }

}
