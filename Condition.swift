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
    var num = 0
    var tide = Double(0) {
        didSet {
            setNeedsLayout()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        num = 0
        temp = 0
        tide = 0
        // arbitrary initialization of the UIView superclass object
        super.init(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    }
    
    func getNum() -> Int {
        return num
    }
    
    func getTemp() -> Double {
        return temp
    }
    
    func getTide() -> Double {
        return tide
    }
    
    func setNumber(value: Int) {
        num = value
    }
    
    func setTemperature(value: Double) {
        temp = value
    }
    
    func setTideLevel(value: Double) {
        tide = value
    }
    
    func incNum() -> Void {
        num += 1
    }
    
}