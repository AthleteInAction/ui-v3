//
//  DriveClass.swift
//  ui-v3
//
//  Created by grobinson on 11/5/14.
//  Copyright (c) 2014 wambl. All rights reserved.
//

import Foundation
import UIKit


class Drive {
    
    var drive_type: String!
    var score: String = "_"
    var qtr: Int!
    var plays: [Play] = []
    
    init(){}
    
}


class Play {
    
    var play_type: String!
    var qtr: Int!
    var down: Int!
    var togo: Int!
    var score: String = "_"
    var entries: [Entry] = []
    
    init(){}
    
}


class Data {
    
    var team_id: String!
    var play_type: String!
    var play_key: String!
    var start_point: Int!
    var end_point: Int!
    var gain: Int!
    var score: String = "_"
    var player_a: Int!
    var player_b: Int!
    var tackles: [Int] = []
    var sacks: [Int] = []
    var fumble: Bool = false
    
    init(){}
    
}


class Entry: UIView {
    
    var colors: Colors = Colors()
    
    var selected: Bool = false
    
    var data: Data = Data()
    
    var onColor: UIColor!
    var offColor: UIColor!
    
    init(frame: CGRect,type: String) {
        super.init(frame: frame)
        
        data.play_key = type
        
        switch type {
        case "fumble_recovery":
            offColor = colors.fumRetOff
            onColor = colors.fumRetOn
        case "pass":
            offColor = colors.passOff
            onColor = colors.passOn
        case "run":
            offColor = colors.runOff
            onColor = colors.runOn
        case "kick":
            offColor = colors.kickOff
            onColor = colors.kickOn
        case "return":
            offColor = colors.returnOff
            onColor = colors.returnOn
        default:
            offColor = UIColor.blackColor()
            onColor = UIColor.blackColor()
        }
        
        self.backgroundColor = offColor
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func selectEntry(){
        
        self.backgroundColor = onColor
        
    }
    func deselectEntry(){
        
        self.backgroundColor = offColor
        
    }
    
}