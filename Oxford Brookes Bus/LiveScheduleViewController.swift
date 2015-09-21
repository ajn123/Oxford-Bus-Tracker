//
//  LiveScheduleViewController.swift
//  Oxford Brookes Bus
//
//  Created by AJ Norton on 8/6/15.
//  Copyright (c) 2015 AJ Norton. All rights reserved.
//

import UIKit

class LiveScheduleViewController: UIViewController {
  
  lazy var busTableView: UITableView = {
    var table = UITableView()
    table.translatesAutoresizingMaskIntoConstraints = false
    table.delegate = self
    table.dataSource = self
    table.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    table.pagingEnabled = true
    return table
    }()
  
  lazy var stopSelection: UIPickerView = {
    var pickerView = UIPickerView()
    pickerView.delegate = self
    pickerView.dataSource = self
    pickerView.translatesAutoresizingMaskIntoConstraints = false
    
    return pickerView
  }()
  
  
  lazy var searchButton: UIButton = {
    var button = UIButton()
    button.setTitle("Search", forState: UIControlState.Normal)
    button.setTitleColor(UIColor.blueColor(), forState: UIControlState.Highlighted)
    button.addTarget(self, action: "searchTapped:", forControlEvents: UIControlEvents.TouchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
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
    
    let headerView = UIView(frame: UIScreen.mainScreen().bounds)
    headerView.backgroundColor = UIColor.greenColor()
    headerView.addSubview(stopSelection)
    headerView.addSubview(searchButton)
    self.busTableView.tableHeaderView = headerView
    
    self.view.addSubview(busTableView)
    
    let adjustForTabbarInsets = UIEdgeInsets(top: 0, left: 0, bottom: CGRectGetHeight(self.tabBarController!.tabBar.frame), right: 0)
    self.busTableView.contentInset = adjustForTabbarInsets
    self.busTableView.scrollIndicatorInsets = adjustForTabbarInsets
    
   
    self.edgesForExtendedLayout = UIRectEdge.Bottom
    
    let viewDict = ["webView": busTableView, "pickerView": stopSelection, "button": searchButton]
    
    let vConstraint1 = NSLayoutConstraint.constraintsWithVisualFormat("V:|[button(100)][pickerView(250)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict)
    let vConstraint2 = NSLayoutConstraint.constraintsWithVisualFormat("V:|[webView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict)
    
    let hConstraint1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[pickerView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict)
    let hConstraint2 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[webView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict)
    let hConstraint3 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[button]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict)
    
    headerView.addConstraints(vConstraint1)
    headerView.addConstraints(hConstraint1)
    self.view.addConstraints(hConstraint2)
    self.view.addConstraints(vConstraint2)
    headerView.addConstraints(hConstraint3)
    
    
    
    stopSelection.selectRow(0, inComponent: 0, animated: true)
  }
  
  func searchTapped(selector: UIButton) {
    loadScheudle()
  }
  
  
  func loadScheudle() {
    let act = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
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
    
    self.timeTable.removeAll(keepCapacity: false)
    
    ThreadFactory.startNewThread() {
      let stops = self.stops[self.stopSelection.selectedRowInComponent(0)].getAllSMSNumbers()
      for stop in stops {
        self.timeTable += OxonTimeAPI.sharedInstance.getStopInfo(stop)
      }
      if(self.timeTable.count == 0)
      {
        let st = StopInfo(strings: [], stop: StopInfo.stopDescription.noStops)
        self.timeTable.append(st)
      }
      dispatch_async(dispatch_get_main_queue()) {
        self.busTableView.reloadData()
        act.stopAnimating()
  
        self.getTablePoint(NSIndexPath(forRow: 0, inSection: 0))
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

extension LiveScheduleViewController: UIPickerViewDataSource, UIPickerViewDelegate {
  
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
  func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { 
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
    let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
    let stop = timeTable[indexPath.row]
    cell.textLabel?.numberOfLines = 1
    cell.textLabel?.minimumScaleFactor = 8/(cell.textLabel?.font.pointSize)!
    cell.textLabel?.adjustsFontSizeToFitWidth = true
    
    cell.textLabel?.text = stop.stopString
    return cell
  }
  
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    getTablePoint(indexPath)
  }
  
  func getTablePoint(index: NSIndexPath) {
    let i = self.busTableView.rectForRowAtIndexPath(index)
    
    self.busTableView.setContentOffset(i.origin, animated: true)
  }
  
}
