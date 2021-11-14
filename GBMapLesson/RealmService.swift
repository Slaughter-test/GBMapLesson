//
//  RealmService.swift
//  GBMapLesson
//
//  Created by Юрий Егоров on 14.11.2021.
//

import Foundation
import RealmSwift
import CoreLocation

final class RealmService {
    
    let realm = try! Realm()
    
    static var shared: RealmService = {
        let instance = RealmService()
        
        return instance
    }()
    
    private init() {}
    
    func saveLocations(data: Array<CLLocationCoordinate2D>, key: String) {
        var dataToSave = Array<Location>()
        for i in 0..<data.count {
            let location = Location()
            location.latitude = data[i].latitude
            location.longitude = data[i].longitude
            location.key = key
            location.number = i
            dataToSave.append(location)
        }
        try! realm.write {
            realm.add(dataToSave, update: .all)
        }
    }
    
    func saveLocations(data: CLLocationCoordinate2D, key: String) {
        let location = Location()
        location.latitude = data.latitude
        location.longitude = data.longitude
        location.key = key
        try! realm.write {
            realm.add(location)
        }
    }
    
    func loadLocations(key: String) -> Array<Location> {
        return realm.objects(Location.self).filter { $0.key == key }
    }
    
}
