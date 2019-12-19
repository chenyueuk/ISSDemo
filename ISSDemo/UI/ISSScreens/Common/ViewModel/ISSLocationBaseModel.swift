//
//  ISSLocationBaseModel.swift
//  ISSDemo
//
//  Created by YUE CHEN on 18/12/2019.
//  Copyright © 2019 YUE CHEN. All rights reserved.
//

import CoreLocation
import MapKit

class ISSLocationBaseModel {
    
    // MARK: - Properties
    let getISSLocationService = GetISSLocationService()
    var issLocationPullingTimer: Timer?
    
    // MARK: - Methods
    
    /// Start getting ISSLocation data
    func startISSLocationPulling() {
        issLocationPullingTimer?.invalidate()
        issLocationPullingTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            self.getISSLocationService.getISSLocation()
        }
    }
    
    /// Stop getting ISSLocation data
    func stopISSLocationPulling() {
        issLocationPullingTimer?.invalidate()
    }
    
    /// Gets the CLLocationCoordinate2D from the ISSLocation default object stored in Realm
    ///
    /// - Returns: CLLocationCoordinate2D of last fetched ISSLocation
    func getCurrentISSLocation() -> CLLocationCoordinate2D {
        return ISSLocation.current().locationCoordinate()
    }
}
