//
//  Stop.swift
//  Oxford Brookes Bus
//
//  Created by AJ Norton on 4/27/15.
//  Copyright (c) 2015 AJ Norton. All rights reserved.
//

import CoreData
import UIKit

class Stop: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var stop_number: NSNumber
    @NSManaged var times: NSSet
    
  
    class func createInManagedObjectContext(name: String) -> Stop {
        var appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var moc: NSManagedObjectContext = appDel.managedObjectContext!

        let newItem = NSEntityDescription.insertNewObjectForEntityForName("Stop", inManagedObjectContext: moc) as! Stop
        newItem.name = name
        newItem.stop_number = 0
        
        return newItem
    }
    
    class func getAllBusStops() -> [Stop]?
    {
        var appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var moc: NSManagedObjectContext = appDel.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName: "Stop")
        
        // Execute the fetch request, and cast the results to an array of LogItem objects
        if let fetchResults = moc.executeFetchRequest(fetchRequest, error: nil) as? [Stop] {
            return fetchResults
        }
        return nil
    }
    
    
    func displayAllTimes() -> String
    {
        var str = ""
        for t in times
        {
            let ti = t as! Time
            str += "\(ti.time)"
        }
        
        return str
    }
}
