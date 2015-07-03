//
//  BusRoute.swift
//  Oxford Brookes Bus
//
//  Created by AJ Norton on 5/1/15.
//  Copyright (c) 2015 AJ Norton. All rights reserved.
//

import UIKit
import CoreData

class BusRoute: NSManagedObject, Printable {

    @NSManaged var name: String
    @NSManaged var destination: String
    @NSManaged var endTime: NSNumber
    @NSManaged var startTime: NSNumber
    @NSManaged var schedule: NSNumber
    @NSManaged var stops: NSSet
    @NSManaged var direction: Bool
    @NSManaged var vacation: Bool
    
    override var description: String
    {
        return "\(name) destination: \(destination) stop_count: \(self.stops.count) direction: \(direction) vacation: \(vacation)"
    }
    
    class func createBusRoute(name: String,
                              destination: String,
                              startTime: Int,
                              endTime: Int,
                              schedule: Int,
                              direction: Bool,
                              vacation: Bool = false) -> BusRoute {
        
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("BusRoute",
                                                                          inManagedObjectContext: CoreDataModel.context)
                                                                          as! BusRoute
        newItem.name = name
        newItem.destination = destination
        newItem.startTime = startTime
        newItem.endTime = endTime
        newItem.schedule = schedule
        newItem.direction = direction
        newItem.vacation = vacation
        
        return newItem
    }
    
    class func allBusRoutes() -> [String]
    {
        let fetchRequest = NSFetchRequest(entityName: "BusRoute")
        
        var sort = NSSortDescriptor(key: "name", ascending: true) // sort by bus stop
        
        fetchRequest.sortDescriptors = [sort]
        
        // Execute the fetch request, and cast the results to an array of LogItem objects
        if let fetchResults = CoreDataModel.context.executeFetchRequest(
                                                        fetchRequest,
                                                        error: nil) as? [BusRoute]
        {
            return fetchResults.map({ $0.name }).removeDuplicates()
        }
        
        return []
    }
    
    
    class func whichDirection(busRoute: String, busStop: String) -> Bool
    {
        let fetchRequest = NSFetchRequest(entityName: "Stop")
        
        var sort = NSSortDescriptor(key: "stop_number", ascending: true) // sort by bus stop
        
        fetchRequest.sortDescriptors = [sort]
        
        let predicate = NSPredicate(format: "busParent.name == %@", busRoute)
        
        let predicate2 = NSPredicate(format: "stop_name == %@", busStop)
        
        fetchRequest.predicate = NSCompoundPredicate.andPredicateWithSubpredicates(
            [predicate, predicate2])
        
        // Execute the fetch request, and cast the results to an array of LogItem objects
        if let fetchResults = CoreDataModel.context.executeFetchRequest(
            fetchRequest,
            error: nil) as? [Stop]
        {
            return fetchResults.first!.busParent.direction
        }
        else
        {
            NSException(name: "wrong direction", reason: "could not find a direction", userInfo: nil).raise()
            return false
        }
        
        
        
        
    }
    
    class func busRoutes(name: String, direction: Bool = true) -> [String]
    {
        let fetchRequest = NSFetchRequest(entityName: "Stop")
 
        var sort = NSSortDescriptor(key: "stop_number", ascending: true) // sort by bus stop
        
        fetchRequest.sortDescriptors = [sort]
        
        let predicate = NSPredicate(format: "busParent.name == %@", name)
        
        let predicate2 = NSPredicate(format: "busParent.direction == %@", direction)
        
        //   let predicate3 = NSPredicate(format: "busParent.schedule == %ld", NSDate.getWeekday()!)
        
        //  let predicate3 = NSPredicate(format: "stop_name == %@", stop_name)
        
        fetchRequest.predicate = NSCompoundPredicate.andPredicateWithSubpredicates(
                                                                [predicate, predicate2])
    
        // Execute the fetch request, and cast the results to an array of LogItem objects
        if let fetchResults = CoreDataModel.context.executeFetchRequest(
                                                        fetchRequest,
                                                        error: nil) as? [Stop]
        {
            return fetchResults.map({ $0.stop_name }).removeDuplicates()
        }
        
        return []
    }
    


    
    class func busDepartureSearchRequest(stop: String,
                                         direction: Bool = true,
                                         name: String,
                                         schedule: Int = 0) -> NSFetchRequest
    {
        let fetchRequest = NSFetchRequest(entityName: "Stop")
        
        var currentTime = NSDate.currentMilitaryTime
        
        var sort = NSSortDescriptor(key: "time", ascending: true) // sort by bus stop
        
        fetchRequest.sortDescriptors = [sort]
        
        let predicate1 = NSPredicate(format: "stop_name == %@", stop)
        
        let predicate2 = NSPredicate(format: "busParent.direction == %@", direction)
        
        let predicate3 = NSPredicate(format: "busParent.name == %@", name)
        
        let predicate4 = NSPredicate(format: "busParent.schedule == %ld", schedule)
        
        let predicate5 = NSPredicate(format: "busParent.vacation == %@", NSDate().isSummer())
        
        fetchRequest.predicate = NSCompoundPredicate.andPredicateWithSubpredicates(
                    [predicate1, predicate2, predicate3, predicate4, predicate5])

        return fetchRequest
    }
    
    class func getDepartures(stop: String,
                             direction: Bool = true,
                             name: String,
                             schedule: Int = 0) -> [Stop]
    {
        let fetchRequest = busDepartureSearchRequest(stop, direction: direction, name: name, schedule: schedule)
        
        let currentTime = NSDate.currentMilitaryTime
        
        let predicate = NSPredicate(format: "time >= %ld", currentTime)
        
        let currentPredicate = fetchRequest.predicate!
        let nextPredicate = NSCompoundPredicate(type: NSCompoundPredicateType.AndPredicateType,
                subpredicates: [currentPredicate, predicate])
        
        fetchRequest.predicate = nextPredicate
        
        // Execute the fetch request, and cast the results to an array of LogItem objects
        return (CoreDataModel.context.executeFetchRequest(fetchRequest, error: nil) as? [Stop])!
    }
    
    
    
    
    class func getTimesFromStop(stop: String,
                                direction: Bool = true,
                                name: String,
                                schedule: Int = 0) -> [String]
    {
        var strings = [String]()
        
        let fetchResults = getDepartures(stop, direction: direction, name: name, schedule: schedule)
            
        var stops = fetchResults
        
        for str in stops
        {
            strings.append("\(str.time)")
        }
        
        return strings
    }
    
    class func getDeparturesRegardlessOfTime(stop: String,
                                             direction: Bool = true,
                                             name: String,
                                             schedule: Int = 0) -> [Stop]
    {
        let fetchRequest = busDepartureSearchRequest(stop, direction: direction, name: name, schedule: schedule)
        
        // Execute the fetch request, and cast the results to an array of LogItem objects
        return (CoreDataModel.context.executeFetchRequest(fetchRequest, error: nil) as? [Stop])!
    }
    
    class func getTimesFromStopRegardlessOfTime(stop: String,
                                                direction: Bool = true,
                                                name: String,
                                                schedule: Int = 0) -> [String]
    {
        var str = [String]()
        
        let fetchResults = getDeparturesRegardlessOfTime(stop,
                                                         direction: direction,
                                                         name: name,
                                                         schedule: schedule)
        
        var stops = fetchResults
        
        for st in stops
        {
            str.append("\(st.time)")
        }
        
        return str
    }
    
    class func getAvailableDepartures(stop: String,
                                      direction: Bool = true,
                                      name: String,
                                      schedule: Int = 0) -> [String]
    {
        var str = [String]()
        
        let fetchResults = getDepartures(stop, direction: direction, name: name, schedule: schedule)
        
        var stops = fetchResults
        
        for st in stops
        {
            str.append("\(st.time)")
        }
        
        return str
    }
    
    
    
    class func getRecentDepartures(stop: String,
                                   direction: Bool = true,
                                   name: String,
                                   schedule: Int = 0) -> String
    {
        var fetchResults = getDepartures(stop, direction: direction, name: name, schedule: schedule)
        
        var slice: ArraySlice<Stop>?
        
        var str = ""
        
        switch fetchResults.count
        {
            case 0:
                str = "no times left for today"
            case 1:
                slice = fetchResults[0...0]  // to be considered a slice, use '...'
            case 2:
                slice = fetchResults[0...1]
            default:
                slice = fetchResults[0...2]
        }
        
        if let stops = slice
        {
            let currentTime = NSDate.currentMilitaryTime
            
            let formatter = NSNumberFormatter()
            formatter.minimumIntegerDigits = 4
        
            for stop in stops
            {
                var time = stop.time.integerValue
                let timeToGo = NSDate.militaryTimeDifferanceInMinutes(time, time2: currentTime)
                let formattedTime = formatter.stringFromNumber(time)!
                if (timeToGo <= 2)
                {
                    str += "ARRIVING NOW \(time)\n"
                }
                else
                {
                    str += "\(formattedTime): \(NSDate.minutesToHours(timeToGo))\n"
                }
            }
        }
        
        return str
    }
    

}
