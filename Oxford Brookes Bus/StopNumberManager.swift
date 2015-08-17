//
//  StopNumberManager.swift
//  Oxford Brookes Bus
//
//  Created by AJ Norton on 8/8/15.
//  Copyright (c) 2015 AJ Norton. All rights reserved.
//

import Foundation
import UIKit



class StopNumberManager {
  
  static var stopManager = StopNumberManager()
  
  var stops = [StopNumber]()
  
  init()
  {
    stops.append( StopNumber(name: "Wheatley Campus", SMS: [69342836]) )
    stops.append( StopNumber(name: "Brookes University stop B2", SMS: [69325678]) )
    stops.append( StopNumber(name: "Brookes Univ B5", SMS: [69325679]) )
    stops.append( StopNumber(name: "Crescent Hall", SMS: [69324626]) )
    stops.append( StopNumber(name: "Gipsy Lane Campus", SMS: [69348562, 69325646, 69325676]) )
    stops.append( StopNumber(name: "Headington Hill Campus", SMS: [69346867]) )
    stops.append( StopNumber(name: "Castle Street", SMS: [69326548, 69326547, 69326526, 69326545, 69347482]) )
    stops.append( StopNumber(name: "Speedwell Street", SMS: [69345486, 69345627]) )
    
    sortStops()
  }
  
  
  func sortStops() {
    stops.sort()
    {
      (s1: StopNumber, s2: StopNumber) -> Bool in
      return s1.name.localizedCaseInsensitiveCompare(s2.name) == NSComparisonResult.OrderedAscending
    }
  }
}