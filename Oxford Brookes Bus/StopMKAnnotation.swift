//
//  StopMKAnnotation.swift
//  Oxford Brookes Bus
//
//  Created by AJ Norton on 6/26/15.
//  Copyright (c) 2015 AJ Norton. All rights reserved.
//

import UIKit
import MapKit

class StopMKAnnotation: MKPointAnnotation
{
    var stop: Stop
    
    
    init(stop: Stop) {
        self.stop = stop
        super.init()
    }
}
