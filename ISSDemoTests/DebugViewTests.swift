//
//  DebugViewTests.swift
//  ISSDemoTests
//
//  Created by YUE CHEN on 18/12/2019.
//  Copyright © 2019 YUE CHEN. All rights reserved.
//

import XCTest
@testable import ISSDemo

class DebugViewTests: XCTestCase {

    let debugVC = TestViewController.instantiateFromStoryboard() as? TestViewController

    func testViews() {
        _ = debugVC?.view
        XCTAssertNotNil(debugVC)
        XCTAssertNotNil(debugVC?.latitudeLabel)
        XCTAssertNotNil(debugVC?.longitudeLabel)
        XCTAssertNotNil(debugVC?.altitudeLabel)
    }

}
