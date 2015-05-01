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
    static var appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    static var context: NSManagedObjectContext = appDel.managedObjectContext!

    class func massAssign()
    {
        var bus = BusRoute.createBusRoute("U1", destination: "Harcourt Hill", startTime: 1055, endTime: 1152, schedule: 0 )
        Stop.createStop(1055, name: "Wheatley campus", stop_number: 0, latitude: 0.0, longitude: 2.0, parent: bus)
        Stop.createStop(1059, name: "Wheatley church", stop_number: 1, latitude: 0.0, longitude: 2.0, parent: bus)
        Stop.createStop(1104, name: "Sandhills A40", stop_number: 2, latitude: 0.0, longitude: 2.0, parent: bus)
        Stop.createStop(1112, name: "Headington Shops", stop_number: 3, latitude: 0.0, longitude: 2.0, parent: bus)
        Stop.createStop(1120, name: "Brookes Uni stop B5", stop_number: 4, latitude: 0.0, longitude: 2.0, parent: bus)
        Stop.createStop(1128, name: "OXFORD High St Carfax", stop_number: 5, latitude: 0.0, longitude: 2.0, parent: bus)
        Stop.createStop(1130, name: "Speedwell Street", stop_number: 6, latitude: 0.0, longitude: 2.0, parent: bus)
        Stop.createStop(1136, name: "Castle Street", stop_number: 7, latitude: 0.0, longitude: 2.0, parent: bus)
        Stop.createStop(1140, name: "Frideswide Sq R9", stop_number: 8, latitude: 0.0, longitude: 2.0, parent: bus)
        Stop.createStop(1152, name: "Harcourt Hill", stop_number: 9, latitude: 0.0, longitude: 2.0, parent: bus)
        
        bus = BusRoute.createBusRoute("U1X", destination: "Harcourt Hill", startTime: 900, endTime: 945, schedule: 0 )
        Stop.createStop(900, name: "Wheatley campus", stop_number: 0, latitude: 0.0, longitude: 2.0, parent: bus)
        Stop.createStop(912, name: "Headington Shops", stop_number: 1, latitude: 0.0, longitude: 2.0, parent: bus)
        Stop.createStop(918, name: "Brookes Uni stop B5", stop_number: 2, latitude: 0.0, longitude: 2.0, parent: bus)
        Stop.createStop(925, name: "OXFORD High St Carfax", stop_number: 3, latitude: 0.0, longitude: 2.0, parent: bus)
        Stop.createStop(935, name: "Frideswide Sq R9", stop_number: 4, latitude: 0.0, longitude: 2.0, parent: bus)
        Stop.createStop(945, name: "Harcourt Hill", stop_number: 5, latitude: 0.0, longitude: 2.0, parent: bus)
        
        bus = BusRoute.createBusRoute("U1", destination: "Speedwell Street", startTime: 910, endTime: 945, schedule: 0 )
        Stop.createStop(910, name: "Wheatley campus", stop_number: 0, latitude: 0.0, longitude: 2.0, parent: bus)
        Stop.createStop(914, name: "Wheatley church", stop_number: 1, latitude: 0.0, longitude: 2.0, parent: bus)
        Stop.createStop(919, name: "Sandhills A40", stop_number: 2, latitude: 0.0, longitude: 2.0, parent: bus)
        Stop.createStop(927, name: "Headington Shops", stop_number: 3, latitude: 0.0, longitude: 2.0, parent: bus)
        Stop.createStop(935, name: "Brookes Uni stop B5", stop_number: 4, latitude: 0.0, longitude: 2.0, parent: bus)
        Stop.createStop(942, name: "OXFORD High St Carfax", stop_number: 5, latitude: 0.0, longitude: 2.0, parent: bus)
        Stop.createStop(945, name: "Speedwell Street", stop_number: 6, latitude: 0.0, longitude: 2.0, parent: bus)
    }
    
    
    
}




