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
    var route: GMSPolyline?
    var routePath: GMSMutablePath?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLocationManager()
        locationManager?.delegate = self
        configureMap()
        Doit()
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
        locationManager?.delegate = self
        locationManager?.allowsBackgroundLocationUpdates = true
        locationManager?.pausesLocationUpdatesAutomatically = false
        locationManager?.startMonitoringSignificantLocationChanges()
        locationManager?.requestAlwaysAuthorization()
    }

    func Doit() {

        // Отвязываем от карты старую линию
        route?.map = nil
        // Заменяем старую линию новой
        route = GMSPolyline()
        // Заменяем старый путь новым, пока пустым (без точек)
        routePath = GMSMutablePath() // Добавляем новую линию на карту
        route?.map = mapView
        // Запускаем отслеживание или продолжаем, если оно уже запущено
        locationManager?.startUpdatingLocation()
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations
                         locations: [CLLocation]) {
        print(locations.last ?? "")
        guard let location = locations.last else { return } // Добавляем её в путь маршрута
        routePath?.add(location.coordinate)
        // Обновляем путь у линии маршрута путём повторного присвоения
        route?.path = routePath
        // Чтобы наблюдать за движением, установим камеру на только что добавленную
        // точку
        let position = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 17)
        mapView.animate(to: position)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error)
        
    }
}
