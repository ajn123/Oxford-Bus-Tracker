//
//  OnboardingView.swift
//  Oxford Brookes Bus
//
//  Created by AJ Norton on 10/30/15.
//  Copyright © 2015 AJ Norton. All rights reserved.
//

import UIKit

class OnBoardingView: UIView {
  
  var radius: CGFloat {
    return min(self.bounds.width, self.bounds.height) / 2 * scale
  }
  
  var scale: CGFloat = 0.9 {
    didSet {
      setNeedsDisplay()
    }
  }
  
  override func drawRect(rect: CGRect) {
    let path =
      UIBezierPath(arcCenter: self.center, radius: 100.0, startAngle: 0.0, endAngle: CGFloat(M_PI * 2), clockwise: true)
    
    createCircle(path, color: UIColor.redColor(), lineWidth: 5.0)
    
    let path2 =
      UIBezierPath(arcCenter: CGPoint(x: self.bounds.maxX, y: self.bounds.minY), radius: 220, startAngle: 0.0, endAngle: CGFloat(M_PI), clockwise: true)
    
    createCircle(path2, color: UIColor.greenColor(), lineWidth: 3.0)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6)
    
    let textView = UILabel(frame: CGRect(origin: self.center, size: CGSize(width: 200, height: 200)))
    textView.center = self.center
    createLabel(textView, text: "Find your closest stop and tap it for bus info.")
    
    
    let p1 = CGPoint(x: self.bounds.maxX - 200, y: self.bounds.minY )
    
    let textView1 = UILabel(frame: CGRect(origin: p1, size: CGSize(width: 200, height: 200)))
    createLabel(textView1, text: "Tap search to find your bus stop.")
    
    self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "removeView:"))
  }
  
  
  func removeView(targe: UIBarButtonItem) {
    self.removeFromSuperview()
  }
  
  
  func createCircle(bezierPath: UIBezierPath, color: UIColor, lineWidth: CGFloat) {
    color.setStroke()
    bezierPath.lineWidth = lineWidth
    bezierPath.stroke()
  }
  
  func createLabel(label: UILabel, text: String) -> UILabel {
    label.text = text
    label.textAlignment = .Center
    label.textColor = UIColor.whiteColor()
    label.numberOfLines = 2
    self.addSubview(label)
    return label
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
