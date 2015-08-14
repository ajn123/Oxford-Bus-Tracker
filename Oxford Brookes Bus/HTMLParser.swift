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
  
  class func parseBusTable(data: NSData) -> [AnyObject] {
    var strings = [String]()
    var stopInfo = [StopInfo]()
    
    if let doc = Kanna.HTML(html: data, encoding: NSUTF8StringEncoding) {
      for (index, link) in enumerate(doc.css("tbody > tr > td:first-child, tbody > tr > td:nth-child(2), tbody > tr > td:nth-child(3)")) {
        if (link.text! != "")
        {
          strings.append(link.text!)
          if(strings.count >= 3)
          {
            stopInfo.append(StopInfo(strings: strings))
            strings.removeAll(keepCapacity: false)
          }
        }
      }
    }
    
    return stopInfo
  }
  
  
}