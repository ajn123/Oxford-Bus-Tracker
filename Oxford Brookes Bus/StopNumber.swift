//
//  StopNumber.swift
//  Oxford Brookes Bus
//
//  Created by AJ Norton on 8/8/15.
//  Copyright (c) 2015 AJ Norton. All rights reserved.
//

import UIKit

class StopNumber: NSObject {
  
  var name: String
  var SMSNumber: [Int]
  var latitude: Double = 0.0
  var longitude: Double = 0.0
  
  var webName: String {
    return "http://www.oxontime.com/Naptan.aspx?t=departure&sa=\(self.SMSNumber)&dc=&ac=96&vc=&x=0&y=0&format=xhtml"
  }
  
  init(name: String, SMS: [Int], latitude: Double = 0.0, longitude: Double = 0.0)
  {
    self.name = name
    self.SMSNumber = SMS
    self.latitude = latitude
    self.longitude = longitude
  }
  
  func getAllSMSNumbers() -> [String] {
    var strings = [String]()
    for num in SMSNumber {
      strings.append("http://www.oxontime.com/Naptan.aspx?t=departure&sa=\(num)&dc=&ac=96&vc=&x=0&y=0&format=xhtml")
    }
    
    return strings
  }
  
  
}
