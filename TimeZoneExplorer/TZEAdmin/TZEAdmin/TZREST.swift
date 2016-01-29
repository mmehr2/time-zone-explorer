//
//  TZREST.swift
//  TZEAdmin
//
//  Created by Michael L Mehr on 1/23/16.
//  Copyright © 2016 Michael L. Mehr. All rights reserved.
//

import Foundation

class TZREST {
    
    enum Keys : String {
        case App = "8DmXDEVyXx5obB5xjkXuGcffbI35ViFeo8AlSD79"
        case Client = "n70sX5raWJw8hFJnBcnH6etdcG4SVm2b0zr3Oc1S"
    }
    
    static let errorDomain = "com.Parse.TimeZoneExplorer"

    static let baseURL = "https://api.parse.com"
    static let apiVersion = "1"
 
}

class TZRESTCommand {
    let verb: PARSEAPI.Verb
    let path: String
    
    init() {
        verb = .GET
        path = "/1/classes/"
    }
}