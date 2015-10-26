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
        
        let latitude:CLLocationDegrees = Constants.OxfordMap.latitude
        
        let longitude:CLLocationDegrees =  Constants.OxfordMap.longitude
        
        let latDelta:CLLocationDegrees = Constants.OxfordMap.latDelta
        
        let lonDelta:CLLocationDegrees = Constants.OxfordMap.lonDelta
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        for stop in Stop.getDifferantStops()!
        {
            let annotation: StopMKAnnotation = StopMKAnnotation(stop: stop)
            
            let olatitude:CLLocationDegrees = stop.latitude.doubleValue
        
            let olongitude:CLLocationDegrees = stop.longitude.doubleValue
        
            let olocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(olatitude, olongitude)
        
            annotation.coordinate = olocation
        
            annotation.title = stop.stop_name
            
            annotation.subtitle = Stop.allBusUniqueBusStopNames(stop)
        
            map.addAnnotation(annotation)
        }
        
        map.setRegion(region, animated: true)
    }
    
    
    // U1 Heading Hill 51.755511, -1.226302
  
    // For MapKit provided annotations (eg. MKUserLocation) return nil to use the MapKit provided annotation view.
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

    func mapView(mapView: MKMapView,
                 annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl)
    {
      let vc = MapRouteViewController()
      
      let annotation = view.annotation as! StopMKAnnotation
      
      vc.routeLabelName = annotation.stop.stop_name
      
      vc.stop = annotation.stop
      
      self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let a = locations[0] 
        
        let latitude:CLLocationDegrees = a.coordinate.latitude
        
        let long: CLLocationDegrees = a.coordinate.longitude
        
        let latDelta: CLLocationDegrees = 0.0002
        
        let longDelte: CLLocationDegrees = 0.0002
        
        let span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelte)
        
        let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: long)
        
        var region = MKCoordinateRegion(center: location, span: span)
        
    //  self.map.setRegion(region, animated: true)
    
    }
}
