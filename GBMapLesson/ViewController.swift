//
//  ViewController.swift
//  GBMapLesson
//
//  Created by Юрий Егоров on 07.11.2021.
//

import UIKit
import GoogleMaps

final class MapViewModel {
    
    let value: Int
    
    init(value: Int) {
        self.value = value
    }
    
}

class ViewController: UIViewController {
    
    //MARK: - Variables
    var viewModel: MapViewModel?
    var mapView: GMSMapView!
    var route: GMSPolyline?
    var routePath: GMSMutablePath?
    var locationManager = LocationManager.instance
    var currentLocation = CLLocationCoordinate2D(latitude: 59.939095, longitude: 30.315868)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLocationManager()
        setupCamera(location: currentLocation)
        updateCurrentLocation(self)
        setupConstraints()
    }
    
    func configure(viewModel: MapViewModel) {
        self.viewModel = viewModel
    }
    
    //MARK: - User Actions
    @objc
    func updateCurrentLocation(_ sender: Any) {
        locationManager.requestLocation()
        guard let newLocation = locationManager.location.value else {
            return
        }
        let location2D = CLLocationCoordinate2D(latitude: newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude)
        currentLocation = location2D
        updateCamera(location: location2D)
        createMark(location: location2D)
    }
    
    @objc
    func createPath(_ sender: Any) {
        setupRoute()
        locationManager.startUpdatingLocation()
    }
    
    @objc
    func stopCreatingPath(_ sender: Any) {
        locationManager.stopUpdatingLocation()
        RealmService.shared.deleteAllLocations()
        guard let pointsCount = routePath?.count() else { return }
        var locations = Array<Location>()
        for i in 0..<pointsCount {
            guard let point = routePath?.coordinate(at: i) else { return }
            let location = Location()
            location.longitude = point.longitude
            location.latitude = point.latitude
            location._number = Int(i)
            locations.append(location)
        }
        RealmService.shared.saveList(locations)
        mapView.clear()
    }
    
    @objc
    func loadPreviousRoute(_ sender: Any) {
        let newRoute = GMSPolyline()
        let newPath = GMSMutablePath()
        newRoute.strokeColor = .blue
        newRoute.strokeWidth = 10.0
        locationManager.stopUpdatingLocation()
        let locations = RealmService.shared.loadListOfLocation()
        routePath?.removeAllCoordinates()
        for i in 0..<locations.count {
            let coordinate = CLLocationCoordinate2D(latitude: locations[i].latitude, longitude: locations[i].longitude)
            newPath.insert(coordinate, at: UInt(locations[i]._number))
        }
        newRoute.path = newPath
        newRoute.map = mapView
        let bounds = GMSCoordinateBounds(path: newPath)
        mapView.animate(with: GMSCameraUpdate.fit(bounds))
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
        locationManager
            .location
            .asObservable()
            .bind { [weak self] location in
                guard let location = location else { return }
                self?.routePath?.add(location.coordinate)
                self?.route?.path = self?.routePath
                let position = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 17)
                self?.mapView.animate(to: position)
                
            }
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

