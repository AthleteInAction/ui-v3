//
//  KickPopover.swift
//  ui-v3
//
//  Created by grobinson on 11/5/14.
//  Copyright (c) 2014 wambl. All rights reserved.
//

import UIKit

class KickPopover: UIViewController, UIPopoverControllerDelegate, NumSelDG {
    
    var dg: AddPlayDel!
    
    var colors: Colors = Colors()
    
    var entry: Entry!
    
    @IBOutlet weak var numSelGD: UIView!
    var numSel: NumberSelector!
    
    @IBOutlet weak var deleteBTN: UIButton!
    
    @IBOutlet weak var topTXT: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clearColor()
        
        numSel = NumberSelector(frame: CGRect(x: numSelGD.center.x-(numSelGD.bounds.width/2), y: numSelGD.center.y-(numSelGD.bounds.height/2), width: numSelGD.bounds.width, height: numSelGD.bounds.height))
        numSel.dg = self
        view.addSubview(numSel)
        
        switch entry.data.play_key {
        case "punt":
            topTXT.text = "Punter:"
        case "kick":
            topTXT.text = "Kicker:"
        default:
            topTXT.text = "ERROR!"
        }
        
        if entry.data.player_a != nil {
            
            numSel.scrollto(entry.data.player_a)
            numSel.selectNumber(entry.data.player_a)
            
            deleteBTN.hidden = false
            
        } else {
            
            deleteBTN.hidden = true
            
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func popoverControllerShouldDismissPopover(popoverController: UIPopoverController) -> Bool {
        
        self.dismissViewControllerAnimated(false, completion: nil)
        
        return true
        
    }
    
    
    func numberSelected(item: UITapGestureRecognizer,title: String){
        
        if entry.data.player_a != nil {
            entry.data.player_a = item.view!.tag
            dg.editEntry(entry)
        } else {
            entry.data.player_a = item.view!.tag
            dg.addEntry(entry)
        }
        
    }
    
    func popoverControllerDidDismissPopover(popoverController: UIPopoverController) {
        
        dg.popCancelled()
        
    }

    @IBAction func deleteKick(sender: AnyObject) {
        
        dg.deleteEntry(entry)
        
    }
    
}
