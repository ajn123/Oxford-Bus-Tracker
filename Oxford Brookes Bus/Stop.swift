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
        
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("Stop", inManagedObjectContext: CoreDataModel.context) as! Stop
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
    
    
}
