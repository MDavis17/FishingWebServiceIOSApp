//
//  StationViewController.swift
//  FishingWebServiceIOS
//
//  Created by Max Davis on 8/26/16.
//  Copyright © 2016 Max Davis. All rights reserved.
//

import UIKit
import MapKit

class StationViewController: UIViewController {
    var Lat = 0.0
    var Long = 0.0
    var station: Station?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stationNameLabel.text = station!.name
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var stationNameLabel: UILabel!

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
