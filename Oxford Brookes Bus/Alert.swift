//
//  Alert.swift
//  Oxford Brookes Bus
//
//  Created by AJ Norton on 6/1/15.
//  Copyright (c) 2015 AJ Norton. All rights reserved.
//

import UIKit


class Alert {
    
    class func presentErrorSheet(message: String, view: UIViewController)
    {
        let ActionSheet =  UIAlertController(title: message, message: "hello", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        ActionSheet.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler:nil))
        
        view.presentViewController(ActionSheet, animated: true, completion: nil)
    }
}
