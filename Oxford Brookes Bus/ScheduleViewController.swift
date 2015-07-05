//
//  ScheduleViewController.swift
//  Oxford Brookes Bus
//
//  Created by AJ Norton on 4/22/15.
//  Copyright (c) 2015 AJ Norton. All rights reserved.
//

import UIKit
import CoreData
import iAd

class ScheduleViewController: UIViewController, UITableViewDelegate, ADBannerViewDelegate{
    
    var locations = [String]()
    var refresh = UIRefreshControl()
    var direction: Bool = true
    var name: String = ""

    @IBOutlet var addBanner: ADBannerView!
    @IBOutlet var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.canDisplayBannerAds = true
        self.addBanner?.delegate = self
        self.addBanner?.hidden = true
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
        
        println(NSDate.getWeekday()!)
        cell.downTime.text = BusRoute.getRecentDepartures(stop, direction: direction, name: name, schedule: NSDate.getWeekday()!)
        
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
        //   cell.contentView.backgroundColor = UIColor(red: 66.0, green: 166.0, blue: 245, alpha: 1.0)
        cell.slideImage.image = UIImage(named: "tableSwipeArrow.png")
        
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
    
    
  
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        self.addBanner?.hidden = false
    }
    
  
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
     //   banner.removeFromSuperview()
    }
}
