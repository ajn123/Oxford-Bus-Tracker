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
  
  
  func getRequest(name: String) -> [String] {
    let url = NSURL(string: name)!
    var strings = [String]()
    
    var response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>= nil
    var dataVal: NSData = NSURLConnection.sendSynchronousRequest(NSURLRequest(URL: url),
                                                                 returningResponse: response,
                                                                 error: nil)!
                                                              
    strings =  HTMLParser.parseBusTable(dataVal)
    return strings
  }
  
}
