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
    class func addData(name: String){
        var appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var context: NSManagedObjectContext = appDel.managedObjectContext!
        
        let stop = NSEntityDescription.insertNewObjectForEntityForName("Stop", inManagedObjectContext: context) as! Stop
        stop.name = name
        
        let time = NSEntityDescription.insertNewObjectForEntityForName("Time", inManagedObjectContext: context) as! Time
        time.time = 2300 % 2000
        time.direction = 1 // 0 for end, 1 for down, 2 for up
        time.day = 0       // 0 for M-F, 1 for Saturday, 2 for Sunday
        time.bus_type = "U1"
        
        // set time as a parent of stop
        time.parent = stop
        
       // context.save(nil)
    }

}
