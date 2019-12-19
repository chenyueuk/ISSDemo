//
//  Realm+Utils.swift
//  ISSDemo
//
//  Created by YUE CHEN on 18/12/2019.
//  Copyright © 2019 YUE CHEN. All rights reserved.
//

import RealmSwift

extension Realm {
    
    /// Validates the default Realm instance (equivalent to try! Realm())
    ///
    /// - Returns: Boolean value if the default Realm instance is valid
    static func validateRealm() -> Bool {
        do {
            _ = try Realm()
            return true
        } catch {
            return false
        }
    }
    
    /// Get the default instance of Realm (equivalent to try! Realm())
    ///
    /// - Returns: the default Realm instance unwrapped
    static func defaultInstance() -> Realm {
        return try! Realm()
    }
    
    /// Removes all data stored in the default Realm instance
    static func removeAllObjects() {
        try? defaultInstance().write {
            defaultInstance().deleteAll()
        }
    }
}
