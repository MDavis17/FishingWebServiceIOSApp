//
//  ViewController.swift
//  MVCPractice
//
//  Created by Max Davis on 7/15/16.
//  Copyright © 2016 Max Davis. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var cond = Condition()
    var nextCond = Condition()
    let sharedInstance = RestApiManager()
    var numberOfDelays = 0
    var stationID = "";
    var startingCoord = CLLocationCoordinate2D()
    var scrollView: UIScrollView!
    var currentStation = Station(name: "",id: 0,coord: CLLocationCoordinate2D())
    var closestStations = [Station]()
    let locationManager = CLLocationManager()
    var newSession = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        // san francisco testing location
        startingCoord = CLLocationCoordinate2D(latitude: 37.780205, longitude: -122.422496)
        // santa barbara testing location
        //startingCoord = CLLocationCoordinate2D(latitude: 34.398, longitude: -119.703)
        // hawaii testing location
        //startingCoord = CLLocationCoordinate2D(latitude: 21.300829, longitude: -158.060879)
        //startingCoord = CLLocationCoordinate2D(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
        
        for i in 0...4 {
            closestStations.append(Station(name: "",id: 0,coord: CLLocationCoordinate2D()))
        }
        
        fillStations(startingCoord.latitude, Long: startingCoord.longitude)
        
        sharedInstance.getStationAtIndex("http://fishingwebservice.cfapps.io/stationsearch/"+String(startingCoord.latitude)+","+String(startingCoord.longitude), index: 0, station: currentStation) {() in
            self.stationID = String(self.currentStation.id)
            self.HTTPInteract(self.stationID)
            //self.newSession = false
        }
        

        // alert the user if the displayed data is old, but only execute the completion hander when theres only one delay running
        delay(361.0) {
            if(self.numberOfDelays <= 1) {
                self.staleDataLabel.hidden = false
            }
            self.numberOfDelays -= 1
        }
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator:UIViewControllerTransitionCoordinator) {
        if(UIDevice.currentDevice().orientation.isLandscape) {
            conditionStack.axis = .Horizontal
            conditionStack.spacing = 25
        }
        else {
            conditionStack.axis = .Vertical
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if( segue.identifier == "MapSegue") {
            let mvc = segue.destinationViewController as! MapViewController
            
            mvc.closestStation = currentStation
            mvc.stationsNearUser = closestStations
        }
    }
    
    /*func getIDFromCoord(Lat: Double, Long: Double) -> Int {
        sharedInstance.getStationAtIndex("http://fishingwebservice.cfapps.io/stationsearch/"+String(Lat)+","+String(Long),index: 0,station: currentStation) {() in
            return self.currentStation.id
        }
        return -1
    }*/
    
    func fillStations(Lat: Double, Long: Double) {
        // TODO clean up this messy hard coding
        
        var temp1 = Station(name: "",id: 0,coord: CLLocationCoordinate2D())
        var temp2 = Station(name: "",id: 0,coord: CLLocationCoordinate2D())
        var temp3 = Station(name: "",id: 0,coord: CLLocationCoordinate2D())
        var temp4 = Station(name: "",id: 0,coord: CLLocationCoordinate2D())
        var temp5 = Station(name: "",id: 0,coord: CLLocationCoordinate2D())
        
        
        sharedInstance.getStationAtIndex("http://fishingwebservice.cfapps.io/stationsearch/"+String(Lat)+","+String(Long),index: 0,station: temp1) {() in
            self.closestStations[0] = temp1
        }
        sharedInstance.getStationAtIndex("http://fishingwebservice.cfapps.io/stationsearch/"+String(Lat)+","+String(Long),index: 1,station: temp2) {() in
            self.closestStations[1] = temp2
        }
        sharedInstance.getStationAtIndex("http://fishingwebservice.cfapps.io/stationsearch/"+String(Lat)+","+String(Long),index: 2,station: temp3) {() in
            self.closestStations[2] = temp3
        }
        sharedInstance.getStationAtIndex("http://fishingwebservice.cfapps.io/stationsearch/"+String(Lat)+","+String(Long),index: 3,station: temp4) {() in
            self.closestStations[3] = temp4
        }
        sharedInstance.getStationAtIndex("http://fishingwebservice.cfapps.io/stationsearch/"+String(Lat)+","+String(Long),index: 4,station: temp5) {() in
            self.closestStations[4] = temp5
        }
        
    }
    
    func HTTPInteract(ID: String) {
        activityIndicator.startAnimating()
        sharedInstance.makeHTTPGetRequest("http://fishingwebservice.cfapps.io/current/"+ID, stationID: ID, station: currentStation, cond: cond, nextCond: nextCond) {() in
            self.activityIndicator.stopAnimating()
            
            // update current values
            self.tempValueLabel.text = String(self.cond.getTemp())+"°F"
            self.tideValueLabel.text = String(self.cond.getTide())+" ft"
            self.timeValueLabel.text = self.cond.getCurrentTime()
            
            
            let status = self.cond.getTideStatus()
            switch(status) {
            case "up" :
                self.tideStatusImg.image = UIImage(named: "up")
                self.tideStatusValueLabel.text = "rising"
                break
            case "down" :
                self.tideStatusImg.image = UIImage(named: "down")
                self.tideStatusValueLabel.text = "receding"
                break
            case "high" :
                self.tideStatusImg.image = UIImage(named: "high")
                break
            case "low" :
                self.tideStatusImg.image = UIImage(named: "low")
                break
            default :
                self.tideStatusValueLabel.text = status
                break
            }
            self.StationNameTitle.title = self.cond.getStation_Name()
            
            //update next extreme values
            self.ExTempValueLabel.text = String(self.nextCond.getTemp())+"°F"
            self.ExTideValueLabel.text = String(self.nextCond.getTide())+" ft"
            self.ExTimeValueLabel.text = self.nextCond.getCurrentTime()
            self.ExTideStatusValueLabel.text = self.nextCond.getTideStatus()
            self.ExTideStatusImg.image = UIImage(named: self.nextCond.getTideStatus())
        }
    }
    
    // this will help with alerting the user if the data shown on the screen is old data
    func delay(delay: Double, completion: ()->()) {
        numberOfDelays += 1
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), completion)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // current condition variables
    @IBOutlet weak var timeValueLabel: UILabel!
    @IBOutlet weak var tempValueLabel: UILabel!
    @IBOutlet weak var tideValueLabel: UILabel!
    @IBOutlet weak var tideStatusValueLabel: UILabel!
    @IBOutlet weak var tideStatusImg: UIImageView!
    
    @IBOutlet weak var StationNameTitle: UINavigationItem!
    
    
    // next extreme condition variables
    @IBOutlet weak var ExTimeValueLabel: UILabel!
    @IBOutlet weak var ExTempValueLabel: UILabel!
    @IBOutlet weak var ExTideValueLabel: UILabel!
    @IBOutlet weak var ExTideStatusValueLabel: UILabel!
    @IBOutlet weak var ExTideStatusImg: UIImageView!
    
    @IBOutlet weak var staleDataLabel: UILabel!
    
    @IBOutlet weak var stationIDTextField: UITextField!
    
    //var refreshControl: UIRefreshControl!
    
    
    @IBOutlet weak var mainStack: UIStackView!
    @IBOutlet weak var conditionStack: UIStackView!
    // Mark: Actions
    
    /*
     //currently dissabled
    @IBAction func updateValues(sender: UIScreenEdgePanGestureRecognizer) {
        HTTPInteract(stationID)
        
        staleDataLabel.hidden = true
        
        delay(361.0) {
            if(self.numberOfDelays <= 1) {
                self.staleDataLabel.hidden = false
            }
            self.numberOfDelays -= 1
        }
    }*/
    
    /*
     //currently dissabled
    @IBAction func updateValues(sender: UISwipeGestureRecognizer) {
        HTTPInteract(stationID)

        staleDataLabel.hidden = true
        
        delay(361.0) {
            if(self.numberOfDelays <= 1) {
                self.staleDataLabel.hidden = false
            }
            self.numberOfDelays -= 1
        }
    }*/
    
    @IBAction func buttonUpdate(sender: AnyObject) {
        HTTPInteract(stationID)
        
        staleDataLabel.hidden = true
        
        delay(361.0) {
            if(self.numberOfDelays <= 1) {
                self.staleDataLabel.hidden = false
            }
            self.numberOfDelays -= 1
        }
    }
    
    @IBAction func reqWithID(sender: AnyObject) {
        if(Int(stationIDTextField.text!) != nil && Int(stationIDTextField.text!) > 999999) {
            stationID = stationIDTextField.text!
            stationIDTextField.resignFirstResponder()
            HTTPInteract(stationID)
            staleDataLabel.hidden = true
            // alert the user if the displayed data is old, but only execute the completion hander when theres only one delay running
            delay(361.0) {
                if(self.numberOfDelays <= 1) {
                    self.staleDataLabel.hidden = false
                }
                self.numberOfDelays -= 1
            }
        }
    }
    
}

