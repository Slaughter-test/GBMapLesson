//
//  Location.swift
//  GBMapLesson
//
//  Created by Юрий Егоров on 14.11.2021.
//

import Foundation
import RealmSwift

class Location: Object {
    @Persisted(primaryKey: true) var _number: Int
    @Persisted var latitude: Double
    @Persisted var longitude: Double 
    
}
