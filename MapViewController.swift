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
    
    let locationManager = CLLocationManager()
    
    func showLocation() {
        MapView.showsUserLocation = true
        let coord = MapView.userLocation.coordinate
        let lat = coord.latitude
        
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //showLocation()
        
        /*
        if(locationManager.requestAlwaysAuthorization) {
            print("location services on")
        }
        else {
            print("location services off")
        }*/
        
        // Ask for Authorisation from the User.
        locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }

        
        // Do any additional setup after loading the view.
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        let location = locations.last! as CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.MapView.setRegion(region, animated: true)
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
