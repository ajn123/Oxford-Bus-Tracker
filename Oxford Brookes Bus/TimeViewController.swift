//
//  TimeViewController.swift
//  Oxford Brookes Bus
//
//  Created by AJ Norton on 4/21/15.
//  Copyright (c) 2015 AJ Norton. All rights reserved.
//

import UIKit

class TimeViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet var timeTable: UITableView!
    @IBOutlet var dayOfWeek: UISegmentedControl!
    
    var times = [Int]()
    
    var days = [String : AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dayOfWeek.selectedSegmentIndex =  NSDate.getWeekday()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentChange(sender: AnyObject) {
        var arr = [Int]()
        switch dayOfWeek.selectedSegmentIndex
        {
            case 0:
                arr = days["Weekday"] as! [Int]
            case 1:
                arr = days["Saturday"] as! [Int]
            case 2:
                arr = days["Sunday"] as! [Int]
            default:
                break;
        }
        times = arr.reverse()
        
        timeTable.reloadData()
    }
    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return times.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "timeCell")
        
        
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute, fromDate: date)
        var hour = components.hour * 100
        var minutes = components.minute
        var militaryTime = hour + minutes
        
        if( militaryTime < times[indexPath.row])
        {
            // green
            cell.backgroundColor = UIColor(red: 0.00, green: 1.00, blue: 0.00, alpha: 1.00)
            cell.detailTextLabel?.text = "Incoming in \(times[indexPath.row] - militaryTime)"
        }
        else
        {
            // red
            cell.backgroundColor = UIColor(red: 0.80, green: 0.00, blue: 0.00, alpha: 1.00)
            cell.detailTextLabel?.text = "Missed"
        }
        
        cell.textLabel?.text = "\(times[indexPath.row])"
        
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
