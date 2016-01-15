//
//  RegisterViewController.swift
//  ParseTutorial
//
//  Created by Ron Kliffer on 3/6/15.
//  Copyright (c) 2015 Ron Kliffer. All rights reserved.
//

import UIKit
import Parse

class RegisterViewController: UIViewController {

    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let scrollViewWallSegue = "SignupSuccesful"
    let tableViewWallSegue = "SignupSuccesfulTable"
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Actions
    @IBAction func signUpPressed(sender: AnyObject) {
        // perform some basic validation checks -- disallow blanks anyway
        guard let userText = userTextField.text where userText != "" else {return}
        guard let passwordText = passwordTextField.text where passwordText != "" else {return}
 
        // create a parse user here (rely on Parse validation?)
        let user = PFUser();
        user.username = userText
        user.password = passwordText
        
        user.signUpInBackgroundWithBlock { succeeded, error in
            if (succeeded) {
                //The registration was successful, go to the main screen
                self.performSegueWithIdentifier(self.scrollViewWallSegue, sender: nil)
            } else if let error = error {
                //Something bad has occurred
                self.showErrorView(error)
            }
        }
    }
}
