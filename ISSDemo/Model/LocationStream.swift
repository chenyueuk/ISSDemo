//
//  LocationStream.swift
//  ISSDemo
//
//  Created by YUE CHEN on 18/12/2019.
//  Copyright © 2019 YUE CHEN. All rights reserved.
//

import RealmSwift
import CoreLocation

class LocationStream: Object {
    
    // MARK: - Properties
    
    /// Max stream buffer number
    /// For offline and testing, this app stores last 50 latitudes and longitudes
    let maxBufferSize = 50
    
    /// Most recent 50 latitudes
    let latitudes = List<Double>()
    /// Most recent 50 longitudes
    let longitudes = List<Double>()
    /// Most recent 50 altitudes
    let altitudes = List<Double>()
    
    // MARK: - Methods
    
    /// Retrieves the current LocationStream from Realm DB
    ///
    /// - Returns: current LocationStream object stored in Realm
    static func current() -> LocationStream {
        /// If there is no default LocationStream object, create one
        guard let locationStream = Realm.defaultInstance().objects(LocationStream.self).first else {
            NSLog("Warning: cannot find default LocationStream object in Realm")
            let newLocationStream = LocationStream()
            try? Realm.defaultInstance().write {
                Realm.defaultInstance().add(newLocationStream)
            }
            return newLocationStream
        }
        return locationStream
    }
    
    /// Retrieves the latest latitude
    ///
    /// - Returns: latitude as CLLocationDegrees (optional)
    func latitude() -> CLLocationDegrees? {
        guard let latitude = latitudes.last else {
            return nil
        }
        return CLLocationDegrees(latitude)
    }
    
    /// Retrieves the latest longitude
    ///
    /// - Returns: longitude as CLLocationDegrees (optional)
    func longitude() -> CLLocationDegrees? {
        guard let longitude = longitudes.last else {
            return nil
        }
        return CLLocationDegrees(longitude)
    }
    
    /// Retrieves the latest altitude
    ///
    /// - Returns: altitude as CLLocationDegrees (optional)
    func altitude() -> CLLocationDistance? {
        guard let altitude = altitudes.last else {
            return nil
        }
        return CLLocationDistance(altitude)
    }
    
    /// Retrieves the latest CLLocation
    ///
    /// - Returns: latest CLLocation (optional)
    func clLocation() -> CLLocation? {
        guard let altitude = altitudes.last,
            let longitude = longitudes.last,
            let latitude = latitudes.last else {
            return nil
        }
        /// accuracy to 1km
        return CLLocation(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                          altitude: altitude,
                          horizontalAccuracy: CLLocationAccuracy(1000),
                          verticalAccuracy: CLLocationAccuracy(1000),
                          timestamp: Date())
    }
    
    /// Append the latitudes and longitudes from CLLocation list
    /// latitudes and longitudes only records last 50 results in FIFO order
    ///
    /// - Parameters:
    ///   - locations: CLLocation list to be added
    func append(_ locations: [CLLocation]) {
        // Append new location coordinates to the list
        try? Realm.defaultInstance().write {
            for location in locations {
                self.appendToList(location)
            }
        }
    }
    
    /// Append the latitude and longitude from CLLocation object
    /// latitudes and longitudes only records last 50 results in FIFO order
    ///
    /// - Parameters:
    ///   - location: CLLocation to be added
    func appendToList(_ location: CLLocation) {
        latitudes.append(location.coordinate.latitude)
        longitudes.append(location.coordinate.longitude)
        altitudes.append(location.altitude)

        if (latitudes.count > maxBufferSize) {
            latitudes.removeFirst(latitudes.count - maxBufferSize)
        }
        if (longitudes.count > maxBufferSize) {
            longitudes.removeFirst(longitudes.count - maxBufferSize)
        }
        if (altitudes.count > maxBufferSize) {
            altitudes.removeFirst(altitudes.count - maxBufferSize)
        }
    }
}
