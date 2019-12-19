//
//  ISSAnnotation.swift
//  ISSDemo
//
//  Created by YUE CHEN on 18/12/2019.
//  Copyright © 2019 YUE CHEN. All rights reserved.
//

import MapKit

class ISSAnnotation: NSObject, MKAnnotation {
    
    // MARK: - Properties
    
    @objc dynamic var coordinate: CLLocationCoordinate2D
  
    // MARK: - Initializers
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        super.init()
    }
}
