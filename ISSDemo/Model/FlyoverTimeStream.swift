//
//  FlyoverTime.swift
//  ISSDemo
//
//  Created by YUE CHEN on 18/12/2019.
//  Copyright © 2019 YUE CHEN. All rights reserved.
//

import RealmSwift

class FlyoverTime: Object, Codable {
    
    // MARK: - Properties
    
    @objc dynamic var duration: Double
    @objc dynamic var risetime: Double
    
    // MARK: - Methods
    
    /// Gets the datetime of FlyoverTime from risetime timeinterval
    ///
    /// - Returns: date of FlyoverTime
    func date() -> Date {
        return Date(timeIntervalSince1970: risetime)
    }
}

/// Wrapper class for the convenience of creating FlyoverTime list from URL response and Realm storage
class ISSPassTimes: Object, Decodable {
    
    // MARK: - Enums
    
    /// Coding keys for Decodable protocol
    private enum ISSPassTimesCodingKeys: String, CodingKey {
        case flyoverTimes = "response"
    }
    
    // MARK: - Properties
    
    var flyoverTimes = List<FlyoverTime>()
    
    // MARK: - Initializers
    
    /// Convenience init method for ISSPassTimes class
    ///
    /// - Parameters:
    ///   - flyoverTimes: List of FlyoverTime objects
    convenience init(flyoverTimes: List<FlyoverTime>) {
        self.init()
        self.flyoverTimes = flyoverTimes
    }
    
    /// Convenience init method for ISSPassTimes class, required for Decodable protocol
    ///
    /// - Parameters:
    ///   - decoder: a JSON decoder instance to decode the data
    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ISSPassTimesCodingKeys.self)
        let flyoverTimes = try container.decode(List<FlyoverTime>.self, forKey: .flyoverTimes)
        self.init(flyoverTimes: flyoverTimes)
    }
    
    // MARK: - Methods
    
    /// Retrieves the current ISSPassTimes from Realm DB
    ///
    /// - Returns: current ISSPassTimes object stored in Realm
    static func current() -> ISSPassTimes {
        /// If there is no ISSPassTimes object, create one
        guard let issPassTimes = Realm.defaultInstance().objects(ISSPassTimes.self).first else {
            NSLog("Warning: cannot find default ISSPassTimes object in Realm")
            let newISSPassTimes = ISSPassTimes()
            try? Realm.defaultInstance().write {
                Realm.defaultInstance().add(newISSPassTimes)
            }
            return newISSPassTimes
        }
        return issPassTimes
    }
    
    /// Update FlyoverTimes with the input FlyoverTimes list
    /// Always clears (removeAll) the current list first, ISSPassTimes only stores the most recent successful API call
    ///
    /// - Parameters:
    ///   - flyoverTimes: FlyoverTime list to be set
    func updateFlyoverTimes(_ flyoverTimes: List<FlyoverTime>) {
        self.flyoverTimes.removeAll()
        self.flyoverTimes.append(objectsIn: flyoverTimes)
    }
}
