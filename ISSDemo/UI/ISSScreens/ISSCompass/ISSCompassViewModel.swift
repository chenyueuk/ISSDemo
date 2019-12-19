//
//  ISSCompassViewModel.swift
//  ISSDemo
//
//  Created by YUE CHEN on 18/12/2019.
//  Copyright © 2019 YUE CHEN. All rights reserved.
//

import CoreLocation
import UIKit

class ISSCompassViewModel: ISSLocationBaseModel {
    
    // MARK: - Properties
    
    let locationUpdater = LocationUpdater()
    
    // MARK: - Methods
    
    /// Start fetching data, including: device heading, device location, ISS location
    func startPullingData() {
        locationUpdater.startHeadingUpdates()
        locationUpdater.startLocationUpdates()
        startISSLocationPulling()
    }
    
    /// Stop fetching data
    func stopPullingData() {
        locationUpdater.stopHeadingUpdates()
        locationUpdater.stopLocationUpdates()
        stopISSLocationPulling()
    }
    
    /// Calculates the current bearing angle from current device location and ISS location stored in Realm DB
    ///
    /// - Returns: calculated bearing angle
    func getCurrentBearingAngle() -> Double? {
        guard let deviceLocation = LocationStream.current().clLocation() else {
            return nil
        }
        let issCoordinate = ISSLocation.current().locationCoordinate()
        let issLocation = CLLocation(latitude: issCoordinate.latitude, longitude: issCoordinate.longitude)
        return MathUtils.calculateBearing(baseLocation: deviceLocation, targetLocation: issLocation)
    }
    
    /// Calculate points on compass based on angle and compass radius
    ///
    /// - Parameters:
    ///   - compassRadius: radius of the compass
    ///   - angle: angle to the point on the compass
    /// - Returns: relative CGPoint value of calculated coordinates to compass center
    func getISSIconRelativeCoorindates(compassRadius: Double, angle: Double) -> CGPoint {
        return MathUtils.coordinatesOnCircle(radius: compassRadius, angle: angle)
    }
}
