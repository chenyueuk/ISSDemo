//
//  MenuViewModel.swift
//  ISSDemo
//
//  Created by YUE CHEN on 18/12/2019.
//  Copyright © 2019 YUE CHEN. All rights reserved.
//

import Foundation

struct MenuViewModel {
    
    // MARK: - Enums
    enum Item: Int {
        /// Use Int value for sorting Swift Array types
        case flyoverTimes, issLocation, compassToIss, absoluteToIss, test
        
        /// Description string of the item type.
        ///
        /// - Returns: the description used for table cell text.
        func description() -> String {
            switch self {
            case .flyoverTimes:
                return "Flyover"
            case .issLocation:
                return "Where is the ISS?"
            case .compassToIss:
                return "Compass direction to the ISS"
            case .absoluteToIss:
                return "Absolute direction to the ISS"
            case .test:
                return "Debug data (only shown in iOS simulator)"
            }
        }
        
        /// The type of MenuDetailsControllerProtocol related to the Item
        /// MenuDetailsControllerProtocol has initalizer from storyboard
        ///
        /// - Returns: type of MenuDetailsControllerProtocol related to the current Item
        func getType() -> MenuDetailsControllerProtocol.Type {
            switch self {
            case .flyoverTimes:
                return FlyoverTimesViewController.self
            case .issLocation:
                return ISSMapViewController.self
            case .compassToIss:
                return ISSCompassViewController.self
            case .absoluteToIss:
                return ISSAbsoluteDirectionViewController.self
            case.test:
                return TestViewController.self
            }
        }
    }
    
    // MARK: - Properties
    
    /// Items to be displayed in the Menu table, .test only shown when using DEBUG scheme
    var items: [Item] {
        get {
            #if targetEnvironment(simulator)
            return [.flyoverTimes, .issLocation, .compassToIss, .absoluteToIss, .test]
            #else
            return [.flyoverTimes, .issLocation, .compassToIss, .absoluteToIss]
            #endif
        }
    }
}
