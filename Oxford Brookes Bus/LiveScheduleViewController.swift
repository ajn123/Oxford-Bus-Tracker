//
//  LiveScheduleViewController.swift
//  Oxford Brookes Bus
//
//  Created by AJ Norton on 8/6/15.
//  Copyright (c) 2015 AJ Norton. All rights reserved.
//

import UIKit

class LiveScheduleViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
  
  lazy var busWebView: UIWebView = {
    var webView = UIWebView()
    webView.setTranslatesAutoresizingMaskIntoConstraints(false)
    
    
    return webView
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
    button.addTarget(self, action: "searchTapped:", forControlEvents: UIControlEvents.TouchUpInside)
    button.setTranslatesAutoresizingMaskIntoConstraints(false)
    button.backgroundColor = UIColor.redColor()
    return button
  }()
  
  var stops = [String]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Live Schedule"
    stops = Stop.getDifferantStops()!.map { $0.stop_name }.sorted
      { $0.localizedCaseInsensitiveCompare($1) == NSComparisonResult.OrderedAscending }
    
    setUpView()
    // Do any additional setup after loading the view.
  }
  
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  
  func setUpView() {
    self.view.addSubview(busWebView)
    self.view.addSubview(stopSelection)
    self.view.addSubview(searchButton)
    
    self.edgesForExtendedLayout = UIRectEdge.Top & UIRectEdge.Bottom
    
    var viewDict = ["webView": busWebView, "pickerView": stopSelection, "button": searchButton]
    
    var vConstraint1 = NSLayoutConstraint.constraintsWithVisualFormat("V:|[pickerView(100)][button][webView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewDict)

    
    var hConstraint1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[pickerView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewDict)
    var hConstraint2 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[webView]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewDict)
    var hConstraint3 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[button]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewDict)
    
    
    self.view.addConstraints(vConstraint1)
  //  self.view.addConstraints(vConstraint2)
    self.view.addConstraints(hConstraint1)
    self.view.addConstraints(hConstraint2)
    self.view.addConstraints(hConstraint3)
  }
  
  func searchTapped(selector: UIButton) {
    var url = NSURLRequest(URL: NSURL(string: "http://www.oxontime.com/Naptan.aspx?txtSMSnumber=69325678&txtStopname=&txtRoad=&txtTownVillage=&txtPostCodeGZ=&txtServicenumber=&rdExactMatch=exact&hdnSearchType=searchbySMSnumber&hdnSearchValue=69325678&hdnMode=&hdnChkValue=&hdnMapURL=%2Fmap.aspx%3Fmaplayers%3Dnaptan")!)
    busWebView.loadRequest(url)
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
    return stops[row]
  }
  
  
}
