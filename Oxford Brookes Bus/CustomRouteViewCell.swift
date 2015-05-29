//
//  CustomRouteViewCell.swift
//  Oxford Brookes Bus
//
//  Created by AJ Norton on 4/21/15.
//  Copyright (c) 2015 AJ Norton. All rights reserved.
//

import UIKit
import WobbleView



class CustomRouteViewCell: UITableViewCell {
    
    @IBOutlet var downImage: UIImageView!
    @IBOutlet var downTime: UILabel!
    @IBOutlet weak var leadingSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingSpaceConstraint: NSLayoutConstraint!
    
    @IBOutlet var locationTitle: UILabel!
    @IBOutlet weak var panView: UIView!
    
    @IBOutlet var timerLabel: UILabel!
    var indexRow: Int = 0
    var timeInterval: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.panView.backgroundColor = UIColor(patternImage: UIImage(named: "tableSwipe.png")!)
  
        if self.respondsToSelector(Selector("setLayoutMargins:")) {
            layoutMargins = UIEdgeInsetsZero
        }
        
        if self.respondsToSelector(Selector("setPreservesSuperviewLayoutMargins:")) {
            preservesSuperviewLayoutMargins = false
        }
        

        var panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
        panGestureRecognizer.delegate = self
        addGestureRecognizer(panGestureRecognizer)
    }
    
    func handlePanGesture(recognizer: UIPanGestureRecognizer) {
        
        switch(recognizer.state) {
            
        case UIGestureRecognizerState.Changed:
            
            var translation = recognizer.translationInView(recognizer.view!)
            var little = CGFloat(trailingSpaceConstraint.constant  + translation.x * -1)
            trailingSpaceConstraint.constant = fmax(0, little)
            leadingSpaceConstraint.constant = fmin(0, leadingSpaceConstraint.constant + translation.x)
            recognizer.setTranslation(CGPointZero, inView: recognizer.view!)
            
            timeInterval = Int(trailingSpaceConstraint.constant / 30) * 5
            
            timerLabel.text! = "\( Int(trailingSpaceConstraint.constant / 30) * 5)"
            println(trailingSpaceConstraint.constant)
            
        case UIGestureRecognizerState.Ended, UIGestureRecognizerState.Cancelled:
            
            //UIViewController.alertReminden(timeInterval)
            
            
            
            var refreshAlert = UIAlertController(title: "Reminder", message: "Set a reminder for the bus in \(self.timeInterval) minutes.", preferredStyle: UIAlertControllerStyle.Alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                Alarm.createReminder("Catch the Bus",
                    timeInterval: NSDate(timeIntervalSinceNow: Double(self.timeInterval * 60)))
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction!) in
                println("Handle Cancel Logic here")
            }))
            
            var view = UIViewController()
            
            
            var myFrame = CGRectMake(10.0, 10.0, 250.0, 25.0)
            
            var slider = UISlider(frame: myFrame)
            
            slider.minimumValue = 1
            slider.maximumValue = 50
            slider.value = Float(timeInterval)
            
            view.view.addSubview(slider)

            refreshAlert.view.addSubview(view.view)
            
            self.viewForBaselineLayout()!.parentViewController?.presentViewController(refreshAlert, animated: true, completion: nil)
           
            
            leadingSpaceConstraint.constant = 0
            trailingSpaceConstraint.constant = 0
            
          
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.layoutIfNeeded()
            })
            
        default:
            trailingSpaceConstraint.constant = 0
            leadingSpaceConstraint.constant = 0
        }
    }

}


extension CustomRouteViewCell: UIGestureRecognizerDelegate
{
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if gestureRecognizer.isKindOfClass(UIPanGestureRecognizer) {
            
            var velocity = (gestureRecognizer as! UIPanGestureRecognizer).velocityInView(gestureRecognizer.view!)
            
            return fabs(velocity.x) > fabs(velocity.y)
        }
        
        return true;
    }
}
