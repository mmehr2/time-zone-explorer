//
//  CreateNameData.swift
//  TZEAdmin
//
//  Created by Michael L Mehr on 1/16/16.
//  Copyright © 2016 Michael L. Mehr. All rights reserved.
//

import Foundation

/// use NSJSONSerialization to create Parse.com-compatible export data for all NSTimeZone.knownNames...

// create CSV list of all TZ names (IDs)
func serializeTimeZoneNames(reverse: Bool = false) -> String {
    let zoneIDs = reverse ? NSTimeZone.knownTimeZoneNames().reverse() : NSTimeZone.knownTimeZoneNames()
    let result = zoneIDs.joinWithSeparator("\n")
    return result
}

// convert one timezone into its JSON form
func zoneToJSON(zone: NSTimeZone) -> [String: AnyObject] {
    var result = [String: AnyObject]()
    result["name"] = zone.name
    result["offset"] = zone.secondsFromGMT
    //let isOK = NSJSONSerialization.isValidJSONObject(result)
    //print(  isOK ? "VALID" : "INVALID")
    return result
}

// convert entire list of time zones into data suitable for export as JSON data
func serializeTimeZoneData() -> NSData {
    let zoneIDs = NSTimeZone.knownTimeZoneNames()
    let arr = [[String: AnyObject]]()
    let jsonRaw = zoneIDs.reduce(arr) { accum, next in
        let tz = NSTimeZone(name: next)
        let json = zoneToJSON(tz!)
        return accum + [json]
    }
    var result = NSData()
    if (NSJSONSerialization.isValidJSONObject(arr)) {
        do {
            result = try NSJSONSerialization.dataWithJSONObject(jsonRaw, options: NSJSONWritingOptions.PrettyPrinted)
        } catch {
            print("Error in JSON serialization: \(error)")
        }
    }
    let final = result //.description
    return final
}

