//
//  MathUtils+Circle.swift
//  ISSDemo
//
//  Created by YUE CHEN on 19/12/2019.
//  Copyright © 2019 YUE CHEN. All rights reserved.
//

import UIKit

extension MathUtils {
    
    /// Calculate point coordinate on a circle from radius and angle
    ///
    /// - Parameters:
    ///   - radius: radius of the circle
    ///   - angle: angle to the point on the circle
    /// - Returns: CGPoint value of calculated coordinates
    static func coordinatesOnCircle(radius: Double, angle: Double) -> CGPoint {
        let x = radius * sin(MathUtils.degreesToRadians(angle))
        let y = radius * cos(MathUtils.degreesToRadians(angle))
        
        return CGPoint(x: x, y: y)
    }
    
    /// Calculate the angle between Device heading and Bearing angle from device to ISS station
    /// Result will be normalized between -180 to 180
    ///
    /// - Parameters:
    ///   - deviceHeading: device heading angle in degrees
    ///   - bearingAngle: bearing angle in degrees
    /// - Returns: normalized angle in degrees
    static func calculateAngleDifference(deviceHeading: Double, bearingAngle: Double) -> Double {
        let angle = bearingAngle - deviceHeading
        return MathUtils.normalizeAngle(angle)
    }
    
    /// Result will be normalized between -180 to 180
    /// Normalize the input angle.
    ///
    /// - Parameters:
    ///   - angle: angle in degrees to be normalized
    /// - Returns: normalized angle in degrees
    static func normalizeAngle(_ angle: Double) -> Double {
        switch angle {
        case 180...:
            return angle - 360
        case ..<(-180):
            return 360 + angle
        default:
            return angle
        }
    }
}
