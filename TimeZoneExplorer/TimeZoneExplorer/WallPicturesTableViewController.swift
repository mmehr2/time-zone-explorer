//
//  WallPicturesTableViewController.swift
//  ParseTutorial
//
//  Created by Ron Kliffer on 3/8/15.
//  Copyright (c) 2015 Ron Kliffer. All rights reserved.
//

import UIKit
import Parse

class WallPicturesTableViewController: UITableViewController {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Actions
    @IBAction func logOutPressed(sender: AnyObject) {
        PFUser.logOut()
        //If logout succesful:
        navigationController?.popToRootViewControllerAnimated(true)
    }
}
