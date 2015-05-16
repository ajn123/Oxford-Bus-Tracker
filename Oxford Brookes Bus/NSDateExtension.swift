//
//  NSDateExtension.swift
//  Oxford Brookes Bus
//
//  Created by AJ Norton on 4/21/15.
//  Copyright (c) 2015 AJ Norton. All rights reserved.
//

import Foundation

extension NSDate{
    
    
    static var currentMilitaryTime: Int {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute, fromDate: date)
        let hour = components.hour
        let minutes = components.minute
        return hour * 100 + minutes
    }
    
    /**
    Returns 0 if Weekday
    1 if Saturday
    2 if Sunday
    */
    class func getWeekday() -> Int?
    {
        let todayDate = NSDate()
        let myCalendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        let myComponents = myCalendar?.components(.WeekdayCalendarUnit, fromDate: todayDate)
        let day = myComponents!.weekday
  
        println(day)
        switch day
        {
        case 2...6:
            return 0
        case 1:
            return 2
        case 7:
            return 1
        default:
            NSException(name: "Date Incorrect", reason: "Returned a value outside of 1 - 7", userInfo: nil).raise()
            return nil
        }
    }
    
    class func militaryTimeDifferanceInMinutes(time1: Int, time2: Int) -> Int
    {
        if time2 > time1
        {
            NSException(name: "Incorrect Parameters", reason: "first parameter time1 should be bigger than parameter time2", userInfo: nil)
        }
        
        var time1Hour = time1 / 100
        var time2Hour = time2 / 100
        
        var hourDifferance = time1Hour - time2Hour
        
        return time1 - time2 - (40 * hourDifferance)
    }
}