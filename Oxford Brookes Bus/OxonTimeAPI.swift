//
//  OxonTimeAPI.swift
//  Oxford Brookes Bus
//
//  Created by AJ Norton on 8/11/15.
//  Copyright (c) 2015 AJ Norton. All rights reserved.
//

import UIKit


class OxonTimeAPI: NSObject {
  static let sharedInstance = OxonTimeAPI()
  private let httpClient = HTTPClient() 
  
  override init() {
    super.init()
    
  }
  
  func getSchedule(busStopName: String) -> [String] {
    return httpClient.getRequest(busStopName)
  }
}