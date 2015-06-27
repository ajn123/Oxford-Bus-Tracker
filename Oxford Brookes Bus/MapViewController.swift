//
//  MapViewController.swift
//  Oxford Brookes Bus
//
//  Created by AJ Norton on 4/30/15.
//  Copyright (c) 2015 AJ Norton. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet var map: MKMapView!
    
    var locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        var latitude:CLLocationDegrees = 51.751798
        
        var longitude:CLLocationDegrees =  -1.257544
        
        var latDelta:CLLocationDegrees = 0.002
        
        var lonDelta:CLLocationDegrees = 0.095
        
        var span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        
        var location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        
        var region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        for stop in Stop.getDifferantStops()!
        {
            var annotation: StopMKAnnotation = StopMKAnnotation(stop: stop)
            
            var olatitude:CLLocationDegrees = stop.latitude.doubleValue
        
            var olongitude:CLLocationDegrees = stop.longitude.doubleValue
        
            var olocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(olatitude, olongitude)
        
            annotation.coordinate = olocation
        
            annotation.title = stop.stop_name
            
            annotation.subtitle = Stop.allBusUniqueBusStopNames(stop)
        
            map.addAnnotation(annotation)
        }
        
        map.setRegion(region, animated: true)
    }
    
    
    // U1 Heading Hill 51.755511, -1.226302
  
    // For MapKit provided annotations (eg. MKUserLocation) return nil to use the MapKit provided annotation view.
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView!
    {
        // Do NOT annotate your current location
        if(annotation is MKUserLocation)
        {
            return nil
        }
        
        var mkPinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pinLocation")
        mkPinView.canShowCallout = true
        
        mkPinView.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIButton
        
        return mkPinView
    }

    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!)
    {
        performSegueWithIdentifier("annotationPress", sender: view)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        var a = locations[0] as! CLLocation
        
        var latitude:CLLocationDegrees = a.coordinate.latitude
        
        var long: CLLocationDegrees = a.coordinate.longitude
        
        var latDelta: CLLocationDegrees = 0.00001
        
        var longDelte: CLLocationDegrees = 0.00001
        
        var span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelte)
        
        var location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: long)
        
        var region = MKCoordinateRegion(center: location, span: span)
        
    //  self.map.setRegion(region, animated: true)
    
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "annotationPress"
        {
            var dvc = segue.destinationViewController as! UINavigationController
            
            var vc = dvc.topViewController as! MapRouteViewController
            
            var view = sender as! MKAnnotationView
            
            var annotation = view.annotation as! StopMKAnnotation
  
            vc.routeLabelName = annotation.stop.stop_name
            
            vc.stop = annotation.stop
        }
    }
    
    
    
    
}
