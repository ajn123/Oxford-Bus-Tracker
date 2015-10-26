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
    stops.append( StopNumber(name: "Wheatley Campus", SMS: [69342836], latitude: 51.747191, longitude: -1.135268))
    stops.append( StopNumber(name: "Brookes University stop B2", SMS: [69325678], latitude: 51.7558266, longitude: -1.2253118 ))
    stops.append( StopNumber(name: "Brookes Univ B5", SMS: [69325679], latitude: 51.755474, longitude: -1.226263))
    stops.append( StopNumber(name: "Crescent Hall", SMS: [69324626], latitude: 51.737698,longitude: -1.207406 ))
    stops.append( StopNumber(name: "Gipsy Lane Campus", SMS: [69325646, 69325676], latitude: 51.75434,longitude: -1.22384))
//    stops.append( StopNumber(name: "Headington Hill Campus", SMS: [69346867]) )
    stops.append( StopNumber(name: "Castle Street", SMS: [69326548, 69326547, 69326526, 69326545, 69347482], latitude: 51.751495,longitude: -1.260925))
    stops.append( StopNumber(name: "Speedwell Street", SMS: [69345486, 69345627],latitude: 51.748428,longitude:  -1.258112))
    stops.append( StopNumber(name: "Headington Shops",
      SMS: [69342583, 69325689, 69325452, 69347624, 69347625, 69325692], latitude: 51.759688, longitude: -1.212619))
    stops.append( StopNumber(name: "Slade Park", SMS: [69347876], latitude: 51.7439104, longitude: -1.2016076 ))
    stops.append( StopNumber(name: "Wheatley Church", SMS: [69342934, 69342828,69327374,69327543], latitude: 51.747191, longitude: -1.135268) )
    stops.append( StopNumber(name: "Park End Street", SMS: [69328968], latitude:  51.7511288,longitude:  -1.2573163 ))
    stops.append( StopNumber(name: "Harcourt Hill Campus", SMS: [69327243], latitude: 51.7403825, longitude: -1.2913308 ))
    stops.append( StopNumber(name: "St. Aldates", SMS: [69326476,69326478], latitude: 51.750603, longitude: -1.2569412 ))
    stops.append( StopNumber(name: "Carfax/High Street", SMS: [69326483,69326478], latitude: 51.751985, longitude: -1.2580974))
    sortStops()
  }
  
  
  func sortStops() {
    stops.sortInPlace()
    {
      (s1: StopNumber, s2: StopNumber) -> Bool in
      return s1.name.localizedCaseInsensitiveCompare(s2.name) == NSComparisonResult.OrderedAscending
    }
  }
  
  func findStop(name: String) -> StopNumber? {
    for stop in stops {
      if(stop.name == name) {
        return stop
      }
    }
    return nil 
  }
  
}