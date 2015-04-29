//
//  Time.swift
//  Oxford Brookes Bus
//
//  Created by AJ Norton on 4/27/15.
//  Copyright (c) 2015 AJ Norton. All rights reserved.
//

import Foundation
import CoreData

class Time: NSManagedObject {

    @NSManaged var time: NSNumber
    @NSManaged var bus_type: String
    @NSManaged var day: NSNumber
    @NSManaged var direction: NSNumber
    @NSManaged var parent: Stop

    
  

}

