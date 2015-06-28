//
//  RoutesTableViewController.swift
//  Oxford Brookes Bus
//
//  Created by AJ Norton on 4/29/15.
//  Copyright (c) 2015 AJ Norton. All rights reserved.
//

import UIKit

public class RoutesTableViewController: UITableViewController {
    
    public var routes: [String] = []

    override public func viewDidLoad() {
        super.viewDidLoad()

        routes = BusRoute.allBusRoutes()
        self.routes.sort()
        {
            (a, b) -> Bool in
            
            var str =  a.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
            var abc = "".join(str)
            var comp1 = abc.toInt()!
            
            var str2 =  b.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
            var abc2 = "".join(str2)
            var comp2 = abc2.toInt()!
            
            if(comp1 < comp2)
            {
                return true
            }
            else if(comp1 > comp2)
            {
                return false
            }
            
            if(!a.hasSuffix("X") && !a.hasPrefix("N"))
            {
                return true
            }
            
            if(a.hasSuffix("X") && b.hasPrefix("N"))
            {
                return true
            }
            
            return a < b
        }

    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    public override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return routes.count
    }

    
    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        cell.textLabel?.text = routes[indexPath.row]

        return cell
    }
    

   
   
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let dVC = segue.destinationViewController as! UINavigationController
        var seg = dVC.topViewController as! ScheduleViewController
        
        let cell = sender as! UITableViewCell
        let routeString = cell.textLabel!.text!
        seg.locations = BusRoute.busRoutes(routeString)
        seg.name = routeString
    }
    
    
    
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */


}
