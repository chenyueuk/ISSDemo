//
//  FlyoverTimeTests.swift
//  ISSDemoTests
//
//  Created by YUE CHEN on 18/12/2019.
//  Copyright © 2019 YUE CHEN. All rights reserved.
//

import XCTest
@testable import ISSDemo

class FlyoverTimeTests: XCTestCase {

    let flyoverTimeVC = FlyoverTimesViewController.instantiateFromStoryboard() as? FlyoverTimesViewController

    func testViews() {
        flyoverTimeVC?.loadView()
        XCTAssertNotNil(flyoverTimeVC)
        XCTAssertNotNil(flyoverTimeVC?.tableView)
    }

}
