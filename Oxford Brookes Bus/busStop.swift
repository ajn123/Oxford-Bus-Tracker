//
//  busStop.swift
//  Oxford Brookes Bus
//
//  Created by AJ Norton on 4/30/15.
//  Copyright (c) 2015 AJ Norton. All rights reserved.
//

import Foundation


class BusStop{
    var name: String
    var stop_times: [Int]
    var day: Int
    var bus_type: String
    var direction: Int = 0
    
    
    init(name: String, stop_times: [Int], day: Int, bus_type: String, direction: Int)
    {
        self.name = name
        self.stop_times = stop_times
        self.day = day
        self.bus_type = bus_type
        self.direction = direction
    }
}