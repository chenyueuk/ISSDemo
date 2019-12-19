//
//  ISSMapViewModel.swift
//  ISSDemo
//
//  Created by YUE CHEN on 18/12/2019.
//  Copyright © 2019 YUE CHEN. All rights reserved.
//

import MapKit
import CoreLocation

class ISSMapViewModel: ISSLocationBaseModel {
    
    // MARK: - Properties
    
    /// Default map region radius, set to 5,000,000 meters
    let regionRadius: CLLocationDistance = 5000000
    
    // MARK: - Methods
    
    /// Gets the MKCoordinateRegion from the ISSLocation default object stored in Realm
    ///
    /// - Returns: MKCoordinateRegion value
    func getCurrentISSLocactionMapRegion() -> MKCoordinateRegion {
        return MKCoordinateRegion(center: getCurrentISSLocation(),
                                  latitudinalMeters: regionRadius,
                                  longitudinalMeters: regionRadius)
    }
}
