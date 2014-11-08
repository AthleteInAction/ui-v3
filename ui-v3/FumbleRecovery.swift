//
//  FumbleReturn.swift
//  ui-v3
//
//  Created by grobinson on 11/7/14.
//  Copyright (c) 2014 wambl. All rights reserved.
//

import UIKit

class FumbleRecovery: UIViewController, UIPopoverControllerDelegate, NumSelDG {
    
    // ITEMS
    // ))))))))))))))))))))))))))))))))))))))))))))))))
    // ))))))))))))))))))))))))))))))))))))))))))))))))
    @IBOutlet weak var leftLBL: UIButton!
    @IBOutlet weak var rightLBL: UIButton!
    @IBOutlet weak var numSelGD: UIView!
    @IBOutlet weak var tackSelGD: UIView!
    @IBOutlet weak var tackNumGD: UIView!
    @IBOutlet weak var returnSW: UISwitch!
    @IBOutlet weak var doneBTN: UIButton!
    @IBOutlet weak var deleteBTN: UIButton!
    
    var colors = Colors()
    
    var dg: AddPlayDel!
    
    var entry: Entry!
    
    var numSel: NumberSelector!
    var tackSel: NumberSelector!
    
    var tackles: [UIButton] = []
    // ))))))))))))))))))))))))))))))))))))))))))))))))
    // ))))))))))))))))))))))))))))))))))))))))))))))))

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.clearColor()
        
        numSel = NumberSelector(frame: CGRect(x: numSelGD.center.x-(numSelGD.bounds.width/2), y: numSelGD.center.y-(numSelGD.bounds.height/2), width: numSelGD.bounds.width, height: numSelGD.bounds.height))
        numSel.dg = self
        numSel.title = "recoverer"
        view.addSubview(numSel)
        
        tackSel = NumberSelector(frame: CGRect(x: tackSelGD.center.x-(tackSelGD.bounds.width/2), y: tackSelGD.center.y-(tackSelGD.bounds.height/2), width: tackSelGD.bounds.width, height: tackSelGD.bounds.height))
        tackSel.dg = self
        tackSel.title = "tackle"
        view.addSubview(tackSel)
        
        returnSW.on = false
        
        doneBTN.hidden = true
        deleteBTN.hidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    // POPOVER ITEMS
    // ================================================
    // ================================================
    func popoverControllerShouldDismissPopover(popoverController: UIPopoverController) -> Bool {
        
        self.dismissViewControllerAnimated(false, completion: nil)
        
        return true
        
    }
    func popoverControllerDidDismissPopover(popoverController: UIPopoverController) {
        
        dg.popCancelled()
        
    }
    // ================================================
    // ================================================
    
    
    
    // ACTIONS
    // ++++++++++++++++++++++++++++++++++++++++++++++++
    // ++++++++++++++++++++++++++++++++++++++++++++++++
    func numberSelected(item: UITapGestureRecognizer, title: String) {
        
        switch title {
        case "recoverer":
            entry.data.player_a = item.view!.tag
        case "tackle":
            entry.data.tackles.append(item.view!.tag)
            updateTackles()
        default:
            NSLog("ERROR")
        }
        
        checkStatus()
        
    }
    
    
    func updateTackles(){
        
        removeTackles()
        
        tackles = []
        
        var i = 0
        for tackle in entry.data.tackles {
            
            var new_x = CGFloat(i * 44) + (tackNumGD.center.x-(tackNumGD.bounds.width/2)) + 4
            
            var t = UIButton(frame: CGRect(x: new_x, y: tackNumGD.center.y-(tackNumGD.bounds.height/2), width: 40, height: 30))
            t.backgroundColor = UIColor.grayColor()
            t.setTitle("\(tackle)", forState: UIControlState.Normal)
            t.tag = i
            
            var tap = UITapGestureRecognizer()
            tap.numberOfTapsRequired = 2
            tap.addTarget(self, action: "deleteTackle:")
            
            t.addGestureRecognizer(tap)
            
            tackles.append(t)
            view.addSubview(tackles.last!)
            
            i++
            
        }
        
    }
    func removeTackles(){
        
        for tackle in tackles {
            
            tackle.removeFromSuperview()
            
        }
        
    }
    func deleteTackle(item: UITapGestureRecognizer){
        
        entry.data.tackles.removeAtIndex(item.view!.tag)
        
        updateTackles()
        
    }
    
    
    
    @IBAction func leftTAP(sender: AnyObject) {
        
        entry.data.team_id = "LHS"
        leftLBL.backgroundColor = colors.orange
        rightLBL.backgroundColor = colors.light_grey
        
        checkStatus()
        
    }
    
    
    
    @IBAction func rightTap(sender: AnyObject) {
        
        entry.data.team_id = "WG"
        leftLBL.backgroundColor = colors.light_grey
        rightLBL.backgroundColor = colors.orange
        
        checkStatus()
        
    }

    
    
    @IBAction func returnChanged(sender: AnyObject) {
        
        
        
    }
    
    
    
    @IBAction func doneTAP(sender: AnyObject) {
        
        if returnSW.on {
            
            dg.addReturn(entry)
            
        } else {
            
            dg.addEntry(entry)
            
        }
        
    }
    
    
    
    @IBAction func deleteTAP(sender: AnyObject) {
        
        dg.deleteEntry(entry)
        
    }
    
    
    
    func checkStatus(){
        
        if entry.data.player_a != nil && entry.data.team_id != nil {
            doneBTN.hidden = false
            deleteBTN.hidden = false
        } else {
            doneBTN.hidden = true
            deleteBTN.hidden = true
        }
        
    }
    // ++++++++++++++++++++++++++++++++++++++++++++++++
    // ++++++++++++++++++++++++++++++++++++++++++++++++
    
}
