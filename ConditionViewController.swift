//
//  ViewController.swift
//  MVCPractice
//
//  Created by Max Davis on 7/15/16.
//  Copyright © 2016 Max Davis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var cond = Condition()
    
    //var currentTemp = Double()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var tempValueLabel: UILabel!
    @IBOutlet weak var tideValueLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    @IBAction func changeTemp(sender: AnyObject) {
        cond.incNum()
        tempLabel.text = String(cond.getNum())

        makeHTTPGetRequest("http://fishingwebservice.cfapps.io/current") {() in
            self.tempValueLabel.text = String(self.cond.getTemp())
            self.tideValueLabel.text = String(self.cond.getTide())
        }
    }
    
    func makeHTTPGetRequest(path: String, completion: () -> ()){
        
        activityIndicator.startAnimating()
        
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
            
                self.activityIndicator.stopAnimating()
                
                // updating the variables in the model
                if let temp = json["currentTemp"] as! Double? {
                    self.cond.setTemperature(temp)
                }
                if let tide = json["currentTide"] as! Double? {
                    self.cond.setTideLevel(tide)
                }
                completion()
            }
        })
        task.resume()
    }
}

