//
//  DeviceTrueHeading.swift
//  ISSDemo
//
//  Created by YUE CHEN on 18/12/2019.
//  Copyright © 2019 YUE CHEN. All rights reserved.
//

import RealmSwift
import CoreLocation

class DeviceTrueHeading: Object {
    
    // MARK: - Properties
    
    @objc dynamic var trueHeading: Double = 0
    @objc dynamic var x: Double = 0
    @objc dynamic var y: Double = 0
    @objc dynamic var z: Double = 0
    
    // MARK: - Methods
    
    /// Retrieves the current DeviceTrueHeading from Realm DB
    ///
    /// - Returns: current DeviceTrueHeading object stored in Realm
    static func current() -> DeviceTrueHeading {
        /// If there is no DeviceTrueHeading object, create one
        guard let deviceTrueHeading = Realm.defaultInstance().objects(DeviceTrueHeading.self).first else {
            NSLog("Warning: cannot find default DeviceTrueHeading object in Realm")
            let newDeviceTrueHeading = DeviceTrueHeading()
            try? Realm.defaultInstance().write {
                Realm.defaultInstance().add(newDeviceTrueHeading)
            }
            return newDeviceTrueHeading
        }
        return deviceTrueHeading
    }
    
    /// Gets the angle to be rotated in radians
    ///
    /// - Returns: angle to be rotated in radians
    func transformationAngle() -> CGFloat {
        return CGFloat(-MathUtils.degreesToRadians(trueHeading))
    }
    
    /// Update the trueHeading instance stroed in Realm
    ///
    /// - Parameters:
    ///   - heading: CLHeading list to updated
    func updateDeviceTrueHeading(_ heading: CLHeading) {
        try? Realm.defaultInstance().write {
            updateDeviceTrueHeading(trueHeading: heading.trueHeading,
                                    x: heading.x,
                                    y: heading.y,
                                    z: heading.z)
        }
    }
    
    /// Update DeviceTrueHeading with the input values
    ///
    /// - Parameters:
    ///   - trueHeading: trueHeading of the DeviceTrueHeading
    ///   - x: x of the DeviceTrueHeading
    ///   - y: y of the DeviceTrueHeading
    ///   - z: z of the DeviceTrueHeading
    fileprivate func updateDeviceTrueHeading(trueHeading: Double, x: Double, y: Double, z: Double) {
        self.trueHeading = trueHeading
        self.x = x
        self.y = y
        self.z = z
    }
}
