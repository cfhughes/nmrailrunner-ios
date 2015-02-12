//
//  ViewController.swift
//  NM Rail Runner Express
//
//  Created by Chris Hughes on 11/27/14.
//  Copyright (c) 2014 Chris Hughes. All rights reserved.
//

import UIKit

class ViewController: GAITrackedViewController,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var fromText : UILabel!
    @IBOutlet var toText : UILabel!
    @IBOutlet var fromView : UIView!
    @IBOutlet var toView : UIView!
    @IBOutlet var scheduleView : UITableView!
    @IBOutlet var dotwView : UIView!
    @IBOutlet var dotwText : UILabel!
    @IBOutlet var onewayFare : UILabel!
    @IBOutlet var dayFare : UILabel!
    
    @IBOutlet var adView : UIView!
    
    let svc : ScheduleViewControler = ScheduleViewControler()
    
    let pick : UITableView = UITableView()
    let dotwPick : UITableView = UITableView()
    
    var touched :UIView?
    
    var fromIndex : Int = -1
    var toIndex : Int = -1
    var dotwIndex : Int = -1
    
    let locale = NSLocale(localeIdentifier: "en_US")
    
    let dateFormatter3 = NSDateFormatter()
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        
        for touch in touches {
            if (touch.view == fromView || touch.view == toView){
                hideDOTWPick()
                if (touched == touch.view && pick.isDescendantOfView(self.view)){
                    hidePick()
                }else{
                    if (pick.indexPathForSelectedRow() != nil){
                        pick.deselectRowAtIndexPath(pick.indexPathForSelectedRow()!, animated: false)
                    }
                    var pickheight : CGFloat = 300
                    touched = touch.view!
                    if (touched!.frame.maxY + 300 > self.view.frame.height){
                        pickheight = self.view.frame.height - touched!.frame.maxY
                    }
                    pick.frame = CGRect(x: touched!.frame.minX, y: touched!.frame.maxY, width: touched!.frame.width, height:pickheight)
                    
                    self.view.addSubview(pick)
                    
                    UIView.animateWithDuration(0.3, animations: {
                        self.pick.alpha = 1.0
                    })
                    
                    //self.view.bringSubviewToFront(pick)
                }
            }else if (touch.view == dotwView){
                //println("DOTW")
                hidePick()
                if (dotwPick.isDescendantOfView(self.view)){
                    hideDOTWPick()
                }else{
                    touched = touch.view
                    dotwPick.frame = CGRect(x: dotwView.frame.minX, y: dotwView.frame.maxY, width: dotwView.frame.width, height:160)
                    
                    self.view.addSubview(dotwPick)
                    
                    UIView.animateWithDuration(0.3, animations: {
                        self.dotwPick.alpha = 1.0
                    })
                }
            }else if (touch.view == adView){
                UIApplication.sharedApplication().openURL(NSURL(string: "http://chrishughes.me")!)
                let tracker = GAI.sharedInstance().defaultTracker
                tracker.send(GAIDictionaryBuilder.createEventWithCategory("Interaction", action: "Click", label: "chrishughes.me", value: nil).build())
            }else{
                println("None")
                hidePick()
                hideDOTWPick()
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.screenName = "Main"
        dateFormatter3.locale = locale
        dateFormatter3.dateFormat = "ccc"
        var nowdotw = dateFormatter3.stringFromDate(NSDate())
        
        if (nowdotw == "Sun"){
            dotwIndex = 2
            dotwText.text = dotw[2]
        }else if (nowdotw == "Sat"){
            dotwIndex = 1
            dotwText.text = dotw[1]
        }else{
            dotwIndex = 0 //Weekday
        }
        
        dotwPick.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell1")
        
        dotwPick.delegate = self
        dotwPick.dataSource = self
        
        dotwPick.alpha = 0.0
        
        pick.delegate = self
        pick.dataSource = self
        
        pick.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        pick.alpha = 0.0
        svc.view = scheduleView
        scheduleView.delegate = svc
        scheduleView.dataSource = svc
        svc.loadSchedule()
        fromIndex = 0 //Santa Fe Depot
        toIndex = 9 //Downtown Albuquerque
        svc.displayDOTW(dotwIndex, from: fromIndex, to: toIndex)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let names : [String] = ["Santa Fe Depot",
        "South Capitol",
        "Santa Fe County/NM 599",
        "Kewa",
        "Sandoval County/US 550",
        "Downtown Bernalillo",
        "Sandia Pueblo",
        "Los Ranchos/Journal Center",
        "Montaño",
        "Downtown Albuquerque",
        "Bernalillo County",
        "Isleta Pueblo",
        "Los Lunas",
        "Belen"]
    
    let dotw : [String] = ["Weekday",
        "Saturday",
        "Sunday"]
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (tableView == dotwPick){
            var cell:UITableViewCell = dotwPick.dequeueReusableCellWithIdentifier("cell1") as UITableViewCell
            cell.backgroundColor = UIColor.blackColor()
            cell.textLabel!.textColor = UIColor.whiteColor()
            cell.textLabel!.text = dotw[indexPath.row]
            return cell
        }else{
            var cell:UITableViewCell = pick.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
            cell.backgroundColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1)
            cell.textLabel!.text = names[indexPath.row]
            return cell
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == dotwPick){
            return dotw.count
        }else{
            return names.count
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        hidePick()
        hideDOTWPick()
        
        if (touched == fromView){
            fromText.text = names[indexPath.row]
            fromIndex = indexPath.row
            
        }else if (touched == toView){
            toText.text = names[indexPath.row]
            toIndex = indexPath.row
            
        }else if (touched == dotwView){
            dotwText.text = dotw[indexPath.row]
            dotwIndex = indexPath.row
        }
        
        svc.displayDOTW(dotwIndex, from: fromIndex, to: toIndex)
        
        let fares: [String] = FareCalc.getFareFrom(fromIndex, to: toIndex)
        
        onewayFare.text = fares[0]
        dayFare.text = fares[1]
        
        
    }
    
    func hidePick(){
        if (pick.isDescendantOfView(self.view)){
            UIView.animateWithDuration(0.3, animations: {
                self.pick.alpha = 0.0
                }, completion: {(value: Bool) in
                    self.pick.removeFromSuperview()
            })
        }
    }
    
    func hideDOTWPick(){
        if (dotwPick.isDescendantOfView(self.view)){
            UIView.animateWithDuration(0.3, animations: {
                self.dotwPick.alpha = 0.0
                }, completion: {(value: Bool) in
                    self.dotwPick.removeFromSuperview()
            })
        }
    }
    
    
}

