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

    @NSManaged var stop_name: String
    @NSManaged var bus_route: String
    @NSManaged var stop_number: NSNumber
    @NSManaged var times: NSSet
    
  
    class func createInManagedObjectContext(name: String, stop_number: Int = 0, bus_route: String = "Nono") -> Stop {
        var appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var moc: NSManagedObjectContext = appDel.managedObjectContext!

        let newItem = NSEntityDescription.insertNewObjectForEntityForName("Stop", inManagedObjectContext: moc) as! Stop
        newItem.stop_name = name
        newItem.stop_number = stop_number
        newItem.bus_route = bus_route
        
        return newItem
    }
    
    class func getAllBusStops() -> [Stop]?
    {
        var appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var moc: NSManagedObjectContext = appDel.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName: "Stop")
        
        var sort = NSSortDescriptor(key: "stop_number", ascending: true) // sort by bus stop
        
        fetchRequest.sortDescriptors = [sort]
        
        // Execute the fetch request, and cast the results to an array of LogItem objects
        if let fetchResults = moc.executeFetchRequest(fetchRequest, error: nil) as? [Stop] {
            return fetchResults
        }
        
        return nil
    }
    
    class func getBusRoutes() -> [String]?
    {
        var appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var moc: NSManagedObjectContext = appDel.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName: "Stop")
        
        var sort = NSSortDescriptor(key: "bus_route", ascending: true) // sort by bus stop
        
        fetchRequest.sortDescriptors = [sort]
        
        // Execute the fetch request, and cast the results to an array of LogItem objects
        if let fetchResults = moc.executeFetchRequest(fetchRequest, error: nil) as? [Stop] {
            var strRoutes = fetchResults.map()
            {
                return $0.bus_route
            }
            return Array(Set(strRoutes))
        }
        
        return nil
    }
    
    
    func getTimesAsArray() -> [Time]
    {
        var ti = self.times.sortedArrayUsingDescriptors([NSSortDescriptor(key: "time", ascending: true)])
        return ti as! [Time]
    }

    
    
    func displayAllTimes() -> String
    {
        var ti = times.sortedArrayUsingDescriptors([NSSortDescriptor(key: "time", ascending: true)])
        
        var str = ""
        for t in ti
        {
            let ti = t as! Time
            str += "\(ti.time), "
        }
        
        return str
    }
    
    func displayNextTimes(count: Int = 3) -> String
    {
        var currentTime = NSDate.getTime()
        
        var ti = times.sortedArrayUsingDescriptors([NSSortDescriptor(key: "time", ascending: true)])
        
        var tim = ti.filter()
        {
            if let type = $0 as? Time
            {
                return type.time.integerValue > currentTime
            }
            else
            {
                return false
            }
        }
        
        var str = ""
        for t in tim[0..<1]
        {
            let ti = t as! Time
            str += "\(ti.time), "
        }
        
        return str
    }
    
}
