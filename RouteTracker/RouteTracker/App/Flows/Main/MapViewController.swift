//
//  MapViewController.swift
//  RouteTracker
//
//  Created by Мария Коханчик on 01.11.2021.
//

import UIKit
import GoogleMaps
import CoreLocation

class MapViewController: UIViewController {
    
    // MARK: - Properties
    
    /// Координаты центра Москвы
    let coordinate = CLLocationCoordinate2D(latitude: 55.753215, longitude: 37.622504)
    var locationManager: CLLocationManager?
    
    /// Работа в фоне
    var baskgroundTask: UIBackgroundTaskIdentifier?
    
    /// Объект маршрута и его путь
    var route: GMSPolyline?
    var routePath: GMSMutablePath?
    var routeSave: Route?
    
    /// Навигация по координаторам
    var usselesExampleVariable = ""
    
    // MARK: - Outlets

    @IBOutlet weak var mapView: GMSMapView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        baskgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            guard let self = self else { return }
            UIApplication.shared.endBackgroundTask(self.baskgroundTask!)
            self.baskgroundTask = .invalid
        }
        
        configureMap()
        configureLocationManager()
        addMarker()
    }
    
    // MARK: - Methods
    
    func configureMap() {
        /// Камера с импользавнием координат и уровнем увеличения (zoom - масштаб карты)
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 17)
        /// Установка камеры для карты
        mapView.camera = camera
        mapView.delegate = self
    }
    
    func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.allowsBackgroundLocationUpdates = true /// Работа геолокации в фоне
        locationManager?.pausesLocationUpdatesAutomatically = false
        locationManager?.startMonitoringSignificantLocationChanges()
        locationManager?.requestWhenInUseAuthorization()
    }
    func addMarker() {
        let marker = GMSMarker(position: coordinate)
        marker.icon = GMSMarker.markerImage(with: .red)
        marker.map = mapView
        //self.marker = marker
    }
    
    func saveRoute() {
        if let routeSave = routeSave {
            RealmService.shared.deleteAll()
            RealmService.shared.save([routeSave])
        }
    }
    
    // MARK: - Actions
    
    @IBAction func currientLocation(_ sender: Any) {
        locationManager?.requestLocation()
    }
    
    @IBAction func updateLocation(_ sender: Any) {
        route?.map = nil
        route = GMSPolyline()
        routePath = GMSMutablePath()
        route?.map = mapView
        
        routeSave = Route()
        
        locationManager?.startUpdatingLocation()
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    @IBAction func stopLocation(_ sender: Any) {
        locationManager?.stopUpdatingLocation()
        saveRoute()
        routeSave = nil
        
        guard let baskgroundTask = baskgroundTask else { return }
        UIApplication.shared.endBackgroundTask(baskgroundTask)
        self.baskgroundTask = .invalid
    }
    
    @IBAction func loadLastLocation(_ sender: Any) {
        locationManager?.stopUpdatingLocation()
        routeSave = nil
        
        let getLocation = RealmService.shared.get(Route.self)
        guard let lastLocation = getLocation?.last else { return }
        
        route?.map = nil
        route = GMSPolyline()
        routePath = GMSMutablePath()
        lastLocation.routePath.forEach { position in
            routePath?.add(CLLocationCoordinate2D.init(latitude: position.latitude,
                                                       longitude: position.longitude))
        }
        route?.path = routePath
        route?.map = mapView
        if let routePath = routePath {
            let cameraUpdate = GMSCameraUpdate.fit(GMSCoordinateBounds(path: routePath))
            mapView.animate(with: cameraUpdate)
        }
    }
    
}

// MARK: - GMSMap View Delegate

extension MapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print(coordinate)
    }

}

// MARK: - CLLocation Manager Delegate

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        routePath?.add(location.coordinate)
        route?.path = routePath
        routeSave?.addPosition(with: location.coordinate)
        let position = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 17)
        mapView.animate(to: position)
//        if let location = locations.first {
//            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 17, bearing: 0, viewingAngle: 0)
//        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
}
