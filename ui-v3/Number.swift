//
//  Number.swift
//  field-build
//
//  Created by grobinson on 10/27/14.
//  Copyright (c) 2014 wambl. All rights reserved.
//

import UIKit


class Number: UIView {
    
    var number: Int!
    var animator: UIDynamicAnimator!
    var snaps = [UISnapBehavior]()
    var numberTXT: UILabel!
    var numberColor: UIColor = UIColor(red: 135/255, green: 135/255, blue: 135/255, alpha: 1.0)
    
    init(frame: CGRect,n: Int) {
        super.init(frame: frame)
        
        self.backgroundColor = numberColor
        
        number = n
        
        numberTXT = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        numberTXT.text = "\(n)"
        numberTXT.textColor = UIColor.whiteColor()
        self.addSubview(numberTXT)
        numberTXT.textAlignment = .Center
        
        var shield = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        self.addSubview(shield)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        
        
    }
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        
        
        
    }
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        
        
        
    }
    
}