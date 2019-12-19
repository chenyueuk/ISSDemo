//
//  AppDelegate.swift
//  ISSDemo
//
//  Created by YUE CHEN on 18/12/2019.
//  Copyright © 2019 YUE CHEN. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let locationUpdater = LocationUpdater()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        /// Valide Realm make sure the default instance of Realm is available. It can fail due to Realm schema out of date.
        guard Realm.validateRealm() else {
            let errorMessage = "Failure: Invalid Realm database, please check if the Realm schema is up-to-date."
            assertionFailure(errorMessage)
            return false
        }
        
        /// Get location permission
        locationUpdater.locationManager.requestWhenInUseAuthorization()
        
        return true
    }

    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

