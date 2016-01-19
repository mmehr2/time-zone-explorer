//
//  ClientVMUtilities.swift
//  TimeZoneExplorer
//
//  Created by Michael L Mehr on 1/18/16.
//  Copyright © 2016 Michael L. Mehr. All rights reserved.
//

import Foundation
//import Parse
//import ParseUI

extension TZClient {
    
    static func getFormattedUsernameTitle() -> String {
        return "\(TZClient.role) \(TZClient.username) is logged in."
    }
    
}