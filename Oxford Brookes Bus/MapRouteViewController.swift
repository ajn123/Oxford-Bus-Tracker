//
//  MapRouteViewController.swift
//  Oxford Brookes Bus
//
//  Created by AJ Norton on 5/4/15.
//  Copyright (c) 2015 AJ Norton. All rights reserved.
//

import UIKit
import iAd

class MapRouteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ADBannerViewDelegate {
    
    
    
    
    lazy var routeName: UILabel! = {
        var label = UILabel()
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        return label
    }()
    
    lazy var routeSegmentControl: UISegmentedControl! =
    {
        var segmentControl = UISegmentedControl()
        segmentControl.setTranslatesAutoresizingMaskIntoConstraints(false)
        segmentControl.addTarget(self, action: "segmentChange:", forControlEvents: UIControlEvents.ValueChanged)
        return segmentControl
    }()
    
    lazy var routeChangeButton: UIButton! =
    {
        var button = UIButton()
        button.addTarget(self, action: "changeDirectionTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        button.setTranslatesAutoresizingMaskIntoConstraints(false)
        button.backgroundColor = UIColor(patternImage: UIImage(named: "changeDirection.png")!)
        return button
    }()
    
    lazy var routeTable: UITableView! = {
       var table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.setTranslatesAutoresizingMaskIntoConstraints(false)
        table.registerClass(UITableViewCell.self , forCellReuseIdentifier: "routeCell")
        return table
    }()
    

    lazy var adBanner: ADBannerView = {
        var ad = ADBannerView()
        ad.delegate = self
        ad.setTranslatesAutoresizingMaskIntoConstraints(false)
        return ad
    }()
    
    
    
    lazy var emptyTableLabel: UILabel = {
        var label = UILabel()
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.textAlignment = NSTextAlignment.Center
        label.numberOfLines = 4
        label.text = "This bus is not currently running at this time, try another schedule."
        return label
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
        setUpConstraints()
    }
    
  
    func setUpConstraints()
    {
        self.edgesForExtendedLayout = UIRectEdge.Bottom & UIRectEdge.Top
        self.view.addSubview(adBanner)
        self.view.addSubview(routeTable)
        self.view.addSubview(routeChangeButton)
        self.view.addSubview(routeName)
        self.view.addSubview(routeSegmentControl)
        self.view.addSubview(emptyTableLabel)
        var viewDict = ["adBanner": adBanner, "routeTable": routeTable, "routeChangeButton": routeChangeButton, "routeSegmentControl": routeSegmentControl, "routeName": routeName,
            "superview": view, "label": emptyTableLabel]
        var verticalConstraint = NSLayoutConstraint.constraintsWithVisualFormat("V:|-20-[routeName]-[routeSegmentControl]-[routeTable][adBanner]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewDict)
        var verticalConstraint2 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-5-[routeChangeButton(45)]-5-[routeSegmentControl]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewDict)
        var horizontalConstraint = NSLayoutConstraint.constraintsWithVisualFormat("H:|[adBanner]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewDict)
        var horizontalConstraint2 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-5-[routeChangeButton(45)]-5-[routeName]|", options: NSLayoutFormatOptions(0) , metrics: nil, views: viewDict)
        var horizontalConstraint3 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[routeTable]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewDict)
        var horizontalConstraint4 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-5-[routeSegmentControl]-5-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewDict)
        
        self.view.addConstraints(verticalConstraint)
        self.view.addConstraints(verticalConstraint2)
        self.view.addConstraints(horizontalConstraint)
        self.view.addConstraints(horizontalConstraint2)
        self.view.addConstraints(horizontalConstraint3)
        self.view.addConstraints(horizontalConstraint4)
        
        var centerConstraint = NSLayoutConstraint.constraintsWithVisualFormat("V:[superview]-(<=1)-[label(150)]", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: viewDict)
        var centerConstraint2 = NSLayoutConstraint.constraintsWithVisualFormat("H:[superview]-(<=1)-[label(150)]", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: viewDict)
        
        self.view.addConstraints(centerConstraint)
        self.view.addConstraints(centerConstraint2)
        
        
        showLabelOrTable()
        
    }
    
    func showLabelOrTable()
    {
        if(busStops.count == 0)
        {
            routeTable.hidden = true
            emptyTableLabel.hidden = false
        }
        else
        {
            routeTable.hidden = false
            emptyTableLabel.hidden = true
        }
    }
    

    func segmentChange(sender: UISegmentedControl) {
        
        self.routeDirection = BusRoute.whichDirection(self.stopNames[routeSegmentControl.selectedSegmentIndex],
                                                      busStop: routeLabelName)
        
        busStops = BusRoute.busRoutes(self.stopNames[sender.selectedSegmentIndex],
                                      direction: self.routeDirection!)
        
        routeTable.reloadData()
        showLabelOrTable()
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
        var cell = tableView.dequeueReusableCellWithIdentifier("routeCell") as! UITableViewCell
        
        var singleStop = self.busStops[indexPath.row]
        
        if (stop!.stop_name == singleStop)
        {
            self.routeTable.selectRowAtIndexPath(indexPath,
                                                 animated: false,
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

    func changeDirectionTapped(sender: UIButton) {
        self.routeDirection = !routeDirection!
        busStops = BusRoute.busRoutes(self.stopNames[routeSegmentControl.selectedSegmentIndex],
                                      direction: self.routeDirection!)
        routeTable.reloadData()
        
        showLabelOrTable()
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
