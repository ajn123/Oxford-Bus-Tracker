//
//  HTMLParser.swift
//  Oxford Brookes Bus
//
//  Created by AJ Norton on 8/12/15.
//  Copyright (c) 2015 AJ Norton. All rights reserved.
//

import Foundation
import Kanna
import UIKit


class HTMLParser {
  
  init() {}
  
  class func parseBusTable(data: NSData) -> [String] {
    var strings = [String]()
    
    if let doc = Kanna.HTML(html: data, encoding: NSUTF8StringEncoding) {
      for link in doc.css("tbody > tr > td:first-child") {
        strings.append(link.text!)
      }
    }
    return strings
  }
}