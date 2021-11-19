//
//  LocationManager.swift
//  RouteTracker
//
//  Created by Мария Коханчик on 16.11.2021.
//

import Foundation
import CoreLocation
import RxSwift

final class LocationManager: NSObject {
    
    // MARK: - Properties
    
    static let instance = LocationManager()
    let locationManager = CLLocationManager()
    var location = PublishSubject<CLLocation?>()
    
    // MARK: - Inits
    
    private override init() {
        super.init()
        configureLocationManager()
    }
    
    // MARK: - Private methods
    
    private func configureLocationManager() {
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true /// Работа геолокации в фоне
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.requestAlwaysAuthorization()
    }
    
    // MARK: - Methods
    
    func requestLocation() {
        locationManager.requestLocation()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
}

// MARK: - CLLocation Manager Delegate

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location.on(.next(location))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
