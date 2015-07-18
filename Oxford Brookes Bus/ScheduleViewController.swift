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

class ScheduleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ADBannerViewDelegate{
    
    var locations = [String]()
    var refresh = UIRefreshControl()
    var direction: Bool = true
    var name: String = ""
    
    
    lazy var table: UITableView = {
        var tab = UITableView()
        tab.registerNib(UINib(nibName: "CustomRouteViweCell", bundle: nil), forCellReuseIdentifier: "Cell")
        tab.delegate = self
        tab.dataSource = self
        tab.rowHeight = 146.0
        tab.separatorStyle = UITableViewCellSeparatorStyle.None
        tab.setTranslatesAutoresizingMaskIntoConstraints(false)
        return tab
    }()
    
    lazy var addBanner: ADBannerView = {
        var ad = ADBannerView()
        ad.setTranslatesAutoresizingMaskIntoConstraints(false)
        ad.delegate = self
        return ad
    }()

    
    lazy var button: UIButton = {
       var button = UIButton()
        button.addTarget(self, action: "changeDirectionPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        button.backgroundColor = UIColor(patternImage: UIImage(named: "changeDirection.png")!)
        button.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // no separator between the tables
        setUpConstraints()
        
    }
    
    func setUpConstraints()
    {
        self.view.addSubview(table)
        self.view.addSubview(addBanner)
        self.view.addSubview(button)
        refresh.addTarget(self, action: Selector("refreshing"), forControlEvents: UIControlEvents.ValueChanged)
        table.addSubview(refresh)
        
        self.edgesForExtendedLayout = UIRectEdge.Bottom & UIRectEdge.Top
        var viewDicts = ["table": table, "addBanner": addBanner, "button": button]
        
        var Vertical_Layout_1 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-15-[button(45)]-[table][addBanner]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewDicts)
        var Horizontal_Layout_1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[button(45)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewDicts)
        var Horizontal_Layout_2 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[table]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewDicts)
        var Horizontal_Layout_3 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[addBanner]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewDicts)
        
        self.view.addConstraints(Vertical_Layout_1)
        self.view.addConstraints(Horizontal_Layout_1)
        self.view.addConstraints(Horizontal_Layout_2)
        self.view.addConstraints(Horizontal_Layout_3)
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
        
        cell.downTime.text = BusRoute.getRecentDepartures(stop, direction: direction, name: name, schedule: NSDate.getWeekday()!)
        
        switch indexPath.row {
            case 0:
                cell.downImage.image = UIImage(named: "ArrowPathBegin.png")
            case self.tableView(tableView, numberOfRowsInSection: 0) - 1:
                cell.downImage.image = UIImage(named: "ArrowPathEnd.png")
            default:
                cell.downImage.image = UIImage(named: "ArrowPathMiddle.png")
        }

          return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {

        let tableVC = TimeViewController()
        
        var cell = tableView.cellForRowAtIndexPath(indexPath) as! CustomRouteViewCell
        
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
        
        self.navigationController?.pushViewController(tableVC, animated: true)
        
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
    
    
  

    
  
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
     //   banner.removeFromSuperview()
    }
}
