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
    
    
    lazy var emptyTableLabel: UILabel = {
        var label = UILabel()
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.textAlignment = NSTextAlignment.Center
        label.numberOfLines = 4
        label.text = "This bus is not currently running at this time, try another schedule."
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = name
        // no separator between the tables
        setUpConstraints()
        
    }
    
    func setUpConstraints()
    {
        refresh.addTarget(self, action: Selector("refreshing"), forControlEvents: UIControlEvents.ValueChanged)
        
        
        self.view.addSubview(table)
        self.view.addSubview(addBanner)
        self.view.addSubview(button)
        self.view.addSubview(emptyTableLabel)
        table.addSubview(refresh)
        
        self.edgesForExtendedLayout = UIRectEdge.Bottom & UIRectEdge.Top
        var viewDicts = ["table": table, "addBanner": addBanner, "button": button, "superview": view, "label": emptyTableLabel]
        
        var Vertical_Layout_1 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-15-[button(45)]-[table][addBanner]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewDicts)
        var Horizontal_Layout_1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[button(45)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewDicts)
        var Horizontal_Layout_2 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[table]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewDicts)
        var Horizontal_Layout_3 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[addBanner]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewDicts)
        
        self.view.addConstraints(Vertical_Layout_1)
        self.view.addConstraints(Horizontal_Layout_1)
        self.view.addConstraints(Horizontal_Layout_2)
        self.view.addConstraints(Horizontal_Layout_3)
        
        var centerConstraint = NSLayoutConstraint.constraintsWithVisualFormat("V:[superview]-(<=1)-[label(150)]", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: viewDicts)
        var centerConstraint2 = NSLayoutConstraint.constraintsWithVisualFormat("H:[superview]-(<=1)-[label(150)]", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: viewDicts)
        
        self.view.addConstraints(centerConstraint)
        self.view.addConstraints(centerConstraint2)
        
        
        showLabelOrTable()
        
    }
    
    
    /**
        Hides table if nothing is showing
    */
    func showLabelOrTable()
    {
        if(locations.count == 0)
        {
            table.hidden = true
            emptyTableLabel.hidden = false
        }
        else
        {
            table.hidden = false
            emptyTableLabel.hidden = true
        }
    }
    
    
    func refreshing()
    {
        table.reloadData() 
        refresh.endRefreshing()
        showLabelOrTable()
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
    
    
    
  
    func changeDirectionPressed(sender: AnyObject) {
        direction = !direction
        locations = BusRoute.busRoutes(name, direction: direction)
        table.reloadData()
        showLabelOrTable()
    }

    
    
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        
        var rowActions = [AnyObject]()
        
        let colorDict: [Int:UIColor] = [
            5:  UIColor(red:0.29, green:0.91, blue:0.56, alpha:1.0),
            10: UIColor(red:0.29, green:0.91, blue:0.85, alpha:1.0),
            15: UIColor(red:0.29, green:0.53, blue:0.91, alpha:1.0),
            20: UIColor.blueColor()
        ]
        
        for elem in [5,10,15,20]
        {
            
            var rowAction: UITableViewRowAction = UITableViewRowAction(style: .Normal, title: "\(elem)")
            {  (_, _) in
                    
                    var refreshAlert = Alarm.getReminderView(elem, view: self.parentViewController!.view)
                    
                    self.parentViewController?.presentViewController(refreshAlert, animated: true, completion: nil)
            }
            rowAction.backgroundColor = colorDict[elem]
            
            rowActions.append(rowAction)

        }
        return rowActions
    }
    
    //  Need this for swiping feature
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
  

    
  
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
     //   banner.removeFromSuperview()
    }
}
