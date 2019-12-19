//
//  MathUtils.swift
//  ISSDemo
//
//  Created by YUE CHEN on 18/12/2019.
//  Copyright © 2019 YUE CHEN. All rights reserved.
//

import CoreLocation

struct MathUtils {
    
    /// Calculate degrees from radians
    ///
    /// - Parameters:
    ///   - degrees: input degrees value
    /// - Returns: radians value of the input degrees
    static func degreesToRadians(_ degrees: Double) -> Double {
        return degrees * .pi / 180.0
    }
    
    /// Calculate radians from degrees
    ///
    /// - Parameters:
    ///   - radians: input radians value
    /// - Returns: degrees value of the input radians
    static func radiansToDegrees(_ radians: Double) -> Double {
        return radians * 180.0 / .pi
    }

    /// Calculate bearing angle of two input location points
    /// Reference: https://www.movable-type.co.uk/scripts/latlong.html
    ///
    /// - Parameters:
    ///   - baseLocation: Bearing angle from point
    ///   - targetLocation: Bearing angle to point
    /// - Returns: degrees value of the bearing angle
    static func calculateBearing(baseLocation: CLLocation, targetLocation: CLLocation) -> Double {

        let latitudeBase = degreesToRadians(baseLocation.coordinate.latitude)
        let longitudeBase = degreesToRadians(baseLocation.coordinate.longitude)

        let latitudeTarget = degreesToRadians(targetLocation.coordinate.latitude)
        let longitudeTarget = degreesToRadians(targetLocation.coordinate.longitude)

        let longitudeDistance = longitudeTarget - longitudeBase

        let y = sin(longitudeDistance) * cos(latitudeTarget)
        let x = cos(latitudeBase) * sin(latitudeTarget) - sin(latitudeBase) * cos(latitudeTarget) * cos(longitudeDistance)
        let radiansBearing = atan2(y, x)
        
        let angle = radiansToDegrees(radiansBearing)
        let trueAngle = angle < 0 ? 360 + angle : angle
        
        return trueAngle
    }
}
