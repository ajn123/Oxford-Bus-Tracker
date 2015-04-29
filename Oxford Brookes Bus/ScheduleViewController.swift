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
    
    var locations = [Stop]()

    @IBOutlet var pageControl: UIPageControl!
    var refresh = UIRefreshControl()

    @IBOutlet var table: UITableView!
    
    var times = [Int]()
    
    var days = [String: AnyObject]()
    var itemIndex: Int = 0
    var imageName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locations = Stop.getAllBusStops()!
        
        // no separator between the tables
        table.separatorStyle = UITableViewCellSeparatorStyle.None
        
        pageControl.currentPage = itemIndex
        
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
        
        cell.locationTitle.text = "\(stop.stop_name)"
        
        cell.indexRow = indexPath.row
        
        cell.downTime.text = "\(stop.displayNextTimes())"
        
        if(stop.stop_number == 0)
        {
            println("HELLLLOOO")
            cell.downImage.image = UIImage(named: "beginningRoute.png")
        }
        
        if(stop.stop_number == locations.count - 1)
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
        if segue.identifier == "routeToTime"
        {
            var ttvc =  segue.destinationViewController as! TimeViewController
            var cell = sender as! CustomRouteViewCell
            var place = cell.indexRow
            ttvc.times = locations[place].getTimesAsArray()
            
        }
    }
    @IBAction func changeDirectionPressed(sender: AnyObject) {
        locations = locations.reverse()
        table.reloadData()
    }
    
}
