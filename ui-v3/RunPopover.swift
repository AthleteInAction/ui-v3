//
//  RunPopover.swift
//  ui-v3
//
//  Created by grobinson on 11/5/14.
//  Copyright (c) 2014 wambl. All rights reserved.
//

import UIKit

class RunPopover: UIViewController, UIPopoverControllerDelegate, NumSelDG {
   
    var dg: AddPlayDel!
    var colors: Colors = Colors()
    var entry: Entry!
    
    var edit_mode: Bool = false
    
    @IBOutlet weak var rusherGD: UIView!
    @IBOutlet weak var tackleGD: UIView!
    @IBOutlet weak var tackNumGD: UIView!
    @IBOutlet weak var sackGD: UIView!
    @IBOutlet weak var sackNumGD: UIView!
    @IBOutlet weak var fumbleSW: UISwitch!
    @IBOutlet weak var doneBTN: UIButton!
    @IBOutlet weak var deleteBTN: UIButton!
    @IBOutlet weak var runTXT: UILabel!
    
    var rusherSel: NumberSelector!
    var tackleSel: NumberSelector!
    var sackSel: NumberSelector!
    
    var tackles: [UIButton] = []
    var sacks: [UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clearColor()
        
        fumbleSW.on = false
        doneBTN.hidden = true
        deleteBTN.hidden = true
        
        rusherSel = NumberSelector(frame: CGRect(x: rusherGD.center.x-(rusherGD.bounds.width/2), y: rusherGD.center.y-(rusherGD.bounds.height/2), width: rusherGD.bounds.width, height: rusherGD.bounds.height))
        view.addSubview(rusherSel)
        rusherSel.backgroundColor = colors.popOverRun
        rusherSel.title = "rusher"
        rusherSel.dg = self
        
        tackleSel = NumberSelector(frame: CGRect(x: tackleGD.center.x-(tackleGD.bounds.width/2), y: tackleGD.center.y-(tackleGD.bounds.height/2), width: tackleGD.bounds.width, height: tackleGD.bounds.height))
        view.addSubview(tackleSel)
        tackleSel.backgroundColor = colors.popOverRun
        tackleSel.title = "tackle"
        tackleSel.dg = self
        
        sackSel = NumberSelector(frame: CGRect(x: sackGD.center.x-(sackGD.bounds.width/2), y: sackGD.center.y-(sackGD.bounds.height/2), width: sackGD.bounds.width, height: sackGD.bounds.height))
        view.addSubview(sackSel)
        sackSel.backgroundColor = colors.popOverRun
        sackSel.title = "sack"
        sackSel.dg = self
        
        if entry.data.player_a != nil {
            
            edit_mode = true
            
            rusherSel.selectNumber(entry.data.player_a)
            doneBTN.hidden = false
            deleteBTN.hidden = false
            updateTackles()
            fumbleSW.on = entry.data.fumble
            
        }
        
        if entry.data.play_key == "return" {
            
            runTXT.text = "Returner:"
//            sackGD.hidden = true
//            sackSel.hidden = true
            
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
    
    func numberSelected(item: UITapGestureRecognizer,title: String) {
        
        switch title {
        case "rusher":
            
            entry.data.player_a = item.view!.tag
            
        case "tackle":
            
            entry.data.tackles.append(item.view!.tag)
            updateTackles()
            
        case "sack":
            
            entry.data.sacks.append(item.view!.tag)
            updateTackles()
            
        default:
            NSLog("NUM SEL ERROR!")
        }
        
        doneBTN.hidden = false
        deleteBTN.hidden = false
        
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
        
        sacks = []
        
        i = 0
        for sack in entry.data.sacks {
            
            var new_x = CGFloat(i * 44) + (sackNumGD.center.x-(sackNumGD.bounds.width/2)) + 4
            
            var t = UIButton(frame: CGRect(x: new_x, y: sackNumGD.center.y-(sackNumGD.bounds.height/2), width: 40, height: 30))
            t.backgroundColor = UIColor.grayColor()
            t.setTitle("\(sack)", forState: UIControlState.Normal)
            t.tag = i
            
            var tap = UITapGestureRecognizer()
            tap.numberOfTapsRequired = 2
            tap.addTarget(self, action: "deleteSack:")
            
            t.addGestureRecognizer(tap)
            
            sacks.append(t)
            view.addSubview(sacks.last!)
            
            i++
            
        }
        
    }
    func removeTackles(){
        
        for tackle in tackles {
            
            tackle.removeFromSuperview()
            
        }
        
        for sack in sacks {
            
            sack.removeFromSuperview()
            
        }
        
    }
    
    func deleteTackle(item: UITapGestureRecognizer){
        
        entry.data.tackles.removeAtIndex(item.view!.tag)
        
        updateTackles()
        
    }
    func deleteSack(item: UITapGestureRecognizer){
        
        entry.data.sacks.removeAtIndex(item.view!.tag)
        
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
