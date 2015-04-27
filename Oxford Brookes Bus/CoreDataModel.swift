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
    class func addData(){
        var appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        var context: NSManagedObjectContext = appDel.managedObjectContext!
        
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("Stop", inManagedObjectContext: context) as! Stop
        newItem.name = "Daddy"
        
        
        let childEntity = NSEntityDescription.insertNewObjectForEntityForName("Time", inManagedObjectContext: context) as! Time
        
        
        // set time as a parent of stop
        childEntity.parent = newItem
        
        context.save(nil)
        
    }

}
