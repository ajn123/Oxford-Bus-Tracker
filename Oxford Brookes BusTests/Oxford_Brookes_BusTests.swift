//
//  Oxford_Brookes_BusTests.swift
//  Oxford Brookes BusTests
//
//  Created by AJ Norton on 4/20/15.
//  Copyright (c) 2015 AJ Norton. All rights reserved.
//

import UIKit
import Quick
import Foundation
import Nimble
import XCTest
import Oxford_Brookes_Bus
import CoreData

class Oxford_Brookes_BusTests: QuickSpec {
    override func spec() {
     
      func setUpInMemoryManagedObjectContext() -> NSManagedObjectContext {
        let managedObjectModel = NSManagedObjectModel.mergedModelFromBundles([NSBundle.mainBundle()])!
        
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        persistentStoreCoordinator.addPersistentStoreWithType(NSInMemoryStoreType, configuration: nil, URL: nil, options: nil, error: nil)
        
        let managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        return managedObjectContext
      }
      
      describe("NSDate")
      {
          it("should load something")
          {
              setUpInMemoryManagedObjectContext()
              CoreDataModel.massAssign()
            
              expect(BusRoute.allBusRoutes().count).to(equal(7))
              expect(BusRoute.getRecentDepartures("Wheatley campus", direction: true, name: "U1", schedule: 0, time: 1200)).to(
                equal("1235: 35 minutes\n1235: 35 minutes\n1310: 1 hour, 10 minutes\n"))
            
            expect(BusRoute.getRecentDepartures("Wheatley campus", direction: false, name: "U1", schedule: 0, time: 1200)).to(
              equal("1218: 18 minutes\n1218: 18 minutes\n1248: 48 minutes\n"))
          }
      }
  }
}
