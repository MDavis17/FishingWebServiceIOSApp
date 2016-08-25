//
//  Station.swift
//  FishingWebServiceIOS
//
//  Created by Max Davis on 8/18/16.
//  Copyright © 2016 Max Davis. All rights reserved.
//

import Foundation
import MapKit

class Station: NSObject, MKAnnotation {
    
    var name : String
    var id : Int
    var coord : CLLocationCoordinate2D
    //var distance : Double
    
    init(name: String, id: Int, coord: CLLocationCoordinate2D) {
        self.name = name
        self.id = id
        self.coord = coord
        super.init()
    }
    
    // setting subtitle to the id of the station
    var subtitle: String? {
        return String(id)
    }
    
    var title: String? {
        return name
    }
    var coordinate: CLLocationCoordinate2D {
        return coord
    }
    
    func setStationName(name: String) {
        self.name = name
    }
    func setStationID(id: Int) {
        self.id = id
    }
    func setStationCoord(lat: Double, long: Double) {
        self.coord = CLLocationCoordinate2D(latitude: lat,longitude: long)
    }
    
    /*
    func getDistanceToStation() -> Double {
        
    }*/
}