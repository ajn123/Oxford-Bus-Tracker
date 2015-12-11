//
//  ThreadFactory.swift
//  Oxford Brookes Bus
//
//  Created by AJ Norton on 8/16/15.
//  Copyright (c) 2015 AJ Norton. All rights reserved.
//

import UIKit


public class ThreadFactory {
  
  class func startNewThread(block: dispatch_block_t) {
    let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
    dispatch_async(dispatch_get_global_queue(priority, 0),block)
  }
  
}