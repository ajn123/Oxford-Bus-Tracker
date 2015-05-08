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
    @NSManaged var direction: Bool
    
    class func createBusRoute(name: String, destination: String, startTime: Int, endTime: Int, schedule: Int, direction: Bool) -> BusRoute {
        
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("BusRoute", inManagedObjectContext: CoreDataModel.context) as! BusRoute
        newItem.name = name
        newItem.destination = destination
        newItem.startTime = startTime
        newItem.endTime = endTime
        newItem.schedule = schedule
        newItem.direction = direction
        
        return newItem
    }
    
    class func allBusRoutes() -> [String]
    {
        let fetchRequest = NSFetchRequest(entityName: "BusRoute")
        
        var sort = NSSortDescriptor(key: "name", ascending: true) // sort by bus stop
        
        fetchRequest.sortDescriptors = [sort]
        
        // Execute the fetch request, and cast the results to an array of LogItem objects
        if let fetchResults = CoreDataModel.context.executeFetchRequest(fetchRequest, error: nil) as? [BusRoute] {
            return Array(Set(fetchResults.map({ $0.name })))
        }
        
        return []
    }
    
    class func busRoutes(name: String, direction: Bool = true) -> [String]
    {
        let fetchRequest = NSFetchRequest(entityName: "Stop")
 
        var sort = NSSortDescriptor(key: "stop_number", ascending: true) // sort by bus stop
        
        fetchRequest.sortDescriptors = [sort]
        
        let predicate = NSPredicate(format: "busParent.name == %@", name)
        
        let predicate2 = NSPredicate(format: "busParent.direction == %@", direction)
        
        fetchRequest.predicate = NSCompoundPredicate.andPredicateWithSubpredicates([predicate, predicate2])
    
        // Execute the fetch request, and cast the results to an array of LogItem objects
        if let fetchResults = CoreDataModel.context.executeFetchRequest(fetchRequest, error: nil) as? [Stop] {
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
    
    class func getDepartures(stop: String, direction: Bool = true, name: String) -> [Stop]
    {
        let fetchRequest = NSFetchRequest(entityName: "Stop")
        
        //   var sort = NSSortDescriptor(key: "name", ascending: true) // sort by bus stop
        
        //   fetchRequest.sortDescriptors = [sort]
        
        var currentTime = NSDate.getTime()
        
        var sort = NSSortDescriptor(key: "time", ascending: true) // sort by bus stop
        
        fetchRequest.sortDescriptors = [sort]
        
        let predicate = NSPredicate(format: "time >= %ld", currentTime)
        
        let predicate2 = NSPredicate(format: "stop_name == %@", stop)
        
        let predicate3 = NSPredicate(format: "busParent.direction == %@", direction)
        
        let predicate4 = NSPredicate(format: "busParent.name == %@", name)
        
        fetchRequest.predicate = NSCompoundPredicate.andPredicateWithSubpredicates(
            [predicate, predicate2, predicate3, predicate4])
        
        // Execute the fetch request, and cast the results to an array of LogItem objects
        return (CoreDataModel.context.executeFetchRequest(fetchRequest, error: nil) as? [Stop])!
        
    }
    
    class func getTimesFromStop(stop: String, direction: Bool = true, name: String) -> [String]
    {
        var str = [String]()
        
        let fetchResults = getDepartures(stop, direction: direction, name: name)
            
        var stops = fetchResults
        
        for st in stops
        {
            str.append("\(st.time)")
        }
        
        return str
    }
    
    
    class func getRecentDepartures(stop: String, direction: Bool = true, name: String) -> String
    {
        var fetchResults = getDepartures(stop, direction: direction, name: name)
        
        var slice: ArraySlice<Stop>?
        
        var str = ""
        
        println(fetchResults.count)
        
        switch fetchResults.count
        {
        case 0:
            str = "no times left for today"
        case 1:
            slice = fetchResults[0...0]
        case 2:
            slice = fetchResults[0...1]
        default:
             slice = fetchResults[0...2]
        }
        
        if (slice != nil){
        
            var currentTime = NSDate.getTime()
        
            for times in slice!
            {
                var timeToGo = NSDate.militaryTimeDifferanceInMinutes(times.time.integerValue, time2: currentTime)
                str += "\(timeToGo) minutes \(times.time.integerValue)\n"
            }
        }
        
        return str
        
        
    }

}
