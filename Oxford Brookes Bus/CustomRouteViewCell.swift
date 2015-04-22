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
    
    @IBOutlet var upImage: UIImageView!
    @IBOutlet var upTime: UILabel!
    
    @IBOutlet var locationTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
                println("I was clicked set select")

        
        // Configure the view for the selected state
    }
    
    
    override func select(sender: AnyObject?) {
        println("I was clicked select")
    }
    


}
