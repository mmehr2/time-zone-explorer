//
//  TZSystem.swift
//  TimeZoneExplorer
//
//  Created by Michael L Mehr on 1/23/16.
//  Copyright © 2016 Michael L. Mehr. All rights reserved.
//

import Foundation

import Parse
import Bolts

class TZSystem {
    
    enum Keys : String {
        case App = "8DmXDEVyXx5obB5xjkXuGcffbI35ViFeo8AlSD79"
        case Client = "n70sX5raWJw8hFJnBcnH6etdcG4SVm2b0zr3Oc1S"
    }
    
    static func setup(launchOptions: [NSObject: AnyObject]?) {

        // [Optional] Power your app with Local Datastore. For more info, go to
        // https://parse.com/docs/ios/guide#local-datastore
        //Parse.enableLocalDatastore()
        
        // Initialize Parse.
        Parse.setApplicationId(Keys.App.rawValue,
            clientKey: Keys.Client.rawValue)
        
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        

    }
    
}