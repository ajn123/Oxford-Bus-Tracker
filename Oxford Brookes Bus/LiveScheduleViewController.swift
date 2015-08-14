//
//  LiveScheduleViewController.swift
//  Oxford Brookes Bus
//
//  Created by AJ Norton on 8/6/15.
//  Copyright (c) 2015 AJ Norton. All rights reserved.
//

import UIKit

class LiveScheduleViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
  
  lazy var busTableView: UITableView = {
    var table = UITableView()
    table.setTranslatesAutoresizingMaskIntoConstraints(false)
    table.delegate = self
    table.dataSource = self
    table.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    return table
    }()
  
  lazy var stopSelection: UIPickerView = {
    var pickerView = UIPickerView()
    pickerView.delegate = self
    pickerView.dataSource = self
    pickerView.setTranslatesAutoresizingMaskIntoConstraints(false)
    
    return pickerView
  }()
  
  
  lazy var searchButton: UIButton = {
    var button = UIButton()
    button.setTitle("Search", forState: UIControlState.Normal)
    button.setTitleColor(UIColor.blueColor(), forState: UIControlState.Highlighted)
    button.addTarget(self, action: "searchTapped:", forControlEvents: UIControlEvents.TouchUpInside)
    button.setTranslatesAutoresizingMaskIntoConstraints(false)
    button.backgroundColor = UIColor.redColor()
    return button
  }()
  
  var stops = [StopNumber]()
  var timeTable = [StopInfo]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Live Schedule"
    stops = StopNumberManager.stopManager.stops
  
    setUpView()
  }
  
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  
  func setUpView() {
    self.view.addSubview(busTableView)
    self.view.addSubview(stopSelection)
    self.view.addSubview(searchButton)
    
    self.edgesForExtendedLayout = UIRectEdge.Top & UIRectEdge.Bottom
    
    var viewDict = ["webView": busTableView, "pickerView": stopSelection, "button": searchButton]
    
    var vConstraint1 = NSLayoutConstraint.constraintsWithVisualFormat("V:|[pickerView(100)][button][webView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewDict)

    
    var hConstraint1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[pickerView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewDict)
    var hConstraint2 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[webView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewDict)
    var hConstraint3 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[button]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewDict)
    
    
    self.view.addConstraints(vConstraint1)
  //  self.view.addConstraints(vConstraint2)
    self.view.addConstraints(hConstraint1)
    self.view.addConstraints(hConstraint2)
    self.view.addConstraints(hConstraint3)
    
    stopSelection.selectRow(0, inComponent: 0, animated: true)
  }
  
  func searchTapped(selector: UIButton) {
    
    loadScheudle()
  }
  
  
  func loadScheudle() {
    var act = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    act.backgroundColor = UIColor.blackColor()
    act.layer.cornerRadius = 8.0
    var frame = act.frame
    
    frame.size.width = 100.0
    frame.size.height = 100.0
    
    frame.origin.x = busTableView.frame.size.width / 2 - frame.size.width / 2
    frame.origin.y = busTableView.frame.size.height / 2 - frame.size.height / 2
   
    act.frame = frame
    busTableView.addSubview(act)
    act.startAnimating()
    
    // TODO:  CHANGE ME
    let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
    dispatch_async(dispatch_get_global_queue(priority, 0)) {
      var stop = self.stops[self.stopSelection.selectedRowInComponent(0)].webName
      self.timeTable = OxonTimeAPI.sharedInstance.getStopInfo(stop)
      if(self.timeTable.count == 0)
      {
        var st = StopInfo(strings: [], stop: StopInfo.stopDescription.noStops)
        self.timeTable.append(st)
      }
      dispatch_async(dispatch_get_main_queue()) {
      
        self.busTableView.reloadData()
        act.stopAnimating()
      }
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

extension LiveScheduleViewController: UIPickerViewDataSource {
  
  // returns the number of 'columns' to display.
  func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
    return 1
  }
  
  // returns the # of rows in each component..
  func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return stops.count
  }
  
  // these methods return either a plain NSString, a NSAttributedString, or a view (e.g UILabel) to display the row for the component.
  // for the view versions, we cache any hidden and thus unused views and pass them back for reuse.
  // If you return back a different object, the old one will be released. the view will be centered in the row rect
  func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
    return stops[row].name
  }
}



extension LiveScheduleViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return timeTable.count
  }
  
  // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
  // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
    var stop = timeTable[indexPath.row]
    cell.textLabel?.text = stop.stopString
    return cell
  }
  
}
