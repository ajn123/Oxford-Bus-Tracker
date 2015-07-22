//
//  TimeViewController.swift
//  Oxford Brookes Bus
//
//  Created by AJ Norton on 4/21/15.
//  Copyright (c) 2015 AJ Norton. All rights reserved.
//

import UIKit
import EventKit

class TimeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    lazy var timeTable: UITableView! = {
       var t = UITableView()
        t.delegate = self
        t.dataSource = self
        t.rowHeight = 55.0
        t.setTranslatesAutoresizingMaskIntoConstraints(false)
        t.registerClass(UITableViewCell.self, forCellReuseIdentifier: "timeCell")
        return t
    }()
    
    lazy var dayOfWeek: UISegmentedControl! = {
        var items = ["M-F", "Sat", "Sun"]
        var seg = UISegmentedControl(items: items)
        seg.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        seg.addTarget(self, action: "segmentChange:", forControlEvents: UIControlEvents.ValueChanged)
        seg.selectedSegmentIndex = NSDate.getWeekday()!
        return seg
    }()
    
    lazy var availableTimes: UISegmentedControl! = {
        var items = ["all", "available"]
        var a = UISegmentedControl(items: items)
        a.setTranslatesAutoresizingMaskIntoConstraints(false)
        a.addTarget(self, action: "availbilityChanged:", forControlEvents: UIControlEvents.ValueChanged)
        
        a.selectedSegmentIndex = 0
        return a
    }()
    
    
    var refresh = UIRefreshControl()
    var times = [String]()
    var stop: String = ""
    var direction: Bool = true
    var name: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = stop 
        addConstraints()
       
        refresh.addTarget(self, action: Selector("refreshing"), forControlEvents: UIControlEvents.ValueChanged)
        timeTable.addSubview(refresh)
        
        dayOfWeek.selectedSegmentIndex = NSDate.getWeekday()!
        
    }
    
    func addConstraints()
    {
        self.edgesForExtendedLayout = UIRectEdge.Top & UIRectEdge.Bottom
        self.view.addSubview(timeTable)
        self.view.addSubview(dayOfWeek)
        self.view.addSubview(availableTimes)
        var viewsDict = ["timeTable": timeTable, "dayOfWeek": dayOfWeek, "availableTimes": availableTimes]
        
        var verticalLayout = NSLayoutConstraint.constraintsWithVisualFormat("V:|[timeTable]-[dayOfWeek]-10-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict)
        var verticalLayout2 = NSLayoutConstraint.constraintsWithVisualFormat("V:|[timeTable]-[availableTimes]-10-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict)
        
        var horizontalLayout = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[dayOfWeek(==availableTimes)]-[availableTimes(==dayOfWeek)]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict)
        var horizontalLayout2 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[timeTable]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDict)
        
        
        self.view.addConstraints(verticalLayout)
        self.view.addConstraints(verticalLayout2)
        self.view.addConstraints(horizontalLayout)
        self.view.addConstraints(horizontalLayout2)
    }
    
    func refreshing()
    {
        timeTable.reloadData()
        refresh.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func availbilityChanged(sender: UISegmentedControl) {
        
        if(sender.selectedSegmentIndex == 0)
        {
            times = BusRoute.getTimesFromStopRegardlessOfTime(stop, direction: direction, name: name, schedule: dayOfWeek.selectedSegmentIndex)
        }
        else
        {
            times = BusRoute.getAvailableDepartures(stop, direction: direction, name: name, schedule: dayOfWeek.selectedSegmentIndex)
        }
        timeTable.reloadData()
        
    }
    func segmentChange(sender: AnyObject) {
        times = BusRoute.getTimesFromStopRegardlessOfTime(stop, direction: direction, name: name, schedule: dayOfWeek.selectedSegmentIndex)
        
        timeTable.reloadData()
    }
    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return times.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "timeCell")

        var militaryTime = NSDate.currentMilitaryTime
        
        var time = NSDate.militaryTimeDifferanceInMinutes(times[indexPath.row].toInt()!, time2: militaryTime)
       
        if(militaryTime < times[indexPath.row].toInt())
        {
            // green
            cell.backgroundColor = UIColor(red: 0.00, green: 1.00, blue: 0.00, alpha: 1.00)
            cell.detailTextLabel?.text = "Incoming in \(NSDate.minutesToHours(time))"
        }
        else
        {
            // red
            cell.backgroundColor = UIColor(red: 0.80, green: 0.00, blue: 0.00, alpha: 1.00)
            cell.detailTextLabel?.text = "Missed"
        }
       
        cell.textLabel?.text = times[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        var time = times[indexPath.row].toInt()!
        
        var currentTime = NSDate.currentMilitaryTime
        
        var alert: UIAlertController = UIAlertController()
        
        if((currentTime + 5) <= time) // You can still make this bus
        {
            alert = UIAlertController(title: "Reminder", message: "Set a time", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
            for num in [5,10,15]
            {
                
                if((currentTime + num) <= time)
                {
                    var timeInMinutes: NSTimeInterval = Double(5)
                    var action = UIAlertAction(title: "\(num) minutes before departure", style: UIAlertActionStyle.Default,
                        handler: { action -> Void in
                            Alarm.createReminder("Catch \(self.name) Bus",
                                                 timeInterval: NSDate(timeIntervalSinceNow: timeInMinutes))
                    })
                    alert.addAction(action)
                }
                
            }
            
        }
        else
        {
            alert = UIAlertController(title: "Run for your life!", message: "You should have left already!", preferredStyle: UIAlertControllerStyle.ActionSheet)
        }
        
        var cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        
        alert.addAction(cancel)
        
        self.presentViewController(alert, animated: true, completion: nil)
        
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
