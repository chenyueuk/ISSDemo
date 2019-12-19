//
//  LocationUpdater.swift
//  ISSDemo
//
//  Created by YUE CHEN on 18/12/2019.
//  Copyright © 2019 YUE CHEN. All rights reserved.
//

import CoreLocation
import UIKit

class LocationUpdater: NSObject {
    
    // MARK: - Properties
    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        return manager
    }()
    
    // MARK: - Methods
    
    /// Start updating the device location
    /// Will request device permission if needed
    func startLocationUpdates() {
        /// Create default LocationStream if needed
        let _ = LocationStream.current()
        
        guard CLLocationManager.authorizationStatus() == .authorizedWhenInUse else {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        locationManager.startUpdatingLocation()
    }
    
    /// Stop updating the device location
    func stopLocationUpdates() {
        locationManager.stopUpdatingLocation()
    }
    
    /// Start updating the device heading
    /// Will request device permission if needed
    func startHeadingUpdates() {
        /// Create default LocationStream if needed
        let _ = LocationStream.current()
        
        guard CLLocationManager.authorizationStatus() == .authorizedWhenInUse else {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        locationManager.startUpdatingHeading()
    }
    
    /// Stop updating the device location
    func stopHeadingUpdates() {
        locationManager.stopUpdatingHeading()
    }
}

// MARK: - CoreLocation delegates
extension LocationUpdater: CLLocationManagerDelegate {
    
    /// Handles the authorization challenge
    /// Only continue getting location updates when 'authorizedWhenInUse'
    /// App does not use location in background mode, 'authorizedAlways' is not expected
    /// Denied access will lead user to settings page to enable location service
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            NSLog("Info: Location permission granted.")
        case .authorizedAlways:
            NSLog("Warning: Unexpected location privacy setting: authorizedAlways.")
        case .denied:
            NSLog("Warning: Location privacy setting denied, retry in settings.")
            guard let settinsURL = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            UIApplication.shared.open(settinsURL, options: [:], completionHandler: nil)
        default:
            NSLog("Warning: Location privacy setting denied with status code: %d.", status.rawValue)
        }
    }
    
    /// Handles the updates of app location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        /// Append new locations to local storage
        LocationStream.current().append(locations)
    }
    
    /// Handles the updates of app heading
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        /// Stores the new heading
        DeviceTrueHeading.current().updateDeviceTrueHeading(newHeading)
    }
}

