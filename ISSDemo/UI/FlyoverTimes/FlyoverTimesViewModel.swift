//
//  FlyoverTimesViewModel.swift
//  ISSDemo
//
//  Created by YUE CHEN on 18/12/2019.
//  Copyright © 2019 YUE CHEN. All rights reserved.
//

import Foundation
import RealmSwift

class FlyoverTimesViewModel {
    
    // MARK: - Properties
    
    let getFlyoverTimesService = GetFlyoverTimesService()
    fileprivate let locationUpdater = LocationUpdater()
    fileprivate var locationUpdateToken: NotificationToken?
    
    // MARK: - Methods
    
    /// Gets the current stored FlyoverTime list in Realm DB
    ///
    /// - Returns: FlyoverTime list stored in Realm
    func currentFlyoverTimes() -> [FlyoverTime] {
        return Array(ISSPassTimes.current().flyoverTimes)
    }
    
    /// Update data for FlyoverTimesViewController
    /// Firstly start CoreLocation service to get current GPS info
    /// On Location updated, get FlyoverTimes based on GPS location
    /// Invalidate Realm token and stop CoreLocation service once location data updated
    func getData() {
        locationUpdater.startLocationUpdates()
        
        locationUpdateToken = LocationStream.current().observe { [weak self] _ in
            self?.getFlyoverTimes()
            self?.locationUpdateToken?.invalidate()
            self?.locationUpdater.stopLocationUpdates()
        }
    }
    
    /// Call GetFlyoverTimesService to get the latest FlyoverTimes
    fileprivate func getFlyoverTimes() {
        guard let latitude = LocationStream.current().latitude(),
            let longitude = LocationStream.current().longitude() else {
            return
        }
        
        getFlyoverTimesService.getFlyoverTimes(latitude: latitude,
                                               longitude: longitude)
    }
}
