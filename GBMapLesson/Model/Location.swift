//
//  Location.swift
//  GBMapLesson
//
//  Created by Юрий Егоров on 14.11.2021.
//

import Foundation
import RealmSwift

class Location: Object {
    @objc dynamic var key = "CurrentLocation"
    @objc dynamic var number = 0
    @objc dynamic var latitude = 0.0
    @objc dynamic var longitude = 0.0
}
