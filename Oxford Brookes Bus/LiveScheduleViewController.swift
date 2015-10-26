//
//  LiveScheduleViewController.swift
//  Oxford Brookes Bus
//
//  Created by AJ Norton on 8/6/15.
//  Copyright (c) 2015 AJ Norton. All rights reserved.
//

import UIKit
import iAd

class LiveScheduleViewController: UIViewController, ADBannerViewDelegate {
  
  lazy var busTableView: UITableView = {
    var table = UITableView()
    table.translatesAutoresizingMaskIntoConstraints = false
    table.delegate = self
    table.dataSource = self
    table.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    table.pagingEnabled = true
    table.showsHorizontalScrollIndicator = false
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
    button.setTitle("Find Buses", forState: UIControlState.Normal)
    button.titleLabel!.font = UIFont(name: "HelveticaNeue-Light", size: 26)
    button.setTitleColor(UIColor.blueColor(), forState: UIControlState.Highlighted)
    button.addTarget(self, action: "searchTapped:", forControlEvents: UIControlEvents.TouchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = UIColor.blackColor()
    return button
  }()
  
  lazy var iAd: ADBannerView = {
    var ad = ADBannerView()
    ad.translatesAutoresizingMaskIntoConstraints = false
    ad.delegate = self
    return ad
  }()
  
  var stops = [StopNumber]()
  var timeTable = [StopInfo]()
  
  var selectedStopNumber: StopNumber?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Live Schedule"
    stops = StopNumberManager.stopManager.stops
  
    setUpView()
  }
  
  var screenHeight: CGFloat {
    return UIScreen.mainScreen().bounds.height -
      self.tabBarController!.tabBar.frame.height -
      (self.navigationController?.navigationBar.bounds.height)! -
      UIApplication.sharedApplication().statusBarFrame.size.height -
      iAd.frame.height
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  convenience init(stopNumber: String) {
    self.init()
    selectedStopNumber = StopNumberManager.stopManager.findStop(stopNumber)!
  }
  
  func setUpView() {
    let searchIcon = UIBarButtonItem(barButtonSystemItem: .Search,
                                     target: self,
                                     action: "searchClicked:")
    
    self.navigationItem.rightBarButtonItem = searchIcon

    let headerView =
      UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: self.screenHeight))
    
    headerView.backgroundColor = UIColor.clearColor()
    headerView.addSubview(stopSelection)
    headerView.addSubview(searchButton)
    self.view.addSubview(iAd)
    self.busTableView.tableHeaderView = headerView
    
    self.view.addSubview(busTableView)
    
    headerView.backgroundColor = UIColor(red: 52 / 255, green: 152 / 255, blue: 219 / 255, alpha: 1)
    
    let adjustForTabbarInsets =
      UIEdgeInsets(top: 0, left: 0, bottom: CGRectGetHeight(self.tabBarController!.tabBar.frame), right: 0)
    self.busTableView.contentInset = adjustForTabbarInsets
    self.busTableView.scrollIndicatorInsets = adjustForTabbarInsets
    
    searchButton.layer.cornerRadius = 17.0
    self.edgesForExtendedLayout = UIRectEdge.Bottom
    
    let viewDict = ["webView": busTableView, "pickerView": stopSelection, "button": searchButton, "iAd": iAd]
    
    let vConstraint1 =
      NSLayoutConstraint.constraintsWithVisualFormat("V:|-[pickerView][button(60)]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict)
    
    let vConstraint2 =
      NSLayoutConstraint.constraintsWithVisualFormat("V:|[iAd][webView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict)
    
    let hConstraint1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[pickerView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict)
    let hConstraint2 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[webView]|", options:
      NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict)
    let hConstraint3 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[button]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict)
    let hConstraint4 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[iAd]|", options:
      NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict)
    
    self.view.addConstraints(hConstraint2)
    self.view.addConstraints(vConstraint2)
    self.view.addConstraints(hConstraint4)
    
    headerView.addConstraints(vConstraint1)
    headerView.addConstraints(hConstraint1)
    headerView.addConstraints(hConstraint3)
    
    stopSelection.selectRow(stopSelection.numberOfRowsInComponent(0) / 2, inComponent: 0, animated: true)
    
    if (selectedStopNumber != nil) {
      loadScheudle(selectedStopNumber!)
    }
  }
  
  func searchTapped(selector: UIButton) {
    loadScheudle(self.stops[self.stopSelection.selectedRowInComponent(0)])
  }
  
  func listClicked(sender: UIBarButtonItem) {
    self.navigationController?.pushViewController(LiveSchedulerMapViewController(), animated: true)
  }
  
  func searchClicked(sender: UIBarButtonItem) {
    self.busTableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
  }
  
  func loadScheudle(stopNumber: StopNumber) {
    let act = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    act.backgroundColor = UIColor.blackColor()
    act.layer.cornerRadius = 8.0
    
    var frame = act.frame
    let squareSize: CGFloat = 100.0
    
    frame.size.width = squareSize
    frame.size.height = squareSize
    
    frame.origin.x = view.frame.size.width / 2 - frame.size.width / 2
    frame.origin.y = view.frame.size.height / 2 - frame.size.height / 2
   
    act.frame = frame
    view.addSubview(act)
    act.startAnimating()
    
    self.timeTable.removeAll(keepCapacity: false)
    
    ThreadFactory.startNewThread() {
      let stops = stopNumber.getAllSMSNumbers()
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
        act.removeFromSuperview()
      }
    }
  }
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
  
  
  func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
  //  banner.removeFromSuperview()
  }
  
}
