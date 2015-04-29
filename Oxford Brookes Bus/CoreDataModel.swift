//
//  CoreDataModel.swift
//  Oxford Brookes Bus
//
//  Created by AJ Norton on 4/27/15.
//  Copyright (c) 2015 AJ Norton. All rights reserved.
//

import UIKit
import CoreData

class CoreDataModel
{
    
    // TODO: add paramenters
    class func addData(name: String, stop_num: Int = 0){
        var appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var context: NSManagedObjectContext = appDel.managedObjectContext!
        
        let stop = Stop.createInManagedObjectContext(name, stop_number: stop_num)
        
        let time = NSEntityDescription.insertNewObjectForEntityForName("Time", inManagedObjectContext: context) as! Time
        time.time = 2300 % 2000
        time.direction = 1 // 0 for end, 1 for down, 2 for up
        time.day = 0       // 0 for M-F, 1 for Saturday, 2 for Sunday
        time.bus_type = "U1"
        
        // set time as a parent of stop
        time.parent = stop
        
       // context.save(nil)
    }
    
    class func addTimesData(name: String, stop_num: Int = 0, times: [Time]){
        var appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var context: NSManagedObjectContext = appDel.managedObjectContext!
        
        let stop = Stop.createInManagedObjectContext(name, stop_number: stop_num)
        
        for t in times
        {
            let time = NSEntityDescription.insertNewObjectForEntityForName("Time", inManagedObjectContext: context) as! Time
            time.time = t.time
            time.direction = 1 // 0 for end, 1 for down, 2 for up
            time.day = 0       // 0 for M-F, 1 for Saturday, 2 for Sunday
            time.bus_type = "U1"
        
        // set time as a parent of stop
            time.parent = stop
        }
        
        // context.save(nil)
    }
    
    
    class func massAssign()
    {
        var array =
        [
            (name: "Wheatley campus", stop_times: [645, 715, 745, 820, 850, 920, 950, 1010, 1040, 1110, 1140, 1210, 1240, 1310, 1340, 1410, 1440, 1510, 1540, 1610, 1640, 1710, 1740, 1810, 1905, 2005, 2105, 2205, 2235], day: 0, bus_type: "U1", direction: 1),
            (name: "Wheatley church", stop_times: [649, 719, 749, 824, 854, 924, 954, 1014, 1044, 1114, 1144, 1214, 1244, 1314, 1344, 1414, 1444, 1514, 1544, 1614, 1644, 1714, 1744, 1813, 1908, 2008, 2108, 2208, 2238], day: 0, bus_type: "U1", direction: 1)
        ]
        massAssignBusStops(array)
    }
    

    class func massAssignBusStops(tup: [(name: String, stop_times: [Int], day: Int, bus_type: String, direction: Int)])
    {
        var appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var context: NSManagedObjectContext = appDel.managedObjectContext!
        
        for (index, t) in enumerate(tup)
        {
            let stop = Stop.createInManagedObjectContext(t.name, stop_number: index)
            
            for s in t.stop_times
            {
                let time = NSEntityDescription.insertNewObjectForEntityForName("Time", inManagedObjectContext: context) as! Time
                time.time = s
                time.direction = t.direction // 0 for end, 1 for down, 2 for up
                time.day = t.day       // 0 for M-F, 1 for Saturday, 2 for Sunday
                time.bus_type = t.bus_type
                
                // set time as a parent of stop
                time.parent = stop
            }
            
        }
        
        
        /**for t in times
        {
            let time = NSEntityDescription.insertNewObjectForEntityForName("Time", inManagedObjectContext: context) as! Time
            time.time = t.time
            time.direction = 1 // 0 for end, 1 for down, 2 for up
            time.day = 0       // 0 for M-F, 1 for Saturday, 2 for Sunday
            time.bus_type = "U1"
            
            // set time as a parent of stop
            time.parent = stop
        }
*/
        
    }
}




