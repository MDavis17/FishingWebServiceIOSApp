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
    
    func makeHTTPGetRequest(path: String, cond: Condition, nextCond: Condition, completion: () -> ()){
        
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
                
                // updating the current condition variables in the model
                if let temp = json["currentTemp"] as! Double? {
                    cond.setTemperature(temp)
                }
                if let tide = json["currentTide"] as! Double? {
                    cond.setTideLevel(tide)
                }
                if let time = json["currentDateTime"] as! String? {
                    cond.setCurrentTime(time)
                }
                if let status = json["currentTideStatus"] as! String? {
                    cond.setCurrentTideStatus(status)
                }
                
                // updating the next extreme condition variabes
                /*
                if let temp = json["currentTemp"] as! Double? {
                    nextCond.setTemperature(temp)
                }*/
                if let tide = json["nextExtremeTide"] as! Double? {
                    nextCond.setTideLevel(tide)
                }
                if let time = json["nextExtremeTime"] as! String? {
                    nextCond.setCurrentTime(time)
                }
                /*
                if let status = json["currentTideStatus"] as! String? {
                    nextCond.setCurrentTideStatus(status)
                }*/
                
                completion()
            }
        })
        task.resume()
    }
    
}