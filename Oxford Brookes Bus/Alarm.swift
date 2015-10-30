//
//  Alarm.swift
//  Oxford Brookes Bus
//
//  Created by AJ Norton on 5/21/15.
//  Copyright (c) 2015 AJ Norton. All rights reserved.
//

import Foundation
import EventKit
import UIKit



public class Alarm{
        
    static var calendarDatabase = EKEventStore()
    
    public class func eventStoreAccessReminders() {
        calendarDatabase.requestAccessToEntityType(EKEntityType.Reminder,
            completion: {(granted: Bool, error:Optional<NSError>)
                -> Void in
                if !granted {}
                else{}
        })
    }
    
    /**
    
    */
    public class func createReminder(reminderTitle: String, timeInterval: NSDate) {
        
        _ = calendarDatabase.calendarsForEntityType(EKEntityType.Reminder)
        
        eventStoreAccessReminders()
        
        let reminder = EKReminder(eventStore: calendarDatabase)
        
        reminder.title = reminderTitle
        
        let alarm = EKAlarm(absoluteDate: timeInterval)
        
        reminder.addAlarm(alarm)
        
        reminder.calendar = calendarDatabase.defaultCalendarForNewReminders()
        
        var error: NSError?
        
        do {
            try calendarDatabase.saveReminder(reminder, commit: true)
        } catch let error1 as NSError {
            error = error1
        }
    }
    
    public class func getReminderView(timeInterval: Int, view: UIView) -> UIAlertController
    {
    
        let refreshAlert = UIAlertController(title: "Reminder",
                                             message: "Remind me in \(timeInterval) minutes",
                                             preferredStyle: UIAlertControllerStyle.Alert)
    
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))

        
        //  TODO: fix unrecognized text box
//        refreshAlert.addTextFieldWithConfigurationHandler()
//        { textField -> Void in
//            textField.text = "\(timeInterval)"
//            textField.keyboardType = UIKeyboardType.NumberPad
//        }
    
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default )
        { action in
            let strTime = "\(timeInterval)"
            if(strTime != "")
            {
                let time = Int(strTime)!
                if(time < 300)
                {
                    Alarm.createReminder("Catch the Bus",
                        timeInterval: NSDate(timeIntervalSinceNow: Double(time * 60)))
                }
                else
                {
                    Alert.presentErrorSheet("Select a time under 300 minutes",
                                            view: view.parentViewController!)
                }
            }
            else
            {
                Alert.presentErrorSheet("Select a real time!", view: view.parentViewController!)
            }
        })

        return refreshAlert
    }
    
}
