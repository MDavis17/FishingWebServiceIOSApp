//
//  MapViewController.swift
//  FishingWebServiceIOS
//
//  Created by Max Davis on 8/16/16.
//  Copyright © 2016 Max Davis. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var MapView: MKMapView!
    
    var shownLocation = false
    var currentUserLat = 0.0
    var currentUserLong = 0.0
    var closestStation = Station(name: "",id: 0,coord: CLLocationCoordinate2D())
    var stationsNearUser = [Station]()
    
    
    
    var locationManager = CLLocationManager()
    
    func setUserLocation(lat: Double, lon: Double) {
        currentUserLat = lat
        currentUserLong = lon
    }
    
    func setClosest_Station(st: Station) {
        closestStation = st
    }
    
    func setClosestStations(stations: [Station]) {
        stationsNearUser = stations
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MapView.delegate = self

        
        // Ask for Authorisation from the User.
        locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        //let station = Station(name: closestStation.name, id: closestStation.id, coord: closestStation.coord)//CLLocationCoordinate2D(latitude: 34.4044,longitude: -119.6925))
        //MapView.addAnnotation(station)
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if( segue.identifier == "StationViewSegue") {
            let svc = segue.destinationViewController as! StationViewController
            
            svc.station = closestStation
        }
    }
    
    /*
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView{
            //println(view.annotation!.title) // annotation's title
            //println(view.annotation!.subtitle) // annotation's subttitle
            
            //performSegueWithIdentifier("mySegueID", sender: nil)
            
            //let stationView = self.storyboard?.instantiateViewControllerWithIdentifier("StationViewController") as! StationViewController
            //navigationController?.pushViewController(stationView, animated: true)
            
            //Perform a segue here to navigate to another viewcontroller
            // On tapping the disclosure button you will get here
        }
    }*/
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        //println("viewForannotation")
        if annotation is MKUserLocation {
            //return nil
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            //println("Pinview was nil")
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
        }
        
        var button = UIButton(type: UIButtonType.InfoLight)
        button.addTarget(self, action: #selector(MapViewController.viewStation), forControlEvents: .TouchUpInside)
        
        pinView?.rightCalloutAccessoryView = button
        
        
        return pinView
    }
    
    func viewStation() {
        performSegueWithIdentifier("StationViewSegue", sender: self)
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        let location = locations.last! as CLLocation
        
        if !shownLocation {
            setUserLocation(location.coordinate.latitude,lon: location.coordinate.longitude)
            //let station = Station(name: closestStation.name, id: closestStation.id, coord: closestStation.coord)//CLLocationCoordinate2D(latitude: 34.4044,longitude: -119.6925))
            for i in 0...4 {
                MapView.addAnnotation(Station(name: stationsNearUser[i].name, id: stationsNearUser[i].id, coord: stationsNearUser[i].coord))
            }
            
            //MapView.addAnnotation(station)
            
            
            
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            let latDelta = stationsNearUser[4].coord.latitude - center.latitude
            let lonDelta = stationsNearUser[4].coord.longitude - center.longitude
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 2.2*abs(latDelta), longitudeDelta: 2.2*abs(lonDelta)))
            
            self.MapView.setRegion(region, animated: true)
            shownLocation = true
        }
        
        
        
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
