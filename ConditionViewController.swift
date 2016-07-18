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
    var nextCond = Condition()
    let sharedInstance = RestApiManager()
    
    //var currentTemp = Double()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // automatically update the temperature and tide values
        HTTPInteract()
    }
    
    func HTTPInteract() {
        activityIndicator.startAnimating()
        sharedInstance.makeHTTPGetRequest("http://fishingwebservice.cfapps.io/current",cond: cond, nextCond: nextCond) {() in
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
            
            //update next extreme values
            //self.ExTempValueLabel.text = String(self.nextCond.getTemp())
            self.ExTideValueLabel.text = String(self.nextCond.getTide())+" ft"
            self.ExTimeValueLabel.text = self.nextCond.getCurrentTime()
            self.ExTideStatusValueLabel.text = self.nextCond.getTideStatus()
            self.ExTideStatusImg.image = UIImage(named: self.nextCond.getTideStatus())
        }
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
    
    // next extreme condition variables
    @IBOutlet weak var ExTimeValueLabel: UILabel!
    @IBOutlet weak var ExTempValueLabel: UILabel!
    @IBOutlet weak var ExTideValueLabel: UILabel!
    @IBOutlet weak var ExTideStatusValueLabel: UILabel!
    @IBOutlet weak var ExTideStatusImg: UIImageView!
    
    // Mark: Actions
    
    @IBAction func updateValues(sender: UISwipeGestureRecognizer) {
        HTTPInteract()
    }
    
}

