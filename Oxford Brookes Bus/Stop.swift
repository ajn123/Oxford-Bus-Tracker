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
    
    class func createStop(time: Int, name: String, stop_number: Int = 0, latitude: Double = 0, longitude: Double = 0, parent: BusRoute) -> Stop {
        
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("Stop",
                                                                          inManagedObjectContext: CoreDataModel.context)as! Stop
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
        if let fetchResults = CoreDataModel.context.executeFetchRequest(fetchRequest, error: nil) as? [Stop] {
            return fetchResults
        }
        
        return nil
    }
    
    class func getDifferantStops() -> [Stop]?
    {
        return getAllBusStops()!.withoutDuplicates { $0.stop_name } 
    }
    
    class func allBusRoutesForStop(stop: Stop) -> [BusRoute]?
    {
        let fetchRequest = NSFetchRequest(entityName: "Stop")
        
        let predicate1 = NSPredicate(format: "stop_name == %@", stop.stop_name)
        
        fetchRequest.predicate = predicate1
        
        // Execute the fetch request, and cast the results to an array of LogItem objects
        if let fetchResults = CoreDataModel.context.executeFetchRequest(fetchRequest, error: nil) as? [Stop] {
            var busRoutes = fetchResults.map()
            {
                $0.busParent
            }
            
            return busRoutes
        }
        
        return nil
    }
    
    
    class func allBusUniqueBusStopNames(stop: Stop) -> String
    {
        return Stop.allBusRoutesForStop(stop)!.map()
            {
                $0.name
            }.withoutDuplicates(){ $0 }.reduce("")
            {
                (a, b) -> String in
                    return "\(a) \(b)"
            }
    }
    
}
    
    

