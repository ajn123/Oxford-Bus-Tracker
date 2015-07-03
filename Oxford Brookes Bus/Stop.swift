//
//  Stop.swift
//  Oxford Brookes Bus
//
//  Created by AJ Norton on 5/1/15.
//  Copyright (c) 2015 AJ Norton. All rights reserved.
//

import UIKit
import CoreData


class Stop: NSManagedObject {

    @NSManaged var stop_name: String
    @NSManaged var stop_number: NSNumber
    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber
    @NSManaged var time: NSNumber
    @NSManaged var busParent: BusRoute
    
    class func createStop(time: Int,
                          name: String,
                          stop_number: Int = 0,
                          latitude: Double,
                          longitude: Double,
                          parent: BusRoute) -> Stop {
        
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("Stop",
                                                                          inManagedObjectContext: CoreDataModel.context)
                                                                          as! Stop
        newItem.stop_name = name
        newItem.stop_number = stop_number
        newItem.time = time
        newItem.longitude = longitude
        newItem.latitude = latitude
        newItem.busParent = parent
        
        return newItem
    }
    
    class func getAllBusStops() -> [Stop]?
    {
        let fetchRequest = NSFetchRequest(entityName: "Stop")
        
        var sort = NSSortDescriptor(key: "stop_number", ascending: true) // sort by bus stop
        
        fetchRequest.sortDescriptors = [sort]
        
        // Execute the fetch request, and cast the results to an array of LogItem objects
        if let fetchResults = CoreDataModel.context.executeFetchRequest(
                                                        fetchRequest,
                                                        error: nil)
                                                        as? [Stop] {
            return fetchResults
        }
        
      
        
        return nil
    }
    
    class func getDifferantStops() -> [Stop]?
    {
        return getAllBusStops()!.withoutDuplicates { $0.stop_name } 
    }
    
    class func allBusRoutesForStop(stop: Stop, direction: Bool? = nil) -> [BusRoute]?
    {
        let fetchRequest = NSFetchRequest(entityName: "Stop")
        
        let predicate1 = NSPredicate(format: "stop_name == %@", stop.stop_name)

        let predicate2 = NSPredicate(format: "busParent.schedule == %ld", NSDate.getWeekday()!)
        
        if let d: Bool = direction
        {
            let predicate3 = NSPredicate(format: "busParent.direction == %@", stop.busParent.direction)
            
            
            fetchRequest.predicate = NSCompoundPredicate.andPredicateWithSubpredicates([predicate1,predicate2, predicate3])
        }
        else
        {
            
            fetchRequest.predicate = NSCompoundPredicate.andPredicateWithSubpredicates([predicate1,predicate2])
        }
        
        // Execute the fetch request, and cast the results to an array of LogItem objects
        if let fetchResults = CoreDataModel.context.executeFetchRequest(fetchRequest,
                                                                        error: nil)
                                                                        as? [Stop] {
            var busRoutes = fetchResults.map(){ $0.busParent }
            
            return busRoutes
        }
        
        return nil
    }
    
    
    class func uniqueBusNamesArray(stop: Stop) -> [String]
    {
        return Stop.allBusRoutesForStop(stop)!.map()
            {
                $0.name
            }.withoutDuplicates(){ $0 }
    }
    
    struct Bus: Printable {
       
        var name = ""
        var direction: Bool = true
        var destination = ""
        var vacation: Bool = true
        
        var description: String
        {
            return "name: \(name) direction: \(direction) \(destination) \(vacation) \n "
        }
        
    }
    
    class func uniqueBusDirection(stop: Stop) -> Bool
    {
        let fetchRequest = NSFetchRequest(entityName: "Stop")
        
        let predicate1 = NSPredicate(format: "stop_name == %@", stop.stop_name)
        
        fetchRequest.predicate = NSCompoundPredicate.andPredicateWithSubpredicates([predicate1])
        
        // Execute the fetch request, and cast the results to an array of LogItem objects
        if let fetchResults = CoreDataModel.context.executeFetchRequest(fetchRequest,
            error: nil)
            as? [Stop]
        {
            var busRoutes: [Bus] = fetchResults.map()
            { return Bus(name: $0.busParent.name, direction: $0.busParent.direction, destination: $0.busParent.destination,
                         vacation: $0.busParent.vacation)
            }
            
            for var i = 0; i < busRoutes.count; i++
            {
                for var j = 0; j < busRoutes.count; j++
                {
                    if(i != j &&
                       busRoutes[i].name == busRoutes[j].name &&
                       busRoutes[i].direction != busRoutes[j].direction)
                    {
                        return false
                    }
                }
            }
                
            
        }
        
        return true 
    }
    
    
    class func allBusUniqueBusStopNames(stop: Stop) -> String
    {
        return uniqueBusNamesArray(stop).reduce("")
            {
                (all: String, elem: String) in
                "\(all) \(elem)"
            }
    }
    
}
    
    

