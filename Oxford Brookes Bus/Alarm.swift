//
//  Alarm.swift
//  Oxford Brookes Bus
//
//  Created by AJ Norton on 5/21/15.
//  Copyright (c) 2015 AJ Norton. All rights reserved.
//

import Foundation
import EventKit



public class Alarm{
    static var calendarDatabase = EKEventStore()
    
    public class func eventStoreAccessReminders() {
        
        calendarDatabase.requestAccessToEntityType(EKEntityTypeReminder,
            completion: {(granted: Bool, error:NSError!)
                -> Void in
                if !granted {
                   // println("hello world")
                }
        })
    }
    
    public class func createReminder(reminderTitle: String, timeInterval: NSDate) {
        
        var calendars = calendarDatabase.calendarsForEntityType(EKEntityTypeReminder)
        
        eventStoreAccessReminders()
        
        let reminder = EKReminder(eventStore: calendarDatabase)
        
        reminder.title = reminderTitle
        
        let alarm = EKAlarm(absoluteDate: timeInterval)
        
        reminder.addAlarm(alarm)
        
        reminder.calendar = calendarDatabase.defaultCalendarForNewReminders()
        
        var error: NSError?
        
        calendarDatabase.saveReminder(reminder, commit: true, error: &error)
    }
    
    
}
