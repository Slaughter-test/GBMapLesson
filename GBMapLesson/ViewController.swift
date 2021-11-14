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
    var route: GMSPolyline?
    var routePath: GMSMutablePath?
    var inLoadedState: Bool?
    var locationManager: CLLocationManager?
    var currentLocation = CLLocationCoordinate2D(latitude: 59.939095, longitude: 30.315868)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLocationManager()
        setupCamera(location: currentLocation)
        updateCurrentLocation(self)
        setupConstraints()
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
    
    @objc
    func createPath(_ sender: Any) {
        setupRoute()
        locationManager?.startUpdatingLocation()
    }
    
    @objc
    func stopCreatingPath(_ sender: Any) {
        locationManager?.stopUpdatingLocation()
        guard let pointsCount = routePath?.count() else { return }
        for i in 0..<pointsCount {
            guard let point = routePath?.coordinate(at: i) else { return }
            RealmService.shared.saveLocations(data: point, key: "LastLocation")
        }
        mapView.clear()
    }
    
    @objc
    func loadPreviousRoute(_ sender: Any) {
        locationManager?.stopUpdatingLocation()
        let locations = RealmService.shared.loadLocations(key: "LastLocation")
        for i in 0..<locations.count {
            let coordinate = CLLocationCoordinate2D(latitude: locations[i].latitude, longitude: locations[i].longitude)
            routePath?.removeAllCoordinates()
            routePath?.insert(coordinate, at: UInt(locations[i].number))
        }
        route?.map = mapView
        guard let routePath = routePath else {
            return
        }

        let bounds = GMSCoordinateBounds(path: routePath)
        mapView.animate(with: GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)))
        inLoadedState = true
    }
    
    //MARK: - View Actions
    private func updateCamera(location: CLLocationCoordinate2D) {
        mapView.animate(toLocation: location)
    }
    
    private func createMark(location: CLLocationCoordinate2D) {
        let marker = GMSMarker(position: location)
        marker.map = mapView
        if inLoadedState == true {
            removeRoute()
        }
    }
    
    //MARK: - Configs
    private func setupCamera(location: CLLocationCoordinate2D) {
        mapView.camera = GMSCameraPosition.camera(withTarget: location, zoom:10)
    }
    
    private func setupConstraints() {
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
        // navigation items
        let updateLocationItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(updateCurrentLocation(_:)))
        let createPathItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(createPath(_:)))
        let stopCreatePathItem = UIBarButtonItem(barButtonSystemItem: .pause, target: self, action: #selector(stopCreatingPath(_ :)))
        let loadRouteItem = UIBarButtonItem(title: "Load", style: UIBarButtonItem.Style.plain, target: self, action: #selector(loadPreviousRoute(_:)))
        // navigationBar
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.rightBarButtonItems = [updateLocationItem, loadRouteItem]
        self.navigationItem.leftBarButtonItems = [createPathItem, stopCreatePathItem]
    }
    
    private func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.allowsBackgroundLocationUpdates = true
        locationManager?.pausesLocationUpdatesAutomatically = false
        locationManager?.startMonitoringSignificantLocationChanges()
        locationManager?.requestAlwaysAuthorization()
        locationManager?.delegate = self
    }
    
    private func setupRoute() {
        mapView.clear()
        route?.map = nil
        route = GMSPolyline()
        route?.strokeColor = .red
        route?.strokeWidth = 10.0
        routePath = GMSMutablePath()
        route?.map = mapView
    }
    
    private func removeRoute() {
        route?.map = nil
        routePath?.removeAllCoordinates()
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        routePath?.add(location.coordinate)
        route?.path = routePath
        let position = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 15)
        mapView.animate(to: position)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}

