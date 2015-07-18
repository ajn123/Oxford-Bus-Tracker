//
//  UIiAdViewController.swift
//  Oxford Brookes Bus
//
//  Created by AJ Norton on 7/18/15.
//  Copyright (c) 2015 AJ Norton. All rights reserved.
//

import Foundation
import UIKit
import iAd

class UIiAdViewController: UIViewController, ADBannerViewDelegate{
    
    lazy var addBanner: ADBannerView = {
        var ad = ADBannerView()
        ad.setTranslatesAutoresizingMaskIntoConstraints(false)
        ad.delegate = self
        return ad
    }()
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
 
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience  init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    
    
    func setUpAdConstraint()
    {
        self.edgesForExtendedLayout = UIRectEdge.Bottom & UIRectEdge.Top
        self.view.addSubview(addBanner)
        var viewDict = ["adBanner": addBanner]
        var verticalConstraint = NSLayoutConstraint.constraintsWithVisualFormat("V:[adBanner]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewDict)
        var horizontalConstraint = NSLayoutConstraint.constraintsWithVisualFormat("H:|[adBanner]|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewDict)
        
        self.view.addConstraints(verticalConstraint)
        self.view.addConstraints(horizontalConstraint)
    }
}