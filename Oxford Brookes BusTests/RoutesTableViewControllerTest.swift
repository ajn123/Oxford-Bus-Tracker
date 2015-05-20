//
//  RoutesTableViewControllerTest.swift
//  Oxford Brookes Bus
//
//  Created by AJ Norton on 5/20/15.
//  Copyright (c) 2015 AJ Norton. All rights reserved.
//

import Quick
import UIKit
import Nimble
import Oxford_Brookes_Bus

class RoutesTableViewControllerTest: QuickSpec
{
    override func spec() {
        var vc: RoutesTableViewController!
        
        beforeEach{
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            // 2. Use the storyboard to instantiate the view controller.
            vc = storyboard.instantiateViewControllerWithIdentifier(
                 "RouteTableViewID") as! RoutesTableViewController
            
            describe("Routes are shown")
            {
                expect(vc.routes.count).to(beGreaterThan(0))
            }
        }
    }
}