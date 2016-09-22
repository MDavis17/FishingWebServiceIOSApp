//
//  RestApiManager.swift
//  MVCPractice
//
//  Created by Max Davis on 7/18/16.
//  Copyright © 2016 Max Davis. All rights reserved.
//

import Foundation
import UIKit

class RestApiManager {
    
    func makeHTTPGetRequest(path: String, stationID: String, station: Station, cond: Condition, nextCond: Condition, completion: () -> ()){
        
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: { data, response, error -> Void in
            
            // here my json is put into the 'data' object
            
            var json: [String: AnyObject] // for now I will put my info into a string:object map 'json'
            
            // now use a do-catch to handle the potential exception
            do {
                // put the data into 'json' through the NSJSON Serializer
                json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions() ) as! [String: AnyObject]
                
            }
            catch{
                json = [String: AnyObject]() // back up initialization
                print("error serializing json: \(error)" )
                
            }
            
            // optional binding and setting the variables so they can be used in the UI
            dispatch_async(dispatch_get_main_queue()) {
                
                // updating the current condition variables in the models
                station.setStationID(Int(stationID)!)
                
                if let temp = json["currentTemp"] as! Double? {
                    cond.setTemperature(temp)
                }
                if let tide = json["currentTide"] as! Double? {
                    cond.setTideLevel(tide)
                }
                if let time = json["currentDateTime"] as! String? {
                    cond.setCurrentTime(time)
                }
                if let name = json["stationName"] as! String? {
                    let formattedName = name.stringByReplacingOccurrencesOfString("_", withString: " ")
                    cond.setStation_Name(formattedName)
                    station.setStationName(formattedName)
                }
                if let lat = json["stationLat"] as! Double? {
                    if let lon = json["stationLon"] as! Double? {
                        station.setStationCoord(lat,long: lon)
                    }
                }
                if let status = json["currentTideStatus"] as! String? {
                    
                    cond.setCurrentTideStatus(status)
                    
                    // set the next extreme tide status based on direction indicated by the API
                    switch(status) {
                    case "up", "low":
                        nextCond.setCurrentTideStatus("high")
                        break
                        
                    case "down", "high":
                        nextCond.setCurrentTideStatus("low")
                        break
                        
                    default:
                        break
                    }
                }
                
                // updating the next extreme condition variabes
                if let temp = json["nextTemp"] as! Double? {
                    nextCond.setTemperature(temp)
                }
                if let tide = json["nextExtremeTide"] as! Double? {
                    nextCond.setTideLevel(tide)
                }
                if let time = json["nextExtremeTime"] as! String? {
                    nextCond.setCurrentTime(time)
                }
                
                
                completion()
            }
        })
        task.resume()
    }
    
    func getStationAtIndex(path: String, index: Int, station: Station, completion: () -> ()){
        var currentStationIndex = 0
        
        let request = NSMutableURLRequest(URL: NSURL(string: path)!)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: { data, response, error -> Void in
            
            // here my json is put into the 'data' object
            
            var json: [String: AnyObject] // for now I will put my info into a string:object map 'json'
            
            // now use a do-catch to handle the potential exception
            do {
                // put the data into 'json' through the NSJSON Serializer
                json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions() ) as! [String: AnyObject]
                
            }
            catch{
                json = [String: AnyObject]() // back up initialization
                print("error serializing json: \(error)" )
                
            }
            
            // optional binding and setting the variables so they can be used in the UI
            dispatch_async(dispatch_get_main_queue()) {
                
                if let dict = json as [String: AnyObject]? {
                    if let stations = dict["stations"] as! [AnyObject]? {
                        
                        for info in stations {
                            if(currentStationIndex < index) {
                                currentStationIndex += 1
                                continue
                            }
                            let name = info["name"] as! String?
                            let lat = info["lat"] as! Double?
                            let lon = info["lon"] as! Double?
                            let id = info["id"] as! Int?
                            station.setStationName(name!)
                            station.setStationCoord(lat!, long: lon!)
                            station.setStationID(id!)
                            
                            break
                            
                        }
                    }
                }
                
                /*
                if let stationsArray = json["stations"] as! NSArray? {
                }
                
                if let name = json["name"] as! String? {
                    station.setStationName(name)
                }
                if let lat = json["lat"] as! Double? {
                    if let lon = json["lon"] as! Double? {
                        station.setStationCoord(lat, long: lon)
                    }
                }
                if let id = json["id"] as! Int? {
                    station.setStationID(id)
                }
                //if let state = json["state"] as! String? {
                    
                //}
                */
                
                completion()
            }
        })
        task.resume()
    }
    
}