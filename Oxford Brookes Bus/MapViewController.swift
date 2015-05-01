//
//  MapViewController.swift
//  Oxford Brookes Bus
//
//  Created by AJ Norton on 4/30/15.
//  Copyright (c) 2015 AJ Norton. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet var map: MKMapView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        var latitude:CLLocationDegrees = 51.751798
        
        var longitude:CLLocationDegrees =  -1.257544
        
        var latDelta:CLLocationDegrees = 0.002
        
        var lonDelta:CLLocationDegrees = 0.095
        
        var span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        
        var location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        
        var region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        
        var annotation: MKPointAnnotation = MKPointAnnotation()
        
        var olatitude:CLLocationDegrees = 51.755511
        
        var olongitude:CLLocationDegrees = -1.226302
        
        var olocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(olatitude, olongitude)
        
        annotation.coordinate = olocation
        
        annotation.title = "Oxford"
        
        annotation.subtitle = "here"
        
        map.addAnnotation(annotation)
        
        
        
        map.setRegion(region, animated: true)
    }
    
    
    // U! Heading Hill 51.755511, -1.226302
    
    // For MapKit provided annotations (eg. MKUserLocation) return nil to use the MapKit provided annotation view.
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView!
    {
       var mkPinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pinLocation")
        mkPinView.canShowCallout = true
        mkPinView.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIButton
        
        return mkPinView
        
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!)
    {
        println("hello")
    }
    
    
    
    
    
}
