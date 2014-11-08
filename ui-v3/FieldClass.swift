//
//  FieldClass.swift
//  ui-v3
//
//  Created by grobinson on 11/4/14.
//  Copyright (c) 2014 wambl. All rights reserved.
//

import UIKit

protocol FieldDel {
    
    func mkrDragged(item: UIPanGestureRecognizer)
    func fieldTouchesBegan(touches: NSSet,event: UIEvent)
    func fieldTouchesMoved(touches: NSSet,event: UIEvent)
    func fieldTouchesEnded(touches: NSSet,event: UIEvent)
    func fieldTouchesCancelled(touches: NSSet,event: UIEvent)
    
}

class FieldClass: UIView {
    
    // ITEMS
    // --------------------------------------------------
    // --------------------------------------------------
    var dg: FieldDel!
    
    var RATIO: CGFloat!
    
    var MKR_A: UIView!
    var MKR_B: UIView!
    
    var L_ENDZONE: UIView!
    var R_ENDZONE: UIView!
    
    var L: Bool = false
    var R: Bool = true
    
    var HLINE: UIView!
    var VLINE: UIView!
    var ELINE: UIView!
    
    var RLINE: UIView!
    
    var PLAYLINE: CGFloat!
    // --------------------------------------------------
    // --------------------------------------------------
    
    
    
    // INIT
    // **************************************************
    // **************************************************
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        RATIO = self.bounds.width / 120
        
        self.backgroundColor = UIColor.clearColor()
        
        var bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        bg.image = UIImage(named: "field_v3")
        self.addSubview(bg)
        
        VLINE = UIView(frame: CGRect(x: 0, y: 0, width: 4, height: self.bounds.height+1))
        VLINE.backgroundColor = UIColor.whiteColor()
        VLINE.alpha = 0.8
        VLINE.hidden = true
        self.addSubview(VLINE)
        
        HLINE = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.width+1, height: 2))
        HLINE.backgroundColor = UIColor.whiteColor()
        HLINE.alpha = 0.8
        HLINE.hidden = true
        self.addSubview(HLINE)
        
        ELINE = UIView(frame: CGRect(x: 0, y: 0, width: (14 * RATIO), height: self.bounds.height))
        ELINE.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.2)
        ELINE.hidden = true
        self.addSubview(ELINE)
        
        RLINE = UIView(frame: CGRect(x: 0, y: 0, width: 2, height: self.bounds.height+1))
        RLINE.backgroundColor = UIColor.redColor()
        RLINE.alpha = 0.5
        RLINE.hidden = true
        self.addSubview(RLINE)
        
        L_ENDZONE = UIView(frame: CGRect(x: 0, y: 0, width: (RATIO * 10), height: self.bounds.height))
        L_ENDZONE.backgroundColor = UIColor.clearColor()
        self.addSubview(L_ENDZONE)
        
        R_ENDZONE = UIView(frame: CGRect(x: (RATIO * 110), y: 0, width: (RATIO * 10), height: self.bounds.height))
        R_ENDZONE.backgroundColor = UIColor.clearColor()
        self.addSubview(R_ENDZONE)
        
        var pan = UIPanGestureRecognizer()
        pan.addTarget(self, action: "mkrDragged:")
        MKR_A = UIView(frame: CGRect(x: gotoYard(L, yard: 20)-7, y: 0, width: 14, height: self.bounds.height))
        MKR_A.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        MKR_A.addGestureRecognizer(pan)
        var line = UIView(frame: CGRect(x: 6, y: 0, width: 2, height: MKR_A.bounds.height))
        line.backgroundColor = UIColor.blueColor()
        MKR_A.addSubview(line)
        self.addSubview(MKR_A)
        PLAYLINE = MKR_A.center.x
        
        pan = UIPanGestureRecognizer()
        pan.addTarget(self, action: "mkrDragged:")
        MKR_B = UIView(frame: CGRect(x: gotoYard(L, yard: 30)-7, y: 0, width: 14, height: self.bounds.height))
        MKR_B.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        MKR_B.addGestureRecognizer(pan)
        line = UIView(frame: CGRect(x: 6, y: 0, width: 2, height: MKR_B.bounds.height))
        line.backgroundColor = UIColor.yellowColor()
        MKR_B.addSubview(line)
        self.addSubview(MKR_B)
        
    }
    // **************************************************
    // **************************************************
    
    
    
    // TOUCHES
    // ))))))))))))))))))))))))))))))))))))))))))))))))))
    // ))))))))))))))))))))))))))))))))))))))))))))))))))
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        dg.fieldTouchesBegan(touches, event: event)
        
    }
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        
        dg.fieldTouchesMoved(touches, event: event)
        
    }
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        
        dg.fieldTouchesEnded(touches, event: event)
        
    }
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        
        dg.fieldTouchesCancelled(touches, event: event)
        
    }
    // ))))))))))))))))))))))))))))))))))))))))))))))))))
    // ))))))))))))))))))))))))))))))))))))))))))))))))))
    
    
    
    // MARKER DRAGGED
    // ++++++++++++++++++++++++++++++++++++++++++++++++++
    // ++++++++++++++++++++++++++++++++++++++++++++++++++
    func mkrDragged(item: UIPanGestureRecognizer){
        
        let l: CGPoint = item.locationInView(self)
        var new_x = snap(l.x)
        
        if l_yard(new_x) >= 1 && l_yard(new_x) <= 99 {
            item.view?.center.x = new_x
        }
        
        dg.mkrDragged(item)
        
    }
    // ++++++++++++++++++++++++++++++++++++++++++++++++++
    // ++++++++++++++++++++++++++++++++++++++++++++++++++
    
    
    
    // CURSOR
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    func moveCursor(point: CGPoint){
        
        showCursor()
        
        HLINE.center.y = point.y
        if point.y < 10 {
            HLINE.center.y = 10
        }
        if point.y > self.bounds.height-10 {
            HLINE.center.y = self.bounds.height-10
        }
        
        VLINE.center.x = snap(point.x)
        if pixel(point.x) <= 1 {
            VLINE.center.x = yard(1)
        }
        if pixel(point.x) >= 119 {
            VLINE.center.x = yard(119)
        }
        
    }
    func moveRecoveryCursor(x: CGFloat){
        
        showRecoveryCursor()
        RLINE.center.x = snap(x)
        
    }
    func showRecoveryCursor(){
        
        RLINE.hidden = false
        
    }
    func hideRecoveryCursor(){
        
        RLINE.hidden = true
        
    }
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    func hideCursor(){
        
        HLINE.hidden = true
        VLINE.hidden = true
        
    }
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    func showCursor(){
        
        HLINE.hidden = false
        VLINE.hidden = false
        
    }
    func showELINE(point: CGPoint){
        
        ELINE.center.x = point.x
        ELINE.hidden = false
        
    }
    func hideELINE(){
        
        ELINE.hidden = true
        
    }
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    
    
    // HELPERS
    // >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    // >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    func yard(x: CGFloat) -> CGFloat {
        
        var pixels = snap(x * RATIO)
        
        return pixels
        
    }
    func snap(x: CGFloat) -> CGFloat {
        
        var snap_x = round(x/RATIO)*RATIO
        
        return snap_x
        
    }
    func l_yard(x: CGFloat) -> Int {
        
        var new_x = Int(round(snap(x) / RATIO)) - 10
        
        return new_x
        
    }
    func gotoYard(side: Bool,yard: Int) -> CGFloat {
        
        var new_x = round(CGFloat(yard+10) * RATIO)
        
        if side {
            
            new_x = round(CGFloat((50-yard)+60) * RATIO)
            
        }
        
        return new_x
        
    }
    func pixel(x: CGFloat) -> CGFloat {
        
        var yard = x / RATIO
        
        return yard
        
    }
    // >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    // >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

}
