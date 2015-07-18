//
//  MapRouteViewController.swift
//  Oxford Brookes Bus
//
//  Created by AJ Norton on 5/4/15.
//  Copyright (c) 2015 AJ Norton. All rights reserved.
//

import UIKit
import iAd

class MapRouteViewController: UIViewController, UITableViewDelegate, ADBannerViewDelegate {
    
    
    
    
    @IBOutlet var routeName: UILabel!
    @IBOutlet var routeSegmentControl: UISegmentedControl!
    @IBOutlet var routeChangeButton: UIButton!
    @IBOutlet var routeTable: UITableView!

    lazy var adBanner: ADBannerView = {
        var ad = ADBannerView()
        ad.delegate = self
        ad.setTranslatesAutoresizingMaskIntoConstraints(false)
        return ad
    }()
    
    var routeLabelName: String = ""
    var stop: Stop? = nil
    var stops: [Stop] = []
    var busStops: [String] = []
    var stopNames: [String] = []
    var routeDirection: Bool? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        routeTable.separatorStyle = UITableViewCellSeparatorStyle.None
        routeName.text = routeLabelName
        
        if(Stop.uniqueBusDirection(stop!))
        {
            routeChangeButton.removeFromSuperview()
        }
        
        self.setUpTable()
        
        if(routeSegmentControl.numberOfSegments > 0)
        {
            self.routeDirection = BusRoute.whichDirection(self.stopNames[routeSegmentControl.selectedSegmentIndex],
                busStop: routeLabelName)
            
            busStops = BusRoute.busRoutes(self.stopNames[routeSegmentControl.selectedSegmentIndex],
                direction: self.routeDirection!)
            
            routeChangeButton.removeFromSuperview()
        }
        
        // Do any additional setup after loading the view.
    }
    
    func setUpConstraints()
    {
        self.edgesForExtendedLayout = UIRectEdge.Bottom & UIRectEdge.Top
        self.view.addSubview(adBanner)
        var viewDict = ["adBanner": adBanner]
        var verticalConstraint = NSLayoutConstraint.constraintsWithVisualFormat("V:[adBanner]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewDict)
        var horizontalConstraint = NSLayoutConstraint.constraintsWithVisualFormat("H:|[adBanner]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewDict)
        
        self.view.addConstraints(verticalConstraint)
        self.view.addConstraints(horizontalConstraint)
    }

    @IBAction func segmentChange(sender: UISegmentedControl) {
        
        self.routeDirection = BusRoute.whichDirection(self.stopNames[routeSegmentControl.selectedSegmentIndex],
                                                      busStop: routeLabelName)
        
        busStops = BusRoute.busRoutes(self.stopNames[sender.selectedSegmentIndex],
                                      direction: self.routeDirection!)
        
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
            self.routeTable.selectRowAtIndexPath(indexPath, animated: false,
                                                 scrollPosition: UITableViewScrollPosition.None)
        }
        else
        {
            self.routeTable.deselectRowAtIndexPath(indexPath, animated: false)
        }
        
        cell.textLabel!.text = singleStop
        
        switch indexPath.row
        {
            case 0:
                cell.imageView!.image = UIImage(named: "ArrowPathBegin.png")
            case self.tableView(tableView, numberOfRowsInSection: 0) - 1:
                cell.imageView!.image = UIImage(named: "ArrowPathEnd.png")
            default:
                cell.imageView!.image = UIImage(named: "ArrowPathMiddle.png")
        }
        
        return cell
    }

    @IBAction func changeDirectionTapped(sender: UIButton) {
        self.routeDirection = !routeDirection!
        busStops = BusRoute.busRoutes(self.stopNames[routeSegmentControl.selectedSegmentIndex],
                                      direction: self.routeDirection!)
        routeTable.reloadData()
    }
    
    
    func setUpTable()
    {
        self.stopNames = Stop.uniqueBusNamesArray(stop!)
        self.stops = (stop!.busParent.stops.allObjects as? [Stop])!
        self.stops.sort()
        {
            first, sec -> Bool in
            return first.stop_number.integerValue < sec.stop_number.integerValue
        }
        routeSegmentControl.removeAllSegments()
        
        stopNames = StringManipulation.sortBusses(self.stopNames)
        
        for (index, s) in enumerate(self.stopNames)
        {
            routeSegmentControl.insertSegmentWithTitle(s, atIndex: index, animated: true)
        }
        
        if(routeSegmentControl.numberOfSegments >= 1)
        {
            routeSegmentControl.selectedSegmentIndex = 0
        }
        else
        {
           // println("No routes found")
        }
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
