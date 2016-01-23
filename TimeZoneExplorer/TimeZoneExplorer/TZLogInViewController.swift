//
//  TZLogInViewController.swift
//  TimeZoneExplorer
//
//  Created by Michael L Mehr on 1/23/16.
//  Copyright © 2016 Michael L. Mehr. All rights reserved.
//

import UIKit

import Parse
import ParseUI

class TZLogInViewController: PFLogInViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = SystemLook.getBackgroundColor()
        
        let label = SystemLook.getLogo()
        logInView?.logo = label
    }

}
