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
        // Do any additional setup after loading the view.
    }
    
    func refreshing()
    {
        // TODO: refresh times
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
        
        cell.indexRow = indexPath.row
      
        cell.downTime.text = BusRoute.getRecentDepartures(stop, direction: direction, name: name)
        
        
        if(indexPath.row == 0)
        {
            cell.downImage.image = UIImage(named: "beginningRoute.png")
        }
        
        if(indexPath.row == locations.count - 1)
        {
            cell.downImage.image = UIImage(named: "endRoute.png")
        }
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        //  performSegueWithIdentifier("routeToTime", sender: indexPath.row)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //TODO
        let navVC = segue.destinationViewController as! UINavigationController
        
        let tableVC = navVC.topViewController as! TimeViewController
        
        var cell = sender as! CustomRouteViewCell
        
        
        tableVC.times = BusRoute.getTimesFromStop(cell.locationTitle.text!, direction: direction, name: name)
    }
    
    @IBAction func changeDirectionPressed(sender: AnyObject) {
        direction = !direction
        locations = BusRoute.busRoutes(name, direction: direction)
        table.reloadData()
    }
    
}
