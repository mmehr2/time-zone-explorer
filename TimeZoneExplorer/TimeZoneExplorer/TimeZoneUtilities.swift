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

    /// Returns the offset formatted as sHH:MM, where
    ///   s is the sign (+ or -)
    ///   HH is hours (always with leading zero if needed)
    ///   MM is minutes (always with two digits)
    /// Any seconds are truncated (see Dublin Mean Time in 1900, for example)
    static func getStandardFormatOffset( offsetSecs: Int ) -> String {
        let offset = offsetSecs
        let offabs = abs(offset)
        let offhours = offabs/3600
        let offmins = (offabs%3600) / 60
        let offlead = (offhours < 10) ? "0" : "" // kludge to add leading 0 for hours<10
        let offextra = (offmins == 0) ? "0" : "" // kludge to prevent a single 0 when 0 mins
        let offstr = "\(offset<0 ? "-" : "+")\(offlead)\(offhours):\(offmins)\(offextra)"
        return offstr
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

    private static var formatter = NSDateFormatter()
    
    /// Given:
    /// @param date - NSDate to format
    /// @param zoneID - String representing name of time zone to use
    /// Returns:
    /// tuple of four values (date, time, ampm, abb) as all Strings
    /// @returns date - medium date format MMM DD, YYYY
    /// @returns time - medium time style HH:MM:SS
    /// @returns ampm - the current AM/PM symbol (12-hour clock)
    /// @returns abb - the current abbreviation for the time type (std or daylight)
    static func getClock( date: NSDate, formattedForZone zoneID: String ) -> (date: String, time: String, ampm: String, abb: String) {
        var result = ("No date", "..:..:..", "..", "...")
        if let zone = NSTimeZone(name: zoneID) {
            formatter.timeZone = zone
            // is the default locale okay?
            formatter.timeStyle = .NoStyle
            formatter.dateStyle = .MediumStyle // January 16, 2016
            let dateOutput = formatter.stringFromDate(date)
            formatter.timeStyle = .LongStyle // HH:MM:SS PM PST
            formatter.dateStyle = .NoStyle
            let timeStr = formatter.stringFromDate(date)
            let segs = timeStr.componentsSeparatedByString(" ")
            result = (dateOutput, segs[0], segs[1], segs[2])
       }
        return result
    }

    /// Returns Apple standard description string for time zone (name, abbrev, offset, DST)
    static func getDescription( zoneID: String ) -> String {
        var result = ""
        if let zone = NSTimeZone(name: zoneID) {
            result = "\(zone)"
        }
        return result
    }
    
    static func getStandardFormat( zoneID: String ) -> String {
        var result = ""
        if let (abbrev, offset) = TZTimeZone.getTimeInfo(zoneID, type: .Standard) {
            // convert offset to hours/minutes standard form
            let abbrevstr: String
            if let abbrev = abbrev {
                abbrevstr = " [\(abbrev)]"
            } else {
                abbrevstr = ""
            }
            let offstr = TZTimeZone.getStandardFormatOffset(offset)
            result = "\(zoneID) (GMT\(offstr))\(abbrevstr)"
        }
        return result
    }
    
    static func getZoneID( stdFormatInput: String ) -> String {
        var result:String = ""
        // truncate string at first occurrence of " ("
        if let foundRange = stdFormatInput.rangeOfString(" (") {
            result = stdFormatInput.substringToIndex(foundRange.startIndex)
        }
        return result
    }
    
    static func getDetailedName(zoneID: String) -> (area: String, region: String, city: String) {
        let segs = zoneID.componentsSeparatedByString("/")
        switch segs.count {
        case 1: return (segs[0], "", "")
        case 2: return (segs[0], "", segs[1])
        case 3: return (segs[0], segs[1], segs[2])
        default: return ("", "", "")
        }
    }
    
}
