//
//  TimeZoneUtilities.swift
//  TimeZoneExplorer
//
//  Created by Michael L Mehr on 1/18/16.
//  Copyright © 2016 Michael L. Mehr. All rights reserved.
//

import Foundation
//import Parse
//import ParseUI

class TZTimeZone {
    static func getStandardFormat( zoneID: String ) -> String {
        var result = ""
        if let zone = NSTimeZone(name: zoneID) {
            var offset = zone.secondsFromGMT // NOTE: this may be daylight savings time now
            if zone.daylightSavingTime {
                if let nonDaylightDate = zone.nextDaylightSavingTimeTransition {
                    offset = zone.secondsFromGMTForDate(nonDaylightDate)
                }
            }
            // convert offset to hours/minutes standard form
            let offabs = abs(offset)
            let offhours = offabs/3600
            let offmins = (offabs%3600) / 60
            let offextra = (offmins == 0) ? "0" : "" // kludge to prevent a single 0 when 0 mins
            let offstr = "\(offset<0 ? "-" : "+")\(offhours):\(offmins)\(offextra)"
            let abbrev: String
            if let abbrevX = zone.abbreviation {
                abbrev = " [\(abbrevX)]"
            } else {
                abbrev = ""
            }
            result = "\(zoneID) (GMT\(offstr))\(abbrev)"
        }
        return result
    }
    
    static func getZoneID( input: String ) -> String {
        var result:String = ""
        // truncate string at first occurrence of " ("
        if let foundRange = input.rangeOfString(" (") {
            result = input.substringToIndex(foundRange.startIndex)
        }
        return result
    }
}
