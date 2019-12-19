//
//  ISSLocation.swift
//  ISSDemo
//
//  Created by YUE CHEN on 18/12/2019.
//  Copyright © 2019 YUE CHEN. All rights reserved.
//

import RealmSwift
import CoreLocation
import MapKit

class ISSLocation: Object, Decodable {
    
    // MARK: - Properties
    
    @objc dynamic var timestamp: Double = 0
    @objc dynamic var message: String = ""
    @objc dynamic var longitude: Double = 0
    @objc dynamic var latitude: Double = 0
    
    // MARK: - Enums
    
    /// Coding keys for Decodable protocol
    private enum ISSLocationCodingKeys: String, CodingKey {
        case timestamp, message, issPosition = "iss_position"
    }
    private enum ISSPositionCodingKeys: String, CodingKey {
        case longitude, latitude
    }
    
    // MARK: - Initializers
    
    /// Convenience init method for ISSLocation class
    ///
    /// - Parameters:
    ///   - timestamp: timestamp of the ISS location
    ///   - message: response message
    ///   - longitude: longitude of ISSLocation
    ///   - latitude: latitude of ISSLocation
    convenience init(timestamp: TimeInterval,
                     message: String,
                     latitude: Double,
                     longitude: Double) {
        self.init()
        self.timestamp = timestamp
        self.message = message
        self.latitude = latitude
        self.longitude = longitude
    }
    
    /// Convenience init method for ISSLocation class, required for Decodable protocol
    ///
    /// - Parameters:
    ///   - decoder: a JSON decoder instance to decode the data
    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ISSLocationCodingKeys.self)
        let timestamp = try container.decode(Double.self, forKey: .timestamp)
        let message = try container.decode(String.self, forKey: .message)
        
        let issPositionContainer = try container.nestedContainer(keyedBy: ISSPositionCodingKeys.self,
                                                                 forKey: .issPosition)
        let latitude = try issPositionContainer.decode(String.self, forKey: .latitude)
        let longitude = try issPositionContainer.decode(String.self, forKey: .longitude)

        self.init(timestamp: timestamp,
                  message: message,
                  latitude: Double(latitude) ?? 0,
                  longitude: Double(longitude) ?? 0)
    }
    
    // MARK: - Methods
    
    /// Gets the datetime value of the ISSLocation
    ///
    /// - Returns: Date when ISSLocation was updated
    func date() -> Date {
        return Date(timeIntervalSince1970: timestamp)
    }
    
    /// Gets the CoreLocation 2D coordinate of ISSLocation
    ///
    /// - Returns: CLLocationCoordinate2D of ISSLocation
    func locationCoordinate() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    /// Retrieves the current ISSLocation from Realm DB
    ///
    /// - Returns: current ISSLocation object stored in Realm
    static func current() -> ISSLocation {
        /// If there is no ISSLocation object, create one
        guard let issLocation = Realm.defaultInstance().objects(ISSLocation.self).first else {
            NSLog("Warning: cannot find default ISSLocation object in Realm")
            let newISSLocation = ISSLocation()
            try? Realm.defaultInstance().write {
                Realm.defaultInstance().add(newISSLocation)
            }
            return newISSLocation
        }
        return issLocation
    }
    
    /// Update ISSLocation with the input values
    ///
    /// - Parameters:
    ///   - timestamp: timestamp of the ISSLocation
    ///   - latitude: latitude of the ISSLocation
    ///   - longitude: longitude of the ISSLocation
    func updateISSLocation(timestamp: TimeInterval, latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
        self.timestamp = timestamp
    }
}
