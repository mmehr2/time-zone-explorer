//
//  TimeZoneUtilities.swift
//  TimeZoneExplorer
//
//  Created by Michael L Mehr on 1/18/16.
//  Copyright © 2016 Michael L. Mehr. All rights reserved.
//

/*
These functions relate to the ViewModel, or formatting and support for Views.
See Model-View-ViewModel pattern wiki: https://en.wikipedia.org/wiki/Model–view–viewmodel
It's mostly about formatting the various fields needed for list and detailed display of the Model class in the various ViewController classes.
*/

import Foundation
import UIKit

extension TZTimeZone {

    /// Returns the offset formatted as sHH:MM, where
    ///   s is the sign (+ or -)
    ///   HH is hours (always with leading zero if needed)
    ///   MM is minutes (always with two digits)
    /// Any seconds are truncated (see Dublin Mean Time in 1900, for example)
    static func getStandardFormatOffset( offsetSecs: Int ) -> String {
        let interval = NSTimeInterval(offsetSecs)
        let sign = (offsetSecs < 0) ? "-" : "+"
        let (offhours, offmins, _) = splitTime(interval)
        let offlead = (offhours < 10) ? "0" : "" // kludge to add leading 0 for hours<10
        let offextra = (offmins == 0) ? "0" : "" // kludge to prevent a single 0 when 0 mins
        let offstr = "\(sign)\(offlead)\(offhours):\(offmins)\(offextra)"
        return offstr
    }

    // NSDateFormatters are expensive, use only one
    private static var formatter = NSDateFormatter()
    
    /// Given params:
    ///     date - NSDate to format
    ///     zoneID - String representing name of time zone to use
    /// Returns:
    /// A tuple of four values (date, time, ampm, abb) as all Strings
    ///     date - medium date format MMM DD, YYYY
    ///     time - medium time style HH:MM:SS
    ///     ampm - the current AM/PM symbol (12-hour clock)
    ///     abb - the current abbreviation for the time type (std or daylight)
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
    
    static func getCellColor( owned: Bool ) -> UIColor {
        return owned ? SystemLook.lightColor : SystemLook.mediumColor
    }
    
}
