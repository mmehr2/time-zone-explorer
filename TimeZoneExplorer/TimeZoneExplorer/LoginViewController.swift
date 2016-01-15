//
//  LoginViewController.swift
//  ParseTutorial
//
//  Created by Ron Kliffer on 3/6/15.
//  Copyright (c) 2015 Ron Kliffer. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let scrollViewWallSegue = "LoginSuccesful"
    let tableViewWallSegue = "LoginSuccesfulTable"
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //Check if user exists and logged in
        if let user = PFUser.currentUser() {
            if user.authenticated {
                // bypass the login screen entirely, go directly to main screen
                self.performSegueWithIdentifier(scrollViewWallSegue, sender: nil)
            }
        }
    }

    // MARK: - Actions
    @IBAction func logInPressed(sender: AnyObject) {
        // perform some basic validation checks -- disallow blanks anyway
        guard let userText = userTextField.text where userText != "" else {return}
        guard let passwordText = passwordTextField.text where passwordText != "" else {return}
        
        PFUser.logInWithUsernameInBackground(userText, password: passwordText) { user, error in
            if user != nil {
                // if successfully logged in, go to the main screen
                self.performSegueWithIdentifier(self.scrollViewWallSegue, sender: nil)
            } else if let error = error {
                self.showErrorView(error)
            }
        }
    }
}
