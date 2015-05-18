//
//  NSDateTest.swift
//  Oxford Brookes Bus
//
//  Created by AJ Norton on 5/18/15.
//  Copyright (c) 2015 AJ Norton. All rights reserved.
//

import UIKit
import Quick
import Foundation
import Nimble
import XCTest
import Oxford_Brookes_Bus


class NSDateTest: QuickSpec {
    override func spec() {
        
        describe("NSDate")
            {
                it("is the right time")
                    {
                        expect(NSDate.minutesToHours(61)).to(equal("1 hour and 1 minute"))
                }
                
        }
    }
}
