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
  var SMSNumber: Int
  var webName: String
  
  init(name: String, SMS: Int)
  {
    self.name = name
    self.SMSNumber = SMS
    self.webName =
    "http://www.oxontime.com/Naptan.aspx?t=departure&sa=\(self.SMSNumber)&dc=&ac=96&vc=&x=0&y=0&format=xhtml"
  }
  
  
}
