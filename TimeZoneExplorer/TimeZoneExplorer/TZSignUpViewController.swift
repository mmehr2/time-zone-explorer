//
//  TZSignUpViewController.swift
//  TimeZoneExplorer
//
//  Created by Michael L Mehr on 1/23/16.
//  Copyright © 2016 Michael L. Mehr. All rights reserved.
//

import UIKit

import Parse
import ParseUI

class TZSignUpViewController: PFSignUpViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = SystemLook.darkColor
        
        let label = SystemLook.getLogo()
        signUpView?.logo = label
    }
    

}
