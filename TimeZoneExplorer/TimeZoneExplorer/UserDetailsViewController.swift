//
//  UserDetailsViewController.swift
//  TimeZoneExplorer
//
//  Created by Michael L Mehr on 1/20/16.
//  Copyright © 2016 Michael L. Mehr. All rights reserved.
//

import UIKit
import Parse


class UserDetailsViewController: UIViewController {
    
    var currentObject: PFUser? // source of truth about the designated user
    
    var editable: Bool = false // true if able to edit user details


    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var signUpButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        displayDetails()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func displayDetails() {
        if let currentObject = currentObject {
            // do the display if details are provided
            navigationItem.title = "Existing User Details"
            usernameField.text = currentObject.username
            passwordField.text = currentObject.password
            emailField.text = currentObject.email
            phoneField.text = currentObject["phone"] as? String
            signUpButton.enabled = false
        } else {
            // set up for data entry if no details provided
            navigationItem.title = "New User Details"
            signUpButton.enabled = false // true if 1st time user seen
        }
        // enable editing according to provided flag
        usernameField.enabled = editable
        passwordField.enabled = editable
        emailField.enabled = editable
        phoneField.enabled = editable
        saveButton.enabled = editable
    }

    // MARK: Actions
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        print("User saved.")
    }
    
    @IBAction func signUpButtonPressed(sender: AnyObject) {
        print("Signing up new user.")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
