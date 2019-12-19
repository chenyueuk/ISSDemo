//
//  LocationStreamTests.swift
//  ISSDemoTests
//
//  Created by YUE CHEN on 18/12/2019.
//  Copyright © 2019 YUE CHEN. All rights reserved.
//

import XCTest
import RealmSwift
import CoreLocation
@testable import ISSDemo

class LocationStreamTests: XCTestCase {

    
    override func setUp() {
        super.setUp()
        Realm.removeAllObjects()
    }

    override func tearDown() {
        Realm.removeAllObjects()
        super.tearDown()
    }

    func testProperties() {
        let locationStream = LocationStream()
        XCTAssertNotNil(locationStream.latitudes)
        XCTAssertNotNil(locationStream.longitudes)
    }
    
    func testAppendToList() {
        let mockLocation1 = CLLocation(latitude: CLLocationDegrees(51.20), longitude: CLLocationDegrees(-4.22))
        let mockLocation2 = CLLocation(latitude: CLLocationDegrees(54.02), longitude: CLLocationDegrees(-2.12))
        let locationStream = LocationStream()
        
        XCTAssertEqual(locationStream.longitudes.count, 0)
        XCTAssertEqual(locationStream.latitudes.count, 0)
        
        locationStream.appendToList(mockLocation1)
        XCTAssertEqual(locationStream.latitudes.count, 1)
        XCTAssertEqual(locationStream.longitudes.count, 1)
        XCTAssertEqual(locationStream.latitudes.last, 51.20)
        XCTAssertEqual(locationStream.longitudes.last, -4.22)
        
        locationStream.appendToList(mockLocation2)
        XCTAssertEqual(locationStream.latitudes.count, 2)
        XCTAssertEqual(locationStream.longitudes.count, 2)
        XCTAssertEqual(locationStream.latitudes.last, 54.02)
        XCTAssertEqual(locationStream.longitudes.last, -2.12)
    }

    func testCurrentValues() {
        let locationStream = LocationStream()
        
        let mockLocation1 = CLLocation(coordinate: CLLocationCoordinate2D(latitude: 51.20,
                                                                          longitude: -4.22),
                                       altitude: CLLocationAccuracy(8848.88),
                                       horizontalAccuracy: CLLocationAccuracy(10.4),
                                       verticalAccuracy: CLLocationAccuracy(10.4),
                                       course: CLLocationDirection(40.88),
                                       speed: CLLocationSpeed(500),
                                       timestamp: Date())
        let mockLocation2 = CLLocation(latitude: CLLocationDegrees(54.02),
                                       longitude: CLLocationDegrees(-2.12))
        
        XCTAssertNil(LocationStream.current().latitude())
        XCTAssertNil(LocationStream.current().longitude())
        
        XCTAssertNil(locationStream.latitude())
        XCTAssertNil(locationStream.longitude())
        
        locationStream.appendToList(mockLocation1)
        XCTAssertEqual(locationStream.latitude(), 51.20)
        XCTAssertEqual(locationStream.longitude(), -4.22)
        XCTAssertEqual(locationStream.altitude(), 8848.88)
        
        locationStream.appendToList(mockLocation2)
        XCTAssertEqual(locationStream.latitude(), 54.02)
        XCTAssertEqual(locationStream.longitude(), -2.12)
    }
    
    func testMaxBuffer() {
        let locationStream = LocationStream()
        let mockLocation = CLLocation(latitude: CLLocationDegrees(51.20),
                                      longitude: CLLocationDegrees(-4.22))
        
        XCTAssertEqual(locationStream.longitudes.count, 0)
        XCTAssertEqual(locationStream.latitudes.count, 0)
        
        for _ in 0...(locationStream.maxBufferSize + 10) {
            locationStream.appendToList(mockLocation)
        }
        
        XCTAssertEqual(locationStream.longitudes.count, locationStream.maxBufferSize)
        XCTAssertEqual(locationStream.latitudes.count, locationStream.maxBufferSize)
    }
}
