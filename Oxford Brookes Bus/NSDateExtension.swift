//
//  NSDateExtension.swift
//  Oxford Brookes Bus
//
//  Created by AJ Norton on 4/21/15.
//  Copyright (c) 2015 AJ Norton. All rights reserved.
//

import Foundation

extension NSDate{
    
    public static var currentMilitaryTime: Int {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute, fromDate: date)
        let hour = components.hour
        let minutes = components.minute
        return hour * 100 + minutes
    }
    
    public enum BusDayPatterns: Int{
        case Sunday = 1
        case Monday
        case Tuesday
        case Wednesday
        case Thursday
        case Friday
        case Saturday

        case WendnesdayAndFriday
        case FridayOnly
    }
    
    
    // Vacation is 25th May 2015 – 11th Sep 2015.
    //             5/25            9/11
    public func isSummer() -> Bool
    {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitMonth
                                             | .CalendarUnitDay
                                             | .CalendarUnitYear, fromDate: self)
        components.month = 5
        components.day = 25
        components.hour = 0
   
        var startSummer: NSDate = calendar.dateFromComponents(components)!
        //println(startSummer)
        if(self.compare(startSummer) == NSComparisonResult.OrderedAscending)
        {
            return false
        }
        
        components.month = 9
        components.day = 11
        
        var endSummer: NSDate = calendar.dateFromComponents(components)!
        
        if(self.compare(endSummer) == NSComparisonResult.OrderedDescending)
        {
            return false
        }
        
        return true
    }
    
    
    /**
    Returns 0 if Weekday
    1 if Saturday
    2 if Sunday
    */
    public class func getWeekday() -> Int?
    {
        let todayDate = NSDate()
        let myCalendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        let myComponents = myCalendar?.components(.WeekdayCalendarUnit, fromDate: todayDate)
        let day = myComponents!.weekday
        var a = BusDayPatterns(rawValue: day)!
        switch a
        {
        case .Monday, .Tuesday, .Wednesday, .Thursday, .Friday: // Monday - Friday
            return 0
        case .Saturday: // saturday
            return 1
        case .Sunday: // sunday
            return 2
        default: // out of week index
            NSException(name: "Date Incorrect", reason: "Returned a value outside of 1 - 7", userInfo: nil).raise()
            return nil
        }
    }
    
    public class func militaryTimeDifferanceInMinutes(time1: Int, time2: Int) -> Int
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
    
    public class func minutesToHours(minutes: Int) -> String
    {
        var hours = minutes / 60
        var minutes = minutes % 60
        
        var hoursStr = ""
        var minutesStr = ""
        var andStr = ""
        
        if(hours >= 1 && minutes >= 1)
        {
            andStr = ", "
        }
        
        if(hours == 1)
        {
            hoursStr = "1 hour"
        }
        else if(hours > 1)
        {
            hoursStr = "\(hours) hours"
        }
            
            
        if(minutes == 1)
        {
            minutesStr = "1 minute"
        }
        else if(minutes > 1)
        {
            minutesStr = "\(minutes) minutes"
        }
        
        return hoursStr + andStr + minutesStr
    }
    
    

    
    
    
    
}