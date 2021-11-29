//
//  MapViewController.swift
//  RouteTracker
//
//  Created by Мария Коханчик on 01.11.2021.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    
    // MARK: - Properties
    
    /// Координаты центра Москвы
    let coordinate = CLLocationCoordinate2D(latitude: 55.753215, longitude: 37.622504)
    let locationManager = LocationManager.instance
    
    /// Работа в фоне
    var baskgroundTask: UIBackgroundTaskIdentifier?
    
    /// Объект маршрута и его путь
    var route: GMSPolyline?
    var routePath: GMSMutablePath?
    var routeSave: Route?
    
    /// Навигация по координаторам
    var usselesExampleVariable = ""
    
    /// Маркер
    var marker: GMSMarker?
    var avatarImage: UIImage!
    
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
    }
    
    // MARK: - Methods
    
    func configureMap() {
        /// Камера с импользавнием координат и уровнем увеличения (zoom - масштаб карты)
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 17)
        /// Установка камеры для карты
        mapView.camera = camera
        mapView.delegate = self
        /// Установка маркера
        marker = GMSMarker(position: coordinate)
        let markerView = UIImageView(image: avatarImage)
        markerView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        markerView.layer.cornerRadius = 16
        markerView.layer.masksToBounds = true
        markerView.tintColor = .red
        marker?.iconView = markerView
        marker?.map = mapView
    }
    
    func configureLocationManager() {
        locationManager
            .location
            .asObservable()
            .bind { [weak self] location in
                guard let location = location else { return }
                self?.routePath?.add(location.coordinate)
                self?.route?.path = self?.routePath
                self?.marker?.position = location.coordinate
                let position = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 17)
                self?.mapView.animate(to: position)
            }.dispose()
    }
    
    func saveRoute() {
        if let routeSave = routeSave {
            RealmService.shared.deleteAll()
            RealmService.shared.save([routeSave])
        }
    }
    
    // MARK: - Actions
    
    @IBAction func currientLocation(_ sender: Any) {
        locationManager.requestLocation()
    }
    
    @IBAction func updateLocation(_ sender: Any) {
        route?.map = nil
        route = GMSPolyline()
        routePath = GMSMutablePath()
        route?.map = mapView
        
        routeSave = Route()
        
        locationManager.startUpdatingLocation()
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    @IBAction func stopLocation(_ sender: Any) {
        locationManager.stopUpdatingLocation()
        saveRoute()
        routeSave = nil
        
        guard let baskgroundTask = baskgroundTask else { return }
        UIApplication.shared.endBackgroundTask(baskgroundTask)
        self.baskgroundTask = .invalid
    }
    
    @IBAction func loadLastLocation(_ sender: Any) {
        locationManager.stopUpdatingLocation()
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
