//
//  PassPopover.swift
//  ui-v3
//
//  Created by grobinson on 11/6/14.
//  Copyright (c) 2014 wambl. All rights reserved.
//

import UIKit

class PassPopover: UIViewController, UIPopoverControllerDelegate, NumSelDG {
    
    // ITEMS
    // ))))))))))))))))))))))))))))))))))))))))))))))))
    // ))))))))))))))))))))))))))))))))))))))))))))))))
    var dg: AddPlayDel!
    
    var edit_mode: Bool = false
    
    var colors = Colors()
    
    @IBOutlet weak var qbGD: UIView!
    @IBOutlet weak var receiverGD: UIView!
    @IBOutlet weak var tackleGD: UIView!
    @IBOutlet weak var tackleNumGD: UIView!
    @IBOutlet weak var fumbleSW: UISwitch!
    @IBOutlet weak var doneBTN: UIButton!
    @IBOutlet weak var deleteBTN: UIButton!
    
    var entry: Entry!
    
    var qbSel: NumberSelector!
    var receiverSel: NumberSelector!
    var tackleSel: NumberSelector!
    
    var tackles: [UIButton] = []
    // ))))))))))))))))))))))))))))))))))))))))))))))))
    // ))))))))))))))))))))))))))))))))))))))))))))))))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clearColor()
        
        fumbleSW.on = false
        doneBTN.hidden = true
        deleteBTN.hidden = true
        
        qbSel = NumberSelector(frame: CGRect(x: qbGD.center.x-(qbGD.bounds.width/2), y: qbGD.center.y-(qbGD.bounds.height/2), width: qbGD.bounds.width, height: qbGD.bounds.height))
        view.addSubview(qbSel)
        qbSel.backgroundColor = colors.popOverPass
        qbSel.title = "qb"
        qbSel.dg = self
        
        receiverSel = NumberSelector(frame: CGRect(x: receiverGD.center.x-(receiverGD.bounds.width/2), y: receiverGD.center.y-(receiverGD.bounds.height/2), width: receiverGD.bounds.width, height: receiverGD.bounds.height))
        view.addSubview(receiverSel)
        receiverSel.backgroundColor = colors.popOverPass
        receiverSel.title = "receiver"
        receiverSel.dg = self
        
        tackleSel = NumberSelector(frame: CGRect(x: tackleGD.center.x-(tackleGD.bounds.width/2), y: tackleGD.center.y-(tackleGD.bounds.height/2), width: tackleGD.bounds.width, height: tackleGD.bounds.height))
        view.addSubview(tackleSel)
        tackleSel.backgroundColor = colors.popOverPass
        tackleSel.title = "tackle"
        tackleSel.dg = self
        
        if entry.data.player_a != nil {
            
            edit_mode = true
            
            qbSel.selectNumber(entry.data.player_a)
            receiverSel.selectNumber(entry.data.player_b)
            doneBTN.hidden = false
            deleteBTN.hidden = false
            updateTackles()
            fumbleSW.on = entry.data.fumble
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func popoverControllerShouldDismissPopover(popoverController: UIPopoverController) -> Bool {
        
        self.dismissViewControllerAnimated(false, completion: nil)
        
        return true
        
    }
    
    func popoverControllerDidDismissPopover(popoverController: UIPopoverController) {
        
        dg.popCancelled()
        
    }
    
    
    func numberSelected(item: UITapGestureRecognizer, title: String) {
        
        switch title {
        case "qb":
            
            entry.data.player_a = item.view!.tag
            
        case "receiver":
            
            entry.data.player_b = item.view!.tag
            
        case "tackle":
            
            entry.data.tackles.append(item.view!.tag)
            updateTackles()
            
        default:
            NSLog("NUM SEL ERROR!")
        }
        
        if entry.data.player_a != nil && entry.data.player_b != nil {
            
            doneBTN.hidden = false
            deleteBTN.hidden = false
            
        }
        
    }
    
    func updateTackles(){
        
        removeTackles()
        
        tackles = []
        
        var i = 0
        for tackle in entry.data.tackles {
            
            var new_x = CGFloat(i * 44) + (tackleNumGD.center.x-(tackleNumGD.bounds.width/2)) + 4
            
            var t = UIButton(frame: CGRect(x: new_x, y: tackleNumGD.center.y-(tackleNumGD.bounds.height/2), width: 40, height: 30))
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
    
    @IBAction func fumbleChanged(sender: AnyObject) {
        
        entry.data.fumble = fumbleSW.on
        
    }
    
    @IBAction func donePressed(sender: AnyObject) {
        
        if edit_mode {
            dg.editEntry(entry)
        } else {
            dg.addEntry(entry)
        }
        
    }
    
    @IBAction func deletePressed(sender: AnyObject) {
        
        dg.deleteEntry(entry)
        
    }

}
