//
//  LiveSchedulerMapViewController.swift
//  Oxford Brookes Bus
//
//  Created by AJ Norton on 10/26/15.
//  Copyright © 2015 AJ Norton. All rights reserved.
//

import UIKit
import MapKit
import iAd


class LiveSchedulerMapViewController: UIViewController, CLLocationManagerDelegate, ADBannerViewDelegate {
  
  lazy var map: MKMapView! = {
    var m = MKMapView()
    m.translatesAutoresizingMaskIntoConstraints = false
    m.delegate = self
    return m
  }()
  
  lazy var locationManager: CLLocationManager = {
    var locMan = CLLocationManager()
    locMan.delegate = self
    return locMan
  }()
  
  lazy var iAd: ADBannerView = {
    var ad = ADBannerView()
    ad.delegate = self
    ad.translatesAutoresizingMaskIntoConstraints = false 
    return ad
  }()
  
  
  override func viewDidLoad() {
    loadMap()
    
    self.edgesForExtendedLayout = UIRectEdge.Bottom
    
    self.view.addSubview(map)
    self.view.addSubview(iAd)
    let viewDict = ["map": map, "iAd": iAd]
    
    let vConstraint1 =
      NSLayoutConstraint.constraintsWithVisualFormat("V:|[iAd][map]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict)
    
    let hConstraint1 =
      NSLayoutConstraint.constraintsWithVisualFormat("H:|[map]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict)
    
    let hConstraint2 =
      NSLayoutConstraint.constraintsWithVisualFormat("H:|[iAd]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict)
    
    self.view.addConstraints(vConstraint1)
    self.view.addConstraints(hConstraint1)
    self.view.addConstraints(hConstraint2)
    
    let listIcon = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: "listClicked:")
    
    self.navigationItem.rightBarButtonItem = listIcon
    
    if(!(NSUserDefaults.standardUserDefaults().boolForKey("onBoarding")))
    {
      let onBoardView = OnBoardingView(frame: UIScreen.mainScreen().bounds)
      self.view.addSubview(onBoardView)
      NSUserDefaults.standardUserDefaults().setBool(true, forKey: "onBoarding")
    }
    
  }
  
  func listClicked(selector: UIBarButtonItem) {
    self.navigationController?.pushViewController(LiveScheduleViewController(), animated: true)
  }
  
  func loadMap() {
    map.showsUserLocation = true
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()
    
    let latitude: CLLocationDegrees = Constants.OxfordMap.latitude
    
    let longitude: CLLocationDegrees = Constants.OxfordMap.longitude
    
    let latDelta: CLLocationDegrees = Constants.OxfordMap.latDelta
    
    let lonDelta: CLLocationDegrees = Constants.OxfordMap.lonDelta
    
    let span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
    
    let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
    
    let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
    
    for stop in StopNumberManager.stopManager.stops
    {
      let annotation = MKPointAnnotation()
      
      let olatitude: CLLocationDegrees = stop.latitude
      
      let olongitude: CLLocationDegrees = stop.longitude
      
      let olocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(olatitude, olongitude)
      
      annotation.coordinate = olocation
      
      annotation.title = stop.name
      
      map.addAnnotation(annotation)
    }
    map.setRegion(region, animated: true)
  }
}

extension LiveSchedulerMapViewController: MKMapViewDelegate {
  
  func mapView(mapView: MKMapView,
    annotationView view: MKAnnotationView,
    calloutAccessoryControlTapped control: UIControl)
  {
    self.navigationController!.pushViewController(
      LiveScheduleViewController(stopNumber: ((view.annotation?.title)!)!), animated: true)
  }
  
  func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?
  {
    // Do NOT annotate your current location
    if(annotation is MKUserLocation)
    {
      return nil
    }
    
    let mkPinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pinLocation")
    mkPinView.canShowCallout = true
    mkPinView.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
    
    return mkPinView
  }

}
