//
//  TimeZone.swift
//  TimeZoneExplorer
//
//  Created by Michael L Mehr on 1/19/16.
//  Copyright © 2016 Michael L. Mehr. All rights reserved.
//

/*
Model class to abstract useful things about time zones. It includes its own NSTimeZone.
Many things can just be done with the ZoneID, a string of the form Area/City or sometimes Area/Region/City.

The func getTimeInfo() deals with the complexities of finding out the real standard offset from UTC, starting only with the current one (as of the current date). DST varies throughout the year.
While the project spec doesn't deal with DST directly, any real world implementation will have to.

Look at the ViewModel group for extensions dealing with display formatting.
*/

import Foundation
import Parse


class TZTimeZone {
    
    private let zoneID: String
    private let zone: NSTimeZone
    
    init(zoneID input: String) {
        zoneID = input
        zone = NSTimeZone(name: zoneID)! // will crash if given invalid zoneID
    }

    /// Takes an offset in seconds, splits it into component (hours, minutes, secs=0)
    static func splitTime( interval: NSTimeInterval ) -> (hours: Int, minutes: Int, seconds: Int) {
        let offset = Int(round(interval))
        let offabs = abs(offset)
        let offhours = offabs/3600
        let offmins = (offabs%3600) / 60
        return (offhours, offmins, 0)
    }
    
    enum Type {
        case Standard
        case Daylight
    }
    
    /**
     Returns nil if invalid zoneID.
     
     Otherwise, abbrev will be the abbreviation, if supported, else nil
     
     and Offset will be the UTC offset in seconds, if supported, else 0
     */
    static func getTimeInfo(zoneID: String, type: Type) -> (abbrev: String?, offset: Int)? {
        var result: (String?, Int)? = nil
        if let zone = NSTimeZone(name: zoneID) {
            var offset = zone.secondsFromGMT // NOTE: this may be daylight savings time now
            var abbrev = zone.abbreviation
            let requestedDaylightTime = (type == .Daylight) ? true : false
            if zone.daylightSavingTime != requestedDaylightTime {
                if let nonDaylightDate = zone.nextDaylightSavingTimeTransition {
                    offset = zone.secondsFromGMTForDate(nonDaylightDate)
                    abbrev = zone.abbreviationForDate(nonDaylightDate)
                }
            }
            result = (abbrev, offset)
        }
        return result
    }
    
    /// Splits the zoneID into its components at the '/' char, returning them in order in a tuple
    /// NOTE: Middle entry is "" if there are only two components
    static func getDetailedName(zoneID: String) -> (area: String, region: String, city: String) {
        let segs = zoneID.componentsSeparatedByString("/")
        switch segs.count {
        case 1: return (segs[0], "", "")
        case 2: return (segs[0], "", segs[1])
        case 3: return (segs[0], segs[1], segs[2])
        default: return ("", "", "")
        }
    }

    /// Single-output version of getDetailedName() (used internally)
    static func getAreaName(zoneID: String) -> String {
        let (output, _, _) = getDetailedName(zoneID)
        return output
    }
    
    /// Single-output version of getDetailedName() (used internally)
    static func getRegionName(zoneID: String) -> String {
        let (_, output, _) = getDetailedName(zoneID)
        return output
    }
    
    /// Single-output version of getDetailedName() (used internally)
    static func getCityName(zoneID: String) -> String {
        let (_, _, output) = getDetailedName(zoneID)
        return output
    }
    
}

