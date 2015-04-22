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
    
    var indexRow: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       

        
        // Configure the view for the selected state
    }
    
    
    override func select(sender: AnyObject?) {
    }
    


}
