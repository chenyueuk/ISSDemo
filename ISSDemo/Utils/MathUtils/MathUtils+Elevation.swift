//
//  MathUtils+Elevation.swift
//  ISSDemo
//
//  Created by YUE CHEN on 19/12/2019.
//  Copyright © 2019 YUE CHEN. All rights reserved.
//

import CoreLocation

extension MathUtils {
    
    /// Calculates the ECEF vector from location coordinate and altitude
    ///
    /// - Parameters:
    ///   - coordinate: CLLocationCoordinate2D for calculation
    ///   - altitude: altitude in meters for calculation
    /// - Returns: [Double] contains x, y, z values
    static func llaToECEF(coordinate: CLLocationCoordinate2D, altitude: Double) -> [Double] {
        
        let latitude = degreesToRadians(coordinate.latitude)
        let longitude = degreesToRadians(coordinate.longitude)
        
        /// Earth radius
        let radius: Double = 6378137
        /// Earth polar radius
        let polarRadius: Double = 6356752.312106893

        let aSqr = radius * radius
        let bSqr = polarRadius * polarRadius
        /// eccentricity of earth
        let e = ((aSqr - bSqr)/aSqr).squareRoot()

        /// sin(latitude)
        let sLat = sin(latitude)
        /// Curvature radius
        let N = radius / ((1 - e * e * sLat * sLat).squareRoot())
        
        let ratio = (bSqr / aSqr)

        let x = (N + altitude) * cos(latitude) * cos(longitude)
        let y = (N + altitude) * cos(latitude) * sin(longitude)
        let z = (ratio * N + altitude) * sin(latitude);

        return [x, y, z];
    }
    
    /// Calculates the changes in ECEF system
    ///
    /// - Parameters:
    ///   - base: from point in ECEF system
    ///   - target: to point in ECEF system
    /// - Returns: [Double] contains x, y, z delta values
    static func getECEFDelta(base: [Double], target: [Double]) -> [Double] {
        guard base.count == 3, target.count == 3 else {
            return []
        }
        let x = target[0] - base[0]
        let y = target[1] - base[1]
        let z = target[2] - base[2]
        
        return [x, y, z]
    }
    
    /// Calculates the elevation angle between two points in LLA system
    /// Reference https://ieiuniumlux.github.io/ISSOT/
    /// Reference https://www.cnblogs.com/langzou/p/11388520.html
    /// Reference https://gis.stackexchange.com/questions/58923/calculating-view-angle
    ///
    /// - Parameters:
    ///   - fromCoordinate: from point in LLA system
    ///   - fromAltitude: from altitude in LLA system
    ///   - toCoordinate: to point in LLA system
    ///   - toAltitude: to altitude in LLA system
    /// - Returns: elevation angle in degrees
    static func getElevationAngle(fromCoordinate: CLLocationCoordinate2D,
                                  fromAltitude: Double,
                                  toCoordinate: CLLocationCoordinate2D,
                                  toAltitude: Double) -> Double {
        
        let fromECEF = llaToECEF(coordinate: fromCoordinate, altitude: fromAltitude)
        let toECEF = llaToECEF(coordinate: toCoordinate, altitude: toAltitude)
        
        let deltaECEF = getECEFDelta(base: fromECEF, target: toECEF)
        
        guard fromECEF.count == 3, toECEF.count == 3, deltaECEF.count == 3 else {
            return 0
        }
        
        let d = (fromECEF[0] * deltaECEF[0] + fromECEF[1] * deltaECEF[1] + fromECEF[2] * deltaECEF[2])
        let a = ((fromECEF[0] * fromECEF[0]) + (fromECEF[1] * fromECEF[1]) + (fromECEF[2] * fromECEF[2]))
        let b = ((deltaECEF[0] * deltaECEF[0]) + (deltaECEF[2] * deltaECEF[2]) + (deltaECEF[2] * deltaECEF[2]))
        
        let elevation = acos(d / ((a * b).squareRoot()))
        
        return 90 - radiansToDegrees(elevation)
    }
}
