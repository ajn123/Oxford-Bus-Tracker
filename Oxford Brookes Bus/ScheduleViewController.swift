//
//  ScheduleViewController.swift
//  Oxford Brookes Bus
//
//  Created by AJ Norton on 4/22/15.
//  Copyright (c) 2015 AJ Norton. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController, UITableViewDelegate {
    
    var locations = [String]()
    var overall = Dictionary<String, AnyObject>()
    
    @IBOutlet var pageControl: UIPageControl!
    var refresh = UIRefreshControl()

    @IBOutlet var table: UITableView!
    
    var times = [Int]()
    
    var days = [String: AnyObject]()
    var itemIndex: Int = 0
    var imageName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageControl.currentPage = itemIndex
        
        if let path = NSBundle.mainBundle().pathForResource("busSchedule", ofType: "plist")
        {
            if let dict = NSDictionary(contentsOfFile: path) as? Dictionary<String, AnyObject>
            {
                locations = dict.keys.array
                overall = dict
            }
        }
        
        refresh.addTarget(self, action: Selector("refreshing"), forControlEvents: UIControlEvents.ValueChanged)
        
        table.addSubview(refresh)

        // Do any additional setup after loading the view.
    }
    
    func refreshing()
    {
        locations = locations.reverse()
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
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! CustomRouteViewCell
        
        cell.locationTitle.text = "\(locations[indexPath.row])"
        cell.indexRow = indexPath.row
        
        if(itemIndex == 1)
        {
            // flip image if the second index is happening
            cell.downImage.transform = CGAffineTransformMakeRotation((180.0 * CGFloat(M_PI)) / 180.0)
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
            var dicts = overall[locations[place]] as! Dictionary<String,AnyObject>
            var arr = dicts["Weekday"] as! [Int]
            
            ttvc.days = dicts
            ttvc.times = arr.reverse()
        }
    }
    
}
