//
//  SchedulePageViewController.swift
//  Oxford Brookes Bus
//
//  Created by AJ Norton on 4/22/15.
//  Copyright (c) 2015 AJ Norton. All rights reserved.
//

import UIKit

class SchedulePageViewController: UIViewController, UIPageViewControllerDataSource {
    
    // Initialize it right away here
    private let contentImages =
    ["nature_pic_1.png",
        "nature_pic_2.png",
        "nature_pic_3.png",
        "nature_pic_4.png"];
    
    // MARK: - Variables
    private var pageViewController: UIPageViewController?
    
    
    
    @IBOutlet var pageControl: UIPageControl!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPageControl()
        
        let pageController = self.storyboard!.instantiateViewControllerWithIdentifier("PageController") as! UIPageViewController
        pageController.dataSource = self
        
        if contentImages.count > 0 {
            let firstController = getItemController(0)!
            let startingViewControllers: NSArray = [firstController]
            pageController.setViewControllers(startingViewControllers as [AnyObject], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
            
        }
        
        pageViewController = pageController
        addChildViewController(pageViewController!)
        self.view.addSubview(pageViewController!.view)
        pageViewController!.didMoveToParentViewController(self)
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     func setupPageControl() {
        var pageControl = UIPageControl()
        pageControl.frame = CGRectMake(20,20,100,100)
        self.view.addSubview(pageControl)
    
        
    }
    
    
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! ScheduleViewController
        
        if itemController.itemIndex > 0 {
            return getItemController(itemController.itemIndex-1)
        }
        
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! ScheduleViewController
        
        if itemController.itemIndex+1 < contentImages.count {
            return getItemController(itemController.itemIndex+1)
        }
        
        return nil
    }
    
    private func getItemController(itemIndex: Int) -> ScheduleViewController? {
        
        if itemIndex < contentImages.count {
            let pageItemController = self.storyboard!.instantiateViewControllerWithIdentifier("PageContentController") as! ScheduleViewController
            
            pageItemController.itemIndex = itemIndex
            pageItemController.imageName = "\(contentImages[itemIndex])"
            return pageItemController
        }
        
        return nil
    }
    
    // MARK: - Page Indicator
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return contentImages.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
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
