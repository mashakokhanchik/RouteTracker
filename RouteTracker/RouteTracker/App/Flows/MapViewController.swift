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
    
    // MARK: - Outlets

    @IBOutlet weak var mapView: GMSMapView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.delegate = self
    }
    func addMarker() {
        let marker = GMSMarker(position: coordinate)
        marker.icon = GMSMarker.markerImage(with: .red)
        marker.map = mapView
        //self.marker = marker
    }
    
    // MARK: - Actions
    
    @IBAction func currientLocation(_ sender: Any) {
        locationManager?.requestLocation()
    }
    
    @IBAction func updateLocation(_ sender: Any) {
        locationManager?.startUpdatingLocation()
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
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
        if let location = locations.first {
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 17, bearing: 0, viewingAngle: 0)
        }
        //print(locations.first!)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}
