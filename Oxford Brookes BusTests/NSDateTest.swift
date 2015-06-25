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
            describe("minutes To Hours")
            {
                it("is the right time")
                {
                    expect(NSDate.minutesToHours(61)).to(equal("1 hour, 1 minute"))
                    expect(NSDate.minutesToHours(1)).to(equal("1 minute"))
                    expect(NSDate.minutesToHours(120)).to(equal("2 hours"))
                    expect(NSDate.minutesToHours(123)).to(equal("2 hours, 3 minutes"))
                }
            }
            
            describe("Military time differance")
            {
                it("is a time differance")
                {
                    expect(NSDate.militaryTimeDifferanceInMinutes(1240, time2: 1123)).to(equal(17 + 60))
                    expect(NSDate.militaryTimeDifferanceInMinutes(1140, time2: 1123)).to(equal(17))
                }
            }
            
            describe("summer comparison")
            {
                it("is summer")
                {
                    var dateString = "2015-06-25" // change to your date format
                    var dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "YYYY-MM-dd"
                    var someDate = dateFormatter.dateFromString(dateString)!
                    
                    let calendar = NSCalendar.currentCalendar()
                    let components = calendar.components(NSCalendarUnit.CalendarUnitMonth
                        | NSCalendarUnit.CalendarUnitDay
                        | .CalendarUnitYear, fromDate: someDate)
                    components.month = 5
                    components.day = 25
                    expect(someDate.isSummer()).to(equal(true))
                }
                
                it("is before summer")
                {
                    var dateString = "2015-03-25" // change to your date format
                    var dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "YYYY-MM-dd"
                    var someDate = dateFormatter.dateFromString(dateString)!
                    
                    let calendar = NSCalendar.currentCalendar()
                    let components = calendar.components(NSCalendarUnit.CalendarUnitMonth
                        | NSCalendarUnit.CalendarUnitDay
                        | .CalendarUnitYear, fromDate: someDate)
                    components.month = 5
                    components.day = 25
                    expect(someDate.isSummer()).to(equal(false))
                }
                
                it("is after summer")
                    {
                        var dateString = "2015-12-25" // change to your date format
                        var dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "YYYY-MM-dd"
                        var someDate = dateFormatter.dateFromString(dateString)!
                        
                        let calendar = NSCalendar.currentCalendar()
                        let components = calendar.components(NSCalendarUnit.CalendarUnitMonth
                            | NSCalendarUnit.CalendarUnitDay
                            | .CalendarUnitYear, fromDate: someDate)
                        components.month = 5
                        components.day = 25
                        expect(someDate.isSummer()).to(equal(false))
                }
            }
        }
    }
}
