//
//  RealmTests.swift
//  ISSDemoTests
//
//  Created by YUE CHEN on 18/12/2019.
//  Copyright © 2019 YUE CHEN. All rights reserved.
//

import XCTest
import RealmSwift
import CoreLocation
@testable import ISSDemo

class RealmTests: XCTestCase {

    override func setUp() {
        super.setUp()
        Realm.removeAllObjects()
    }
    
    override func tearDown() {
        Realm.removeAllObjects()
        super.tearDown()
    }
    
    func testValidation() {
        let result = Realm.validateRealm()
        XCTAssertTrue(result)
    }

    func testDefaultInstance() {
        XCTAssertNotNil(Realm.defaultInstance())
    }
    
    func testRemoval() {
        XCTAssertEqual(Realm.defaultInstance().objects(LocationStream.self).count, 0)
    }
    
    func testStorePhoto() {
        let mockLocation1 = CLLocation(latitude: CLLocationDegrees(51.20), longitude: CLLocationDegrees(-4.22))
        let mockLocation2 = CLLocation(latitude: CLLocationDegrees(54.02), longitude: CLLocationDegrees(-2.12))
        XCTAssertEqual(Realm.defaultInstance().objects(LocationStream.self).count, 0)
        LocationStream.current().append([mockLocation1])
        XCTAssertEqual(Realm.defaultInstance().objects(LocationStream.self).count, 1)
        LocationStream.current().append([mockLocation2])
        XCTAssertEqual(Realm.defaultInstance().objects(LocationStream.self).count, 1)
    }

}
