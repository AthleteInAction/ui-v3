//
//  ViewController.swift
//  ui-v3
//
//  Created by grobinson on 11/4/14.
//  Copyright (c) 2014 wambl. All rights reserved.
//

import UIKit

protocol AddPlayDel {
    
    func popCancelled()
    func addEntry(entry: Entry)
    func editEntry(entry: Entry)
    func deleteEntry(entry: Entry)
    
    func addReturn(entry: Entry)
    
}

class ViewController: UIViewController, FieldDel, AddPlayDel {
    
    // ITEMS
    // ))))))))))))))))))))))))))))))))))))))))))))))))
    // ))))))))))))))))))))))))))))))))))))))))))))))))
    var colors: Colors = Colors()
    
    var MAIN_DRIVE: Drive = Drive()
    var TMP_PLAY: Play = Play()
    
    @IBOutlet weak var FIELD: FieldClass!
    
    @IBOutlet weak var AWAY_BTN: UIButton!
    @IBOutlet weak var AWAY_SCORE: UILabel!
    @IBOutlet weak var HOME_BTN: UIButton!
    @IBOutlet weak var HOME_SCORE: UILabel!
    
    @IBOutlet weak var QTR_TXT: UILabel!
    @IBOutlet weak var QTR_STP: UIStepper!
    
    @IBOutlet weak var DOWN_TXT: UILabel!
    var DOWN: Int = 1
    
    var TOGO: Int = 10
    
    var L: Bool = false
    var R: Bool = true
    var SIDE_POS: Bool = true
    var HOME_RIGHT: Bool = true
    var POSSESSION: Bool = true
    var TAPCOUNT: Int!
    var TOUCHCOUNT: Int!
    var TOUCHPOINT: CGPoint!
    var DIST: Int!
    var FIELD_DISABLED: Bool = false
    var VALID: Bool = false
    
    var RECOVERY: Bool = false
    var RECOVERY_ENTRY: Entry!
    // ))))))))))))))))))))))))))))))))))))))))))))))))
    // ))))))))))))))))))))))))))))))))))))))))))))))))
    
    
    
    // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FIELD.dg = self
        
        QTR_STP.minimumValue = 1
        
        var tap = UITapGestureRecognizer()
        tap.addTarget(self, action: "possessionA")
        AWAY_BTN.addGestureRecognizer(tap)
        
        tap = UITapGestureRecognizer()
        tap.addTarget(self, action: "possessionH")
        HOME_BTN.addGestureRecognizer(tap)
        
        tap = UITapGestureRecognizer()
        tap.addTarget(self, action: "downIncrement")
        DOWN_TXT.userInteractionEnabled = true
        DOWN_TXT.addGestureRecognizer(tap)
        
        possessionA()
        setDown(1)
        
    }
    // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    
    
    
    // MARKER DRAGGED
    // ++++++++++++++++++++++++++++++++++++++++++++++++
    // ++++++++++++++++++++++++++++++++++++++++++++++++
    func mkrDragged(item: UIPanGestureRecognizer) {
        
        TOGO = Int(round((FIELD.MKR_B.center.x - FIELD.MKR_A.center.x) / FIELD.RATIO))
        
        setDown(DOWN)
        
    }
    // ++++++++++++++++++++++++++++++++++++++++++++++++
    // ++++++++++++++++++++++++++++++++++++++++++++++++
    
    
    
    // QUARTER CHANGE
    // ++++++++++++++++++++++++++++++++++++++++++++++++
    // ++++++++++++++++++++++++++++++++++++++++++++++++
    @IBAction func qtrChanged(sender: AnyObject) {
        
        var qn = Int(QTR_STP.value)
        var qs = "QTR \(qn)"
        
        if qn > 4 {
            
            qs = "OT \(qn - 4)"
            
        }
        
        QTR_TXT.text = qs
        
        setDrive()
        
    }
    // ++++++++++++++++++++++++++++++++++++++++++++++++
    // ++++++++++++++++++++++++++++++++++++++++++++++++
    
    
    
    // POSSESSION
    // ++++++++++++++++++++++++++++++++++++++++++++++++
    // ++++++++++++++++++++++++++++++++++++++++++++++++
    func possessionA(){
        
        AWAY_BTN.backgroundColor = colors.orange
        AWAY_SCORE.textColor = colors.orange
        HOME_BTN.backgroundColor = colors.light_grey
        HOME_SCORE.textColor = colors.light_grey
        
        POSSESSION = false
        
        if HOME_RIGHT {
            SIDE_POS = false
        } else {
            SIDE_POS = true
        }
        
        setDrive()
        
    }
    func possessionH(){
        
        AWAY_BTN.backgroundColor = colors.light_grey
        AWAY_SCORE.textColor = colors.light_grey
        HOME_BTN.backgroundColor = colors.orange
        HOME_SCORE.textColor = colors.orange
        
        POSSESSION = true
        
        if HOME_RIGHT {
            SIDE_POS = true
        } else {
            SIDE_POS = false
        }
        
        setDrive()
        
    }
    // ++++++++++++++++++++++++++++++++++++++++++++++++
    // ++++++++++++++++++++++++++++++++++++++++++++++++
    
    
    
    // DOWN INCREMENT
    // ++++++++++++++++++++++++++++++++++++++++++++++++
    // ++++++++++++++++++++++++++++++++++++++++++++++++
    var downs = [
        ["blank","blank"],
        ["1ST","scrimmage"],
        ["2ND","scrimmage"],
        ["3RD","scrimmage"],
        ["4TH","scrimmage"],
        ["KICKOFF","kickoff"],
        ["PAT","pat"]
    ]
    func downIncrement(){
        
        DOWN++
        if DOWN >= 7 {DOWN = 1}
        
        setDown(DOWN)
        
    }
    func setDown(down: Int){
        
        DOWN = down
        
        DOWN_TXT.text = "\(downs[DOWN][0]) & \(TOGO)"
        
        if down >= 5 {
            DOWN_TXT.text = "\(downs[DOWN][0])"
        }
        
        if down == 5 {
            FIELD.MKR_A.center.x = FIELD.gotoYard(SIDE_POS, yard: 40)
        }
        
        if down == 6 {
            FIELD.MKR_A.center.x = FIELD.gotoYard(!SIDE_POS, yard: 3)
        }
        
        if down >= 1 && down <= 4 {
            FIELD.MKR_B.hidden = false
        } else {
            FIELD.MKR_B.hidden = true
        }
        
        if MAIN_DRIVE.plays.count == 0 {
            FIELD.PLAYLINE = FIELD.MKR_A.center.x
        }
        
    }
    // ++++++++++++++++++++++++++++++++++++++++++++++++
    // ++++++++++++++++++++++++++++++++++++++++++++++++
    
    
    
    // SET DRIVE
    // ++++++++++++++++++++++++++++++++++++++++++++++++
    // ++++++++++++++++++++++++++++++++++++++++++++++++
    func setDrive(){
        
        
        
    }
    // ++++++++++++++++++++++++++++++++++++++++++++++++
    // ++++++++++++++++++++++++++++++++++++++++++++++++
    
    
    
    // FIELD TOUCHES
    // ++++++++++++++++++++++++++++++++++++++++++++++++||||||||||||||||||||||||||||||
    // ++++++++++++++++++++++++++++++++++++++++++++++++||||||||||||||||||||||||||||||
    func fieldTouchesBegan(touches: NSSet, event: UIEvent) {
        
        let t: UITouch = touches.anyObject() as UITouch
        let l: CGPoint = touches.anyObject()!.locationInView(FIELD)
        
        TOUCHPOINT = l
        TAPCOUNT = 0
        TOUCHCOUNT = 0
        VALID = 0
        DIST = 0
        
    }
    func fieldTouchesMoved(touches: NSSet, event: UIEvent) {
        
        let t: UITouch = touches.anyObject() as UITouch
        let l: CGPoint = touches.anyObject()!.locationInView(FIELD)
        
        TAPCOUNT = t.tapCount
        TOUCHCOUNT = event.allTouches()!.count
        DIST = Int(round(abs(l.x - TOUCHPOINT.x) / FIELD.RATIO))
        
        VALID = validTouch()
        
        if VALID {
            
            FIELD.moveCursor(l)
            
        } else {
            
            FIELD.hideCursor()
            
        }
        
    }
    func fieldTouchesEnded(touches: NSSet, event: UIEvent) {
        
        let t: UITouch = touches.anyObject() as UITouch
        let l: CGPoint = touches.anyObject()!.locationInView(FIELD)
        
        if VALID {
            
            if RECOVERY {
                
                addEntry(RECOVERY_ENTRY)
                
                RECOVERY = false
                
            } else {
                
                tmpEntry()
                
            }
            
        }
        
    }
    func fieldTouchesCancelled(touches: NSSet, event: UIEvent) {
        
        let t: UITouch = touches.anyObject() as UITouch
        let l: CGPoint = touches.anyObject()!.locationInView(FIELD)
        
//        FIELD.hideCursor()
        
    }
    func tmpEntry(){
        
        var width: CGFloat = FIELD.VLINE.center.x - FIELD.PLAYLINE
        
        var height: CGFloat = 20
        
        var entry = Entry(frame: CGRect(x: FIELD.PLAYLINE, y: FIELD.HLINE.center.y-10, width: width, height: height), type: playType())
        
        playPop(entry)
        
    }
    // ++++++++++++++++++++++++++++++++++++++++++++++++||||||||||||||||||||||||||||||
    // ++++++++++++++++++++++++++++++++++++++++++++++++||||||||||||||||||||||||||||||
    
    
    
    // VALID TOUCH
    // ++++++++++++++++++++++++++++++++++++++++++++++++
    // ++++++++++++++++++++++++++++++++++++++++++++++++
    func validTouch() -> Bool {
        
        var CLEAN: Bool!
        
        if (TAPCOUNT == 1 || TAPCOUNT == 2 || TAPCOUNT == 3) && TOUCHCOUNT == 1 && !FIELD_DISABLED && DIST > 7 {
            
            CLEAN = true
            
        } else {
            
            CLEAN = false
            
        }
        
        return CLEAN
        
    }
    func playType() -> String {
        
        var type: String = "_"
        
        // KICK
        if DOWN == 5 && TAPCOUNT == 1 && TMP_PLAY.entries.count == 0 {
            type = "kick"
        }
        
        // KICK RETURN
        if DOWN == 5 && TAPCOUNT == 1 && TMP_PLAY.entries.count > 0 {
            type = "kick_return"
        }
        
        // FUMBLE RETURN
        if TMP_PLAY.entries.count > 0 && TMP_PLAY.entries.last!.data.fumble && TAPCOUNT == 1 {
            type = "fumble_recovery"
        }
        
        // RUN
        if DOWN != 5 && TAPCOUNT == 1 && !(TMP_PLAY.entries.count > 0 && TMP_PLAY.entries.last!.data.fumble) {
            type = "run"
        }
        
        // PASS
        if DOWN != 5 && TAPCOUNT == 2 {
            type = "pass"
        }
        
        // INTERCEPTION
        if DOWN != 5 && TAPCOUNT == 3 {
            type = "interception"
        }
        
        return type
        
    }
    // ++++++++++++++++++++++++++++++++++++++++++++++++
    // ++++++++++++++++++++++++++++++++++++++++++++++++
    
    
    
    // PLAY POPOVER
    // --::--##--::--##--::--##--::--##--::--##--::--##
    // --::--##--::--##--::--##--::--##--::--##--::--##
    var pop_controller: UIPopoverController!
    func playPop(entry: Entry){
        
        if entry.data.play_key == "kick" {
            
            var pop = KickPopover(nibName: "KickPopover", bundle: nil)
            pop.dg = self
            pop.entry = entry
            
            pop_controller = PopOverCtrl(contentViewController: pop)
            pop_controller.delegate = pop
            pop_controller.backgroundColor = colors.popOverKick
            
            pop_controller.popoverContentSize = CGSize(width: 600, height: 122)
            
            var new_x = FIELD.VLINE.center.x
            var new_y = FIELD.HLINE.center.y
            
            if entry.data.player_a != nil {
                new_x = TMP_PLAY.entries[entry.tag].center.x
                new_y = TMP_PLAY.entries[entry.tag].center.y
            }
            
            pop_controller.presentPopoverFromRect(
                CGRect(
                    x: new_x-(pop_controller.popoverContentSize.width/2),
                    y: new_y,
                    width: pop_controller.popoverContentSize.width,
                    height: pop_controller.popoverContentSize.height
                ),
                inView: FIELD,
                permittedArrowDirections: UIPopoverArrowDirection.Down,
                animated: false
            )
            
        }
        
        if entry.data.play_key == "return" {
            
            var pop = RunPopover(nibName: "RunPopover", bundle: nil)
            pop.dg = self
            pop.entry = entry
            
            pop_controller = PopOverCtrl(contentViewController: pop)
            pop_controller.delegate = pop
            pop_controller.backgroundColor = colors.popOverReturn
            
            pop_controller.popoverContentSize = CGSize(width: 600, height: 390)
            
            var new_x = FIELD.VLINE.center.x
            var new_y = FIELD.HLINE.center.y
            
            if entry.data.player_a != nil {
                new_x = TMP_PLAY.entries[entry.tag].center.x
                new_y = TMP_PLAY.entries[entry.tag].center.y
            }
            
            pop_controller.presentPopoverFromRect(
                CGRect(
                    x: new_x-(pop_controller.popoverContentSize.width/2),
                    y: new_y,
                    width: pop_controller.popoverContentSize.width,
                    height: pop_controller.popoverContentSize.height
                ),
                inView: FIELD,
                permittedArrowDirections: UIPopoverArrowDirection.Down,
                animated: false
            )
            
        }
        
        if entry.data.play_key == "fumble_recovery" {
            
            var pop = FumbleRecovery(nibName: "FumbleRecovery", bundle: nil)
            pop.dg = self
            pop.entry = entry
            
            pop_controller = PopOverCtrl(contentViewController: pop)
            pop_controller.delegate = pop
            pop_controller.backgroundColor = colors.popOverFumRec
            
            pop_controller.popoverContentSize = CGSize(width: 600, height: 316)
            
            var new_x = FIELD.VLINE.center.x
            var new_y = FIELD.HLINE.center.y
            
            if entry.data.player_a != nil {
                new_x = TMP_PLAY.entries[entry.tag].center.x
                new_y = TMP_PLAY.entries[entry.tag].center.y
            }
            
            pop_controller.presentPopoverFromRect(
                CGRect(
                    x: new_x-(pop_controller.popoverContentSize.width/2),
                    y: new_y,
                    width: pop_controller.popoverContentSize.width,
                    height: pop_controller.popoverContentSize.height
                ),
                inView: FIELD,
                permittedArrowDirections: UIPopoverArrowDirection.Down,
                animated: false
            )
            
        }
        
        if entry.data.play_key == "run" {
            
            var pop = RunPopover(nibName: "RunPopover", bundle: nil)
            pop.dg = self
            pop.entry = entry
            
            pop_controller = PopOverCtrl(contentViewController: pop)
            pop_controller.delegate = pop
            pop_controller.backgroundColor = colors.popOverRun
            
            pop_controller.popoverContentSize = CGSize(width: 600, height: 390)
            
            var new_x = FIELD.VLINE.center.x
            var new_y = FIELD.HLINE.center.y
            
            if entry.data.player_a != nil {
                new_x = TMP_PLAY.entries[entry.tag].center.x
                new_y = TMP_PLAY.entries[entry.tag].center.y
            }
            
            pop_controller.presentPopoverFromRect(
                CGRect(
                    x: new_x-(pop_controller.popoverContentSize.width/2),
                    y: new_y,
                    width: pop_controller.popoverContentSize.width,
                    height: pop_controller.popoverContentSize.height
                ),
                inView: FIELD,
                permittedArrowDirections: UIPopoverArrowDirection.Down,
                animated: false
            )
            
        }
        
        if entry.data.play_key == "pass" {
            
            var pop = PassPopover(nibName: "PassPopover", bundle: nil)
            pop.dg = self
            pop.entry = entry
            
            pop_controller = PopOverCtrl(contentViewController: pop)
            pop_controller.delegate = pop
            pop_controller.backgroundColor = colors.popOverPass
            
            pop_controller.popoverContentSize = CGSize(width: 600, height: 352)
            
            var new_x = FIELD.VLINE.center.x
            var new_y = FIELD.HLINE.center.y
            
            if entry.data.player_a != nil {
                new_x = TMP_PLAY.entries[entry.tag].center.x
                new_y = TMP_PLAY.entries[entry.tag].center.y
            }
            
            pop_controller.presentPopoverFromRect(
                CGRect(
                    x: new_x-(pop_controller.popoverContentSize.width/2),
                    y: new_y,
                    width: pop_controller.popoverContentSize.width,
                    height: pop_controller.popoverContentSize.height
                ),
                inView: FIELD,
                permittedArrowDirections: UIPopoverArrowDirection.Down,
                animated: false
            )
            
        }
        
    }
    // --::--##--::--##--::--##--::--##--::--##--::--##
    // --::--##--::--##--::--##--::--##--::--##--::--##
    
    
    
    // ADD ENTRY
    // ))***))***))***))***))***))***))***))***))***))***
    // ))***))***))***))***))***))***))***))***))***))***
    func popCancelled() {
        
        FIELD.hideCursor()
        deselectEntries()
        
    }
    func addEntry(entry: Entry) {
        
        var new_entry = entry
        
        if entry.data.play_key == "fumble_recovery" {
            
            var width = FIELD.VLINE.center.x - FIELD.RLINE.center.x
            
            new_entry = Entry(frame: CGRect(x: FIELD.RLINE.center.x, y: FIELD.HLINE.center.y-10, width: width, height: 20), type: "fumble_recovery")
            new_entry.data = RECOVERY_ENTRY.data
            
        }
        
        var tap = UITapGestureRecognizer()
        tap.addTarget(self, action: "entrySelected:")
        new_entry.addGestureRecognizer(tap)
        
        TMP_PLAY.entries.append(new_entry)
        
        FIELD.addSubview(TMP_PLAY.entries.last!)
        
        indexEntries()
        
        pop_controller.dismissPopoverAnimated(false)
        
        FIELD.hideCursor()
        FIELD.hideRecoveryCursor()
        
        FIELD.PLAYLINE = (new_entry.center.x - (new_entry.bounds.width/2)) + new_entry.bounds.width
        
    }
    func editEntry(entry: Entry){
        
        TMP_PLAY.entries[entry.tag] = entry
        
        indexEntries()
        
        deselectEntries()
        
        pop_controller.dismissPopoverAnimated(false)
        
    }
    func deleteEntry(entry: Entry){
        
        TMP_PLAY.entries[entry.tag].removeFromSuperview()
        TMP_PLAY.entries.removeAtIndex(entry.tag)
        
        indexEntries()
        
        FIELD.hideCursor()
        
        deselectEntries()
        
        pop_controller.dismissPopoverAnimated(false)
        
    }
    func addReturn(entry: Entry) {
        
        FIELD.moveRecoveryCursor(FIELD.VLINE.center.x)
        
        RECOVERY_ENTRY = entry
        
        RECOVERY = true
        
        pop_controller.dismissPopoverAnimated(false)
        
        FIELD.hideCursor()
        
    }
    // ))***))***))***))***))***))***))***))***))***))***
    // ))***))***))***))***))***))***))***))***))***))***
    
    
    
    // ENTRY SELECTED
    // IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
    // IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
    func entrySelected(item: UITapGestureRecognizer){
        
        var entry = TMP_PLAY.entries[item.view!.tag]
        
        deselectEntries()
        entry.selectEntry()
        
        playPop(entry)
        
    }
    // IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
    // IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
    
    
    
    // INDEX ENTRIES
    // ++++++++++++++++++++++++++++++++++++++++++++++++++
    // ++++++++++++++++++++++++++++++++++++++++++++++++++
    func indexEntries(){
        
        var i = 0
        for entry in TMP_PLAY.entries {
            
            entry.tag = i
            
            i++
            
        }
        
    }
    func deselectEntries(){
        
        for entry in TMP_PLAY.entries {
            
            entry.deselectEntry()
            
        }
        
    }
    // ++++++++++++++++++++++++++++++++++++++++++++++++++
    // ++++++++++++++++++++++++++++++++++++++++++++++++++
    
}

