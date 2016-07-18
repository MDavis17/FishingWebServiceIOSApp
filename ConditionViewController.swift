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
        activityIndicator.startAnimating()
        sharedInstance.makeHTTPGetRequest("http://fishingwebservice.cfapps.io/current",cond: cond, nextCond: nextCond) {() in
            self.activityIndicator.stopAnimating()
            
            // update current values
            self.tempValueLabel.text = String(self.cond.getTemp())
            self.tideValueLabel.text = String(self.cond.getTide())
            self.timeValueLabel.text = self.cond.getCurrentTime()
            self.tideStatusValueLabel.text = self.cond.getTideStatus()
            
            //update next extreme values
            //self.ExTempValueLabel.text = String(self.nextCond.getTemp())
            self.ExTideValueLabel.text = String(self.nextCond.getTide())
            self.ExTimeValueLabel.text = self.nextCond.getCurrentTime()
            self.ExTideStatusValueLabel.text = self.nextCond.getTideStatus()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // current condition variables
    @IBOutlet weak var timeValueLabel: UILabel!
    @IBOutlet weak var tempValueLabel: UILabel!
    @IBOutlet weak var tideValueLabel: UILabel!
    @IBOutlet weak var tideStatusValueLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // next extreme condition variables
    @IBOutlet weak var ExTimeValueLabel: UILabel!
    @IBOutlet weak var ExTempValueLabel: UILabel!
    @IBOutlet weak var ExTideValueLabel: UILabel!
    @IBOutlet weak var ExTideStatusValueLabel: UILabel!
    
    
}

