//
//  Oxford_Brookes_BusTests.swift
//  Oxford Brookes BusTests
//
//  Created by AJ Norton on 4/20/15.
//  Copyright (c) 2015 AJ Norton. All rights reserved.
//

import UIKit
import Foundation
import XCTest
import Oxford_Brookes_Bus
import CoreData


class Oxford_Brookes_BusTests: XCTestCase {
  
  let instance = OxonTimeAPI.sharedInstance

  override func setUp() {
    super.setUp()
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testLoadLiveBusTimes() {
    var a = instance.getStopInfo("Gipsy Lane Campus")
    XCTAssertGreaterThanOrEqual(a.count, 1)
  }
  
}
