//
//  HTTPClient.swift
//  Oxford Brookes Bus
//
//  Created by AJ Norton on 8/11/15.
//  Copyright (c) 2015 AJ Norton. All rights reserved.
//

import UIKit
import Foundation

public class HTTPClient: NSObject {
  
  override init() {
    super.init()
  }
  
  public func getRequest(name: String) -> [AnyObject] {
    
    guard let url = NSURL(string: name) else {
      return HTMLParser.parseBusTable(nil)
    }
    
    var dataVal: NSData? = nil
    do {
      dataVal = try NSURLConnection.sendSynchronousRequest(NSURLRequest(URL: url),
                                                           returningResponse: nil)
    }
    catch {
      dataVal = nil 
    }
    return HTMLParser.parseBusTable(dataVal) as! [StopInfo]
  }
  
}
