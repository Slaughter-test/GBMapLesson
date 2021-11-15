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
    
    let configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    
    static var shared: RealmService = {
        let instance = RealmService()
        
        return instance
    }()
    
    private init() {}
    
    func saveList(_ list: [Object]) {
        do {
            let realm = try Realm(configuration: configuration)
            realm.beginWrite()
            realm.add(list, update: .all)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    
    func loadListOfLocation() -> Array<Location> {
        do {
            let realm = try Realm(configuration: configuration)
            return Array(realm.objects(Location.self))
        } catch {
            print(error)
            return Array<Location>()
        }
    }
    
    func deleteAll() {
        do {
            let realm = try Realm(configuration: configuration)
            realm.beginWrite()
            realm.deleteAll()
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
}
