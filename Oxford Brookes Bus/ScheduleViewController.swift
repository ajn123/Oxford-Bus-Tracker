//
//  ScheduleViewController.swift
//  Oxford Brookes Bus
//
//  Created by AJ Norton on 4/22/15.
//  Copyright (c) 2015 AJ Norton. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController {
    
    
    @IBOutlet var label: UILabel!

    
    var itemIndex: Int = 0 // ***
    // MARK: - Variables
    
    var imageName: String = ""     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = imageName

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
