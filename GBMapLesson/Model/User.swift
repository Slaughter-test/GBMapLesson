//
//  User.swift
//  GBMapLesson
//
//  Created by Юрий Егоров on 17.11.2021.
//

import Foundation
import RealmSwift

class User: Object {
    @Persisted(primaryKey: true) var _login: String
    @Persisted var password: String
}

