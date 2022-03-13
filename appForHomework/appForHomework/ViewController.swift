//
//  ViewController.swift
//  appForHomework
//
//  Created by Nikita on 13.03.2022.
//

import UIKit
import GoogleMaps
import CoreLocation

class ViewController: UIViewController {
    var coordinate = CLLocationCoordinate2D(latitude: 59.939095, longitude: 30.315868)
    var locationManager: CLLocationManager?
    @IBOutlet weak var mapView: GMSMapView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLocationManager()
        locationManager?.delegate = self
        configureMap()
        locationManager?.requestLocation()
        
        locationManager?.startUpdatingLocation()
        // Do any additional setup after loading the view.
    }
    func configureMap() {
    // Создаём камеру с использованием координат и уровнем увеличения
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 17) // Устанавливаем камеру для карты
        mapView.camera = camera
        
    }

    func addMarker() {
        let marker = GMSMarker(position: coordinate)
        marker.map = mapView
    }
    func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
    }


}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations
                         locations: [CLLocation]) {
        print(locations.last ?? "")
        coordinate = locations.last?.coordinate ?? CLLocationCoordinate2D(latitude: 59.939095, longitude: 30.315868)
        configureMap()
        addMarker()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error)
        
    }
}
