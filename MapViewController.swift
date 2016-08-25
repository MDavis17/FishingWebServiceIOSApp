//
//  MapViewController.swift
//  FishingWebServiceIOS
//
//  Created by Max Davis on 8/16/16.
//  Copyright © 2016 Max Davis. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var MapView: MKMapView!
    
    var shownLocation = false
    var currentUserLat = 0.0
    var currentUserLong = 0.0
    var closestStation = Station(name: "",id: 0,coord: CLLocationCoordinate2D())
    
    
    var locationManager = CLLocationManager()
    
    func setUserLocation(lat: Double, lon: Double) {
        currentUserLat = lat
        currentUserLong = lon
    }
    
    func setClosest_Station(st: Station) {
        closestStation = st
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        let location = locations.last! as CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        
        if !shownLocation {
            setUserLocation(location.coordinate.latitude,lon: location.coordinate.longitude)
            let station = Station(name: closestStation.name, id: closestStation.id, coord: closestStation.coord)//CLLocationCoordinate2D(latitude: 34.4044,longitude: -119.6925))
            MapView.addAnnotation(station)
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
