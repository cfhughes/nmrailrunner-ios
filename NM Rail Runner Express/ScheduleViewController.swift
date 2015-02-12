//
//  ScheduleViewController.swift
//  NM Rail Runner Express
//
//  Created by Chris Hughes on 12/4/14.
//  Copyright (c) 2014 Chris Hughes. All rights reserved.
//

import UIKit

class ScheduleViewControler: UITableViewController,UITableViewDataSource, UITableViewDelegate {
    
    var schedule = Array<Array<String>>()
    
    let locale = NSLocale(localeIdentifier: "en_US")
    
    let dateFormatter = NSDateFormatter()
    let dateFormatter2 = NSDateFormatter()
    
    
    var lastTrain : Int = 0
    
    func loadSchedule(){
        dateFormatter.locale = locale
        dateFormatter2.locale = locale
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mma"
        dateFormatter2.dateFormat = "yyyy-MM-dd"
        let fileLocation : String = NSBundle.mainBundle().resourcePath!.stringByAppendingPathComponent("rr.csv")
        let fullstring: String = String(contentsOfFile: fileLocation, encoding: NSUTF8StringEncoding, error: nil)!
        var i : Int = 0
        for line in fullstring.componentsSeparatedByString("\n") {
            schedule.append(line.componentsSeparatedByString(","))
            i++
        }
        
        (self.view as UITableView).registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell2")
        println("Loaded Schedule")
    }
    
    var rows : Array<String> = Array<String>()
    
    func displayDOTW(dotw: Int,var from: Int,var to: Int){
        let date = NSDate()
        //println("Now: \(date.description)")
        from++
        to++
        rows.removeAll(keepCapacity: true)
        if (from < to){
            from = from + 15
            to = to + 15
        }else{
            from = 15 - from
            to = 15 - to
        }
        from += 30*dotw
        to += 30*dotw
        let fromtimes = schedule[from]
        let totimes = schedule[to]
        var i : Int
        for i = 1; i < fromtimes.count; ++i {
            if(fromtimes[i] == "" || totimes[i] == ""){
                continue
            }
            var extra : String = ""
            let j = (from/15) * 15
            if (schedule[j][i] == "#101" || schedule[j][i] == "#102"){
                extra = " Express"
            }
            rows.append("\(fromtimes[i]) - \(totimes[i])\(extra)")
            //println("\(dateFormatter2.stringFromDate(date)) \(fromtimes[i])M")
            let fromTime = dateFormatter.dateFromString("\(dateFormatter2.stringFromDate(date)) \(fromtimes[i])M")
            //println(fromTime?.description)
            //println(date.compare(fromTime!))
            if (date.compare(fromTime!) == NSComparisonResult.OrderedDescending){
                //println("Here \(rows.count)")
                lastTrain = rows.count
            }
        }
        println(lastTrain)
        (self.view as UITableView).reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell = (self.view as UITableView).dequeueReusableCellWithIdentifier("cell2") as UITableViewCell
        cell.textLabel!.text = rows[indexPath.row]
        if (indexPath.row < lastTrain){
            cell.textLabel?.textColor = UIColor.lightGrayColor()
        }else{
            cell.textLabel?.textColor = UIColor.blackColor()
        }
        return cell
    }
    
    
}
