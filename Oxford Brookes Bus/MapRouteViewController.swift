//
//  MapRouteViewController.swift
//  Oxford Brookes Bus
//
//  Created by AJ Norton on 5/4/15.
//  Copyright (c) 2015 AJ Norton. All rights reserved.
//

import UIKit

class MapRouteViewController: UIViewController, UITableViewDelegate {
    
    var routeLabelName: String = ""
    
    @IBOutlet var routeSegmentControl: UISegmentedControl!
    
    @IBOutlet var routeTable: UITableView!
    var stop: Stop? = nil
    var stops: [Stop] = []
    var busStops: [String] = []
    var stopNames: [String] = []

    @IBOutlet var routeName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        routeTable.separatorStyle = UITableViewCellSeparatorStyle.None
        routeName.text = routeLabelName
    
        self.stopNames = Stop.uniqueBusNamesArray(stop!)
        
        self.stops = (stop!.busParent.stops.allObjects as? [Stop])!
        
        self.stops.sort(){
            first, sec -> Bool in
            return first.stop_number.integerValue < sec.stop_number.integerValue
        }
        
        routeSegmentControl.removeAllSegments()
        
        for (index, s) in enumerate(stopNames)
        {
            routeSegmentControl.insertSegmentWithTitle(s, atIndex: index, animated: true)
        }
        
        if(routeSegmentControl.numberOfSegments > 1)
        {
            routeSegmentControl.selectedSegmentIndex = 0
        }
        else
        {
            println("No routes found")
        }
        
        busStops = BusRoute.busRoutes(self.stopNames[routeSegmentControl.selectedSegmentIndex], direction: stop!.busParent.direction)
        
        // Do any additional setup after loading the view.
    }

    @IBAction func segmentChange(sender: UISegmentedControl) {
        busStops = BusRoute.busRoutes(self.stopNames[sender.selectedSegmentIndex], direction: stop!.busParent.direction)
        
        routeTable.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return busStops.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier("RouteCell") as! UITableViewCell
        
        var singleStop = self.busStops[indexPath.row]
        
        if (stop!.stop_name == singleStop)
        {
            self.routeTable.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.None)
        }
        else
        {
            self.routeTable.deselectRowAtIndexPath(indexPath, animated: false)
        }
        
        cell.textLabel!.text = singleStop
        
        if(indexPath.row == self.tableView(tableView, numberOfRowsInSection: 0) - 1)
        {
            cell.imageView!.image = UIImage(named: "ArrowPathEnd.png")
            
        }
        else
        {
            cell.imageView!.image = UIImage(named: "ArrowPathMiddle.png")
            
        }
        
        
       
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
