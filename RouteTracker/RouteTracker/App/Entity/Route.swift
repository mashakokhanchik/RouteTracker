//
//  Route.swift
//  RouteTracker
//
//  Created by Мария Коханчик on 06.11.2021.
//

import Foundation
import RealmSwift
import CoreLocation

final class Position: Object {
    
    // MARK: - Object properties
    
    @objc dynamic var latitude: Double
    @objc dynamic var longitude: Double
    
    // MARK: - Inits
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    override init() {
        latitude = 0.0
        longitude = 0.0
    }

}

final class Route: Object {
    
    // MARK: - Properties
    
    @objc dynamic var id: String = UUID.init().uuidString
    let routePath = List<Position>()
    
    // MARK: - Methods
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func addPosition(with coordinate: CLLocationCoordinate2D) {
        routePath.append(Position(latitude: coordinate.latitude,
                                  longitude: coordinate.longitude))
    }
    
}
