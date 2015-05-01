//
//  BusRoute.swift
//  Oxford Brookes Bus
//
//  Created by AJ Norton on 5/1/15.
//  Copyright (c) 2015 AJ Norton. All rights reserved.
//

import UIKit
import CoreData

class BusRoute: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var destination: String
    @NSManaged var endTime: NSNumber
    @NSManaged var startTime: NSNumber
    @NSManaged var schedule: NSNumber
    @NSManaged var stops: NSSet
    
    

    
    class func createBusRoute(name: String, destination: String, startTime: Int, endTime: Int, schedule: Int) -> BusRoute {
        
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("BusRoute", inManagedObjectContext: CoreDataModel.context) as! BusRoute
        newItem.name = name
        newItem.destination = destination
        newItem.startTime = startTime
        newItem.endTime = endTime
        newItem.schedule = schedule
        
        return newItem
    }
    
    class func allBusRoutes() -> [String]
    {
        var appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var moc: NSManagedObjectContext = appDel.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName: "BusRoute")
        
        var sort = NSSortDescriptor(key: "name", ascending: true) // sort by bus stop
        
        fetchRequest.sortDescriptors = [sort]
        
        // Execute the fetch request, and cast the results to an array of LogItem objects
        if let fetchResults = moc.executeFetchRequest(fetchRequest, error: nil) as? [BusRoute] {
            return Array(Set(fetchResults.map({ $0.name })))
        }
        
        return []
    }
    
    class func busRoutes(name: String) -> [String]
    {
        var appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var moc: NSManagedObjectContext = appDel.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName: "Stop")
 
        var sort = NSSortDescriptor(key: "stop_number", ascending: true) // sort by bus stop
        
        fetchRequest.sortDescriptors = [sort]
        
        let predicate = NSPredicate(format: "busParent.name == %@", name)
        
        fetchRequest.predicate = predicate
    
        // Execute the fetch request, and cast the results to an array of LogItem objects
        if let fetchResults = moc.executeFetchRequest(fetchRequest, error: nil) as? [Stop] {
            return removeDuplicates(fetchResults.map({ $0.stop_name }))
            
        }
        
        return []
        
      
    }
    
    
    
    class func removeDuplicates(strings: [String]) -> [String]
    {
        var array = [String]()
        for s in strings
        {
            if !contains(array, s)
            {
                array.append(s)
            }
        }
        return array
        
    }
    
    class func getTimesFromStop(stop: String) -> String
    {
        var appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var moc: NSManagedObjectContext = appDel.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName: "Stop")
        
        //   var sort = NSSortDescriptor(key: "name", ascending: true) // sort by bus stop
        
        //   fetchRequest.sortDescriptors = [sort]
        
        var currentTime = NSDate.getTime()
        
        let predicate = NSPredicate(format: "time >= %ld", 800)
        
        let predicate2 = NSPredicate(format: "stop_name == %@", stop)
        
        fetchRequest.predicate = NSCompoundPredicate.andPredicateWithSubpredicates([predicate, predicate2])
        
        var str: String = ""
        
        // Execute the fetch request, and cast the results to an array of LogItem objects
        if let fetchResults = moc.executeFetchRequest(fetchRequest, error: nil) as? [Stop] {
            
            var stops = fetchResults
            
            
            for st in stops
            {
                str += "\(st.time), "
            }
            
        }
        
        return str
    }

}
