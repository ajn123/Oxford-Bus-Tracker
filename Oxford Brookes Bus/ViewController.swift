//
//  ViewController.swift
//  OBU Bus Tracker
//
//  Created by AJ Norton on 4/20/15.
//  Copyright (c) 2015 AJ Norton. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet var table: UITableView!
    
    var locations = [String]()
    var overall = Dictionary<String, AnyObject>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // check if the user is running the app for the first time
        //        if let firstTime = NSUserDefaults.standardUserDefaults().objectForKey("firstTime")
        //        {
        //
        //            println("second time")
        //        }
        //        else
        //        {
        //            println("worked")
        //            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "firstTime")
        //        }
        
        if let path = NSBundle.mainBundle().pathForResource("busSchedule", ofType: "plist")
        {
            if let dict = NSDictionary(contentsOfFile: path) as? Dictionary<String, AnyObject>
            {
                locations = dict.keys.array
                overall = dict
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
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
        var cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        
     
        cell.textLabel?.text = "\(locations[indexPath.row])"
        
        return cell
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        performSegueWithIdentifier("routeToTime", sender: indexPath.row)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //TODO
        if segue.identifier == "routeToTime"
        {
            var ttvc =  segue.destinationViewController as! TimeTableViewController
            var place = sender as! Int
            var dicts = overall[locations[place]] as! Dictionary<String,AnyObject>
            var arr = dicts["Weekday"] as! [Int]
            
            ttvc.days = dicts
            ttvc.times = arr.reverse()
        }
    }
    
    
    
    
    
    
}

