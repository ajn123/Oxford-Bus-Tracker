//
//  StopInformationTuple.swift
//  Oxford Brookes Bus
//
//  Created by AJ Norton on 8/13/15.
//  Copyright (c) 2015 AJ Norton. All rights reserved.
//

import Foundation




protocol StopInformation {
  
  func getStopInfo(name: String) -> [StopInfo]
}



class StopInfo: NSObject {
  
  enum stopDescription {
    case noStops
    case multiStops
  }

  var busName: String = ""
  var destination: String = ""
  var departureTime: String = ""
  var stopString: String = ""
  
  init(strings: [String], stop: stopDescription = .multiStops) {
    switch(stop)
    {
      case .multiStops:
        busName = strings[0]
        destination = strings[1]
        departureTime = strings[2]
        self.stopString = "Bus \(self.busName) to \(self.destination) in \(self.departureTime)"
      case .noStops:
        self.stopString = "No stops available at this time."
    }
  }
}