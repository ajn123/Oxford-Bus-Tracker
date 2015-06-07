//
//  UIViewExtension.swift
//  Oxford Brookes Bus
//
//  Created by AJ Norton on 5/27/15.
//  Copyright (c) 2015 AJ Norton. All rights reserved.
//

import UIKit


extension UIView
{
    var parentViewController: UIViewController?
    {
            var parentResponder: UIResponder? = self
            while(parentResponder != nil)
            {
                parentResponder = parentResponder!.nextResponder()
                if parentResponder is UIViewController
                {
                    return parentResponder as? UIViewController
                }
                
            }
        return nil
    }
}