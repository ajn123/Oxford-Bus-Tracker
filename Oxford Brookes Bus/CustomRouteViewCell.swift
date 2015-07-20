//
//  CustomRouteViewCell.swift
//  Oxford Brookes Bus
//
//  Created by AJ Norton on 4/21/15.
//  Copyright (c) 2015 AJ Norton. All rights reserved.
//

import UIKit

class CustomRouteViewCell: UITableViewCell {
    
    @IBOutlet var downImage: UIImageView!
    @IBOutlet var downTime: UILabel!

    @IBOutlet var locationTitle: UILabel!
    @IBOutlet var slideImage: UIImageView!
    
    @IBOutlet var timerLabel: UILabel!
    var indexRow: Int = 0
    var timeInterval: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.slideImage.image = UIImage(named:"tableSwipeArrow.png")
        
    }
    

         
}
