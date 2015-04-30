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
        
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("Stop", inManagedObjectContext: CoreDataModel.context) as! Stop
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
            return Array(Set(strRoutes)) // remove duplicates by converting to a set
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
        var times = getTimesAsArray()
        
        var str = ""
        for t in times
        {
            str += "\(t.time), "
        }
        
        return str
    }
    
    func displayNextTimes(count: Int = 3) -> String
    {
        var currentTime = NSDate.getTime()
        
        var allTimes = getTimesAsArray()
        
        var futureTimes = allTimes.filter()
        {
            return $0.time.integerValue > currentTime
        }
        
        var str = ""
        
        if(futureTimes.count > 0)
        {
        
            for t in futureTimes[0...1]
            {

                str += "Arriving at: \(t.time), \(t.time.integerValue - currentTime) till Departure  \n"
            }
        }
        
        return str
    }
    
}
