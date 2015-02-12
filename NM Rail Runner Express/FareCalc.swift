//
//  FareCalc.swift
//  NM Rail Runner Express
//
//  Created by Chris Hughes on 12/7/14.
//  Copyright (c) 2014 Chris Hughes. All rights reserved.
//

import Foundation

class FareCalc {
    
    private class func getZone(id :Int) -> Int{
        if id < 2 {return 0}
        if id < 3 {return 1}
        if id < 4 {return 2}
        if id < 6 {return 3}
        if id < 12 {return 4}
        return 5
    }
    
    class func getFareFrom(from: Int, to:Int)->[String]{
        let zones: Int = abs(getZone(from)-getZone(to)) + 1
        
        //println(zones)
        
        var result : [String] = ["",""]
        
        if (zones == 1){result[0] = "$2/$1";result[1] = "$3/$2"}
        else if (zones == 2){result[0] = "$3/$1";result[1] = "$4/$2"}
        else if (zones == 3){result[0] = "$5/$2";result[1] = "$6/$3"}
        else if (zones == 4){result[0] = "$8/$4";result[1] = "$9/$6"}
        else if (zones == 5){result[0] = "$9/$4";result[1] = "$10/$7"}
        else if (zones == 6){result[0] = "$10/$5";result[1] = "$11/$8"}
        
        return result
    }
    
    
}
