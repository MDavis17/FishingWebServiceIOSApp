//
//  Condition.swift
//  MVCPractice
//
//  Created by Max Davis on 7/15/16.
//  Copyright © 2016 Max Davis. All rights reserved.
//

import Foundation
import UIKit

class Condition : UIView{
    var temp = Double(0) {
        didSet {
            setNeedsLayout()
        }
    }
    var tide = Double(0) {
        didSet {
            setNeedsLayout()
        }
    }
    var time = " " {
        didSet {
            setNeedsLayout()
        }
    }
    var tideStatus = " " {
        didSet {
            setNeedsLayout()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        // arbitrary initialization of the UIView superclass object
        super.init(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    }
    
    func getTemp() -> Double {
        return temp
    }
    func getTide() -> Double {
        return tide
    }
    func getTideStatus() -> String {
        return tideStatus
    }
    func getCurrentTime() -> String {
        return time
    }
    
    func setTemperature(value: Double) {
        temp = value
    }
    func setTideLevel(value: Double) {
        tide = value
    }
    func setCurrentTime(value: String) {
        time = value
    }
    func setCurrentTideStatus(value: String) {
        tideStatus = value
    }
    
}