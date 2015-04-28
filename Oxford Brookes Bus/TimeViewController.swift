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
    
    var times = [Time]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dayOfWeek.selectedSegmentIndex =  NSDate.getWeekday()!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func segmentChange(sender: AnyObject) {
     /**   var arr = [Time]()
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
        times = arr.reverse() */
        
        timeTable.reloadData()
    }
    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return times.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "timeCell")

        var militaryTime = NSDate.getTime()
        
        var ti = times[indexPath.row]
        
        var compare = ti.time as Int
        
        if( militaryTime < compare)
        {
            // green
            cell.backgroundColor = UIColor(red: 0.00, green: 1.00, blue: 0.00, alpha: 1.00)
            cell.detailTextLabel?.text = "Incoming in \( militaryTime)"
        }
        else
        {
            // red
            cell.backgroundColor = UIColor(red: 0.80, green: 0.00, blue: 0.00, alpha: 1.00)
            cell.detailTextLabel?.text = "Missed"
        }
        
        cell.textLabel?.text = "\(times[indexPath.row].time)"
        
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
