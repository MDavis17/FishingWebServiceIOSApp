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
    let sharedInstance = RestApiManager()
    
    //var currentTemp = Double()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // automatically update the temperature and tide values
        activityIndicator.startAnimating()
        sharedInstance.makeHTTPGetRequest("http://fishingwebservice.cfapps.io/current",cond: cond) {() in
            self.activityIndicator.stopAnimating()
            self.tempValueLabel.text = String(self.cond.getTemp())
            self.tideValueLabel.text = String(self.cond.getTide())
            self.TimeValueLabel.text = self.cond.getCurrentTime()
            self.TideStatusValueLabel.text = self.cond.getTideStatus()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBOutlet weak var TideStatusValueLabel: UILabel!
    @IBOutlet weak var TimeValueLabel: UILabel!
    @IBOutlet weak var tempValueLabel: UILabel!
    @IBOutlet weak var tideValueLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
}

