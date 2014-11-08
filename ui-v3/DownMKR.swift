//
//  DownMKR.swift
//  ui-v3
//
//  Created by grobinson on 11/4/14.
//  Copyright (c) 2014 wambl. All rights reserved.
//

import UIKit

class DownMKR: UIView {

    @IBOutlet weak var Line: UIView!
    
    init(frame: CGRect,type: String) {
        super.init(frame: frame)
        
        switch type {
        case "fd":
            Line.backgroundColor = UIColor.yellowColor()
        default:
            Line.backgroundColor = UIColor.blueColor()
        }
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
