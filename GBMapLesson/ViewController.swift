//
//  ViewController.swift
//  GBMapLesson
//
//  Created by Юрий Егоров on 07.11.2021.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController {
    
    //MARK: - Variables
    var mapView: GMSMapView!
    var locationManager: CLLocationManager?
    var currentLocation = CLLocationCoordinate2D(latitude: 59.939095, longitude: 30.315868)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLocationManager()
        setupCamera(location: currentLocation)
        updateCurrentLocation(self)
        constraints()
    }
    
    //MARK: - User Actions
    @objc
    func updateCurrentLocation(_ sender: Any) {
        locationManager?.requestLocation()
        guard let location = locationManager?.location?.coordinate else {
            return
        }
        currentLocation = location
        updateCamera(location: location)
        createMark(location: location)
    }
    
    //MARK: - View Actions
    private func updateCamera(location: CLLocationCoordinate2D) {
        mapView.animate(toLocation: location)
    }
    
    private func createMark(location: CLLocationCoordinate2D) {
        let marker = GMSMarker(position: location)
        marker.map = mapView
    }
    
    //MARK: - Configs
    private func setupCamera(location: CLLocationCoordinate2D) {
        mapView.camera = GMSCameraPosition.camera(withTarget: location, zoom:10)
    }
    
    private func constraints() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mapView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mapView.widthAnchor.constraint(equalTo: view.widthAnchor),
            mapView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupViews() {
        mapView = GMSMapView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - 50))
        view.addSubview(mapView)
        
        // navigationBar
        let navigationItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(updateCurrentLocation(_:)))
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.rightBarButtonItem = navigationItem
    }
    
    private func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.delegate = self
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations.first as Any)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}

