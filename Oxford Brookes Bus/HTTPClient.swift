//
//  HTTPClient.swift
//  Oxford Brookes Bus
//
//  Created by AJ Norton on 8/11/15.
//  Copyright (c) 2015 AJ Norton. All rights reserved.
//

import UIKit
import Foundation

class HTTPClient: NSObject {
  
  override init() {
    super.init()
  }
  
  
  func getRequest(name: String) -> [AnyObject] {
    let url = NSURL(string: name)!
  
    let response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>= nil
    let dataVal: NSData = try! NSURLConnection.sendSynchronousRequest(NSURLRequest(URL: url),
                                                                 returningResponse: response)
                                                              
    return HTMLParser.parseBusTable(dataVal) as! [StopInfo]
  }
  
}
