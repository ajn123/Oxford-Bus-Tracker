//
//  ScheduleViewController.swift
//  Oxford Brookes Bus
//
//  Created by AJ Norton on 4/22/15.
//  Copyright (c) 2015 AJ Norton. All rights reserved.
//

import UIKit
import CoreData

class ScheduleViewController: UIViewController, UITableViewDelegate {
    
    var locations = [String]()

    var refresh = UIRefreshControl()
    
    var direction: Bool = true
    
    var name: String = ""

    @IBOutlet var table: UITableView!
    
    override func viewDidLoad() {
        
    
        super.viewDidLoad()
        // no separator between the tables
        table.separatorStyle = UITableViewCellSeparatorStyle.None
        
        refresh.addTarget(self, action: Selector("refreshing"), forControlEvents: UIControlEvents.ValueChanged)
        table.addSubview(refresh)
    }
    
    func refreshing()
    {
        table.reloadData()
        refresh.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return locations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var stop = locations[indexPath.row]
        
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! CustomRouteViewCell
        
        cell.locationTitle.text = "\(stop)"
        
        cell.downTime.text = BusRoute.getRecentDepartures(stop, direction: direction, name: name, schedule: NSDate.getWeekday()! )
        
        switch indexPath.row {
            case 0:
                cell.downImage.image = UIImage(named: "ArrowPathBegin.png")
            case self.tableView(tableView, numberOfRowsInSection: 0) - 1:
                cell.downImage.image = UIImage(named: "ArrowPathEnd.png")
            default:
                cell.downImage.image = UIImage(named: "ArrowPathMiddle")
            
        }

        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //TODO
        let navVC = segue.destinationViewController as! UINavigationController
        
        let tableVC = navVC.topViewController as! TimeViewController
        
        var cell = sender as! CustomRouteViewCell
        
        // removes selection view so reminder tab is still shown
        cell.selectedBackgroundView.removeFromSuperview()
        cell.panView.backgroundColor = UIColor(patternImage: UIImage(named: "tableSwipe.png")!)
        
        tableVC.times = BusRoute.getTimesFromStopRegardlessOfTime(cell.locationTitle.text!,
                                                                  direction: direction,
                                                                  name: name,
                                                                  schedule: NSDate.getWeekday()!)
        tableVC.stop = cell.locationTitle.text!
        tableVC.direction = direction
        tableVC.name = name
    }
    
    @IBAction func changeDirectionPressed(sender: AnyObject) {
        direction = !direction
        locations = BusRoute.busRoutes(name, direction: direction)
        table.reloadData()
    }
    
}
