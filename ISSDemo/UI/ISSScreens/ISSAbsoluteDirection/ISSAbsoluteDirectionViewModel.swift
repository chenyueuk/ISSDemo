//
//  ISSAbsoluteDirectionViewModel.swift
//  ISSDemo
//
//  Created by YUE CHEN on 19/12/2019.
//  Copyright © 2019 YUE CHEN. All rights reserved.
//

import UIKit
import CoreMotion

class ISSAbsoluteDirectionViewModel: ISSCompassViewModel {
    
    // MARK: - Properties
    
    let motionManager = CMMotionManager()
    var motionUpdateHandler: CMDeviceMotionHandler?
    
    // MARK: - Methods
    
    /// Start fetching data, including: device heading, device location, ISS location
    override func startPullingData() {
        super.startPullingData()
        if let motionHandler = motionUpdateHandler {
            motionManager.startDeviceMotionUpdates(to: OperationQueue(), withHandler: motionHandler)
        } else {
            motionManager.startDeviceMotionUpdates()
        }
    }
    
    /// Stop fetching data
    override func stopPullingData() {
        super.stopPullingData()
        motionManager.stopDeviceMotionUpdates()
    }
    
    /// Get the angle in degrees between device heading and ISS bearing angle
    /// Result is normalized between -180 and 180
    ///
    /// - Returns: the angle between device heading and ISS bearing angle
    func angleBetweenHeadingAndBearing() -> Double? {
        guard let bearingAngle = getCurrentBearingAngle() else {
            return nil
        }
        let deviceHeading = DeviceTrueHeading.current().trueHeading
        return MathUtils.calculateAngleDifference(deviceHeading: deviceHeading, bearingAngle: bearingAngle)
    }
    
    /// Get the angle in degrees between device pitch and ISS elevation angle
    ///
    /// - Returns: the angle between device pitch and ISS elevation angle in degrees (optional)
    func angleBetweenPitchAndElevation() -> Double? {
        guard let pitch = getDevicePitchAngle(),
            let elevation = getISSElevationAngle() else {
            return nil
        }
        return pitch - elevation
    }
    
    /// Get the x position offest based on HUD view width and angle
    /// Use max size if angle greater than 90 or angle smaller than -90
    ///
    /// - Parameters:
    ///   - hudRadius: radius of the HUD image
    ///   - angle: angle to the point on the HUD
    /// - Returns: the x offset value
    func issIconXOffset(hudRadius: Double, xAngle: Double) -> Double {
        switch xAngle {
        case 90...:
            /// when angle greater than 90 degrees, always show icon at right corner
            return hudRadius
        case ..<(-90):
            /// when angle less than -90 degrees, always show icon at left corner
            return -hudRadius
        default:
            return hudRadius * sin(MathUtils.degreesToRadians(xAngle))
        }
    }
    
    /// Get the y position offest based on HUD view width and angle
    /// Use max size if angle greater than 90 or angle smaller than -90
    ///
    /// - Parameters:
    ///   - hudRadius: radius of the HUD image
    ///   - angle: angle to the point on the HUD
    /// - Returns: the y offset value
    func issIconYOffset(hudRadius: Double, yAngle: Double) -> Double {
        switch yAngle {
        case 90...:
            /// when angle greater than 90 degrees, always show icon at right corner
            return hudRadius
        case ..<(-90):
            /// when angle less than -90 degrees, always show icon at left corner
            return -hudRadius
        default:
            return hudRadius * sin(MathUtils.degreesToRadians(yAngle))
        }
    }
    
    /// Get the elevation angle in degrees between device heading and ISS bearing angle
    ///
    /// - Returns: the elevation angle between device heading and ISS bearing angle (optional)
    func getISSElevationAngle() -> Double? {
        guard let currentLocation = LocationStream.current().clLocation() else {
            return nil
        }
        let issCoordinate = ISSLocation.current().locationCoordinate()
        let issAltitude = Double(408000)
        let elevation = MathUtils.getElevationAngle(fromCoordinate: currentLocation.coordinate,
                                                    fromAltitude: currentLocation.altitude,
                                                    toCoordinate: issCoordinate,
                                                    toAltitude: issAltitude)
        return elevation
    }
    
    /// Get the device pitch angle to the horizontal axis
    ///
    /// - Returns: device pitch angle in degrees(optional)
    func getDevicePitchAngle() -> Double? {
        guard let pitch = motionManager.deviceMotion?.attitude.pitch,
            let gravityZ = motionManager.deviceMotion?.gravity.z else {
            return nil
        }
        let originalPitch = MathUtils.radiansToDegrees(pitch)
        
        /// Apple only support pitch from 90 to -90 degrees which is very painful
        /// GravityZ can be used to find out if device screen is facing upwards
        /// Then we can extend pitch range to +/-180 degrees
        var extendedPitch: Double
        if gravityZ < 0 {
            extendedPitch = originalPitch
        } else if originalPitch > 0 {
            extendedPitch = 180 - originalPitch
        } else {
            extendedPitch = -180 - originalPitch
        }
        
        /// Subtract pitch by 90 to set vertical device to be origin pitch angle
        return extendedPitch - 90
    }
}
