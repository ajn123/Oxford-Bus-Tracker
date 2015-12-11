//
//  OxonTimeAPI.swift
//  Oxford Brookes Bus
//
//  Created by AJ Norton on 8/11/15.
//  Copyright (c) 2015 AJ Norton. All rights reserved.
//

import UIKit


public class OxonTimeAPI: NSObject, StopInformation {
  public static let sharedInstance = OxonTimeAPI()
  public let httpClient = HTTPClient()
  
  override init() {
    super.init()
    
  }

   public func getStopInfo(name: String) -> [StopInfo] {
    let stops = httpClient.getRequest(name) as! [StopInfo]
    return stops
  }
  

}