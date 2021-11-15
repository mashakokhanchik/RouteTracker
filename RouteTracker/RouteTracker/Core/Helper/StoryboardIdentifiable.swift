//
//  StoryboardIdentifiable.swift
//  RouteTracker
//
//  Created by Мария Коханчик on 11.11.2021.
//

import UIKit

// Protocol for objects with an identifier in the storyboard

protocol StoryboardIdentifiable {
    
static var storyboardIdentifier: String { get }

}

extension UIViewController: StoryboardIdentifiable { }

extension StoryboardIdentifiable where Self: UIViewController {

    static var storyboardIdentifier: String {
        return String(describing: self)
    }

}

extension UIStoryboard {
    
    func instantiateViewController<T: UIViewController>(_: T.Type) -> T {
        guard let viewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T
        else { fatalError("View controller with identifier \(T.storyboardIdentifier) not found") }
        
        return viewController
    }
    
    func instantiateViewController<T: UIViewController>() -> T {
        guard let viewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T
        else { fatalError("View controller with identifier \(T.storyboardIdentifier) not found") }
    
        return viewController
    }
    
}
