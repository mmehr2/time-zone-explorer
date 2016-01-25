//
//  LoginUtilities.swift
//  TimeZoneExplorer
//
//  Created by Michael L Mehr on 1/18/16.
//  Copyright © 2016 Michael L. Mehr. All rights reserved.
//

import Foundation
import Parse
import ParseUI

// needs of project for its User class (encompasses all roles: User, Manager, Administrator)
extension TZClient {
    
    static func getLoginViewControllerFor(presentingVC: UIViewController) -> PFLogInViewController {
        let logInController = TZLogInViewController()
        logInController.signUpController = TZSignUpViewController()
        if TZClient.loggedIn {
            logInController.fields = [ .UsernameAndPassword, .SignUpButton, .DismissButton ]
        } else {
            logInController.fields = [ .UsernameAndPassword, .SignUpButton ]
        }
        logInController.delegate = (presentingVC as! PFLogInViewControllerDelegate)
        return logInController
    }

}

// Keeping this code around in case...
//    // MARK: - Actions
//    @IBAction func logInPressed(sender: AnyObject) {
//        performLoginSegue()
//        // perform some basic validation checks -- disallow blanks anyway
//        guard let userText = userTextField.text where userText != "" else {return}
//        guard let passwordText = passwordTextField.text where passwordText != "" else {return}
//
//        PFUser.logInWithUsernameInBackground(userText, password: passwordText) { user, error in
//            if user != nil {
//                // if successfully logged in, go to the main screen for the type of user
//                let loginSegue = self.getLoginSegue()
//                self.performSegueWithIdentifier(loginSegue, sender: nil)
//            } else if let error = error {
//                self.showErrorView(error)
//            }
//        }
//    }
//
//    @IBAction func logOutPressed(sender: AnyObject) {
//        PFUser.logOut()
//        //If logout succesful:
//        navigationController?.popToRootViewControllerAnimated(true)
//    }
//
//    @IBAction func signUpPressed(sender: AnyObject) {
//        // perform some basic validation checks -- disallow blanks anyway
//        guard let userText = userTextField.text where userText != "" else {return}
//        guard let passwordText = passwordTextField.text where passwordText != "" else {return}
//
//        // create a parse user here (rely on Parse validation?)
//        let user = PFUser();
//        user.username = userText
//        user.password = passwordText
//
//        user.signUpInBackgroundWithBlock { succeeded, error in
//            if (succeeded) {
//                //The registration was successful, go to the main screen
//                self.performSegueWithIdentifier(self.someSegue, sender: nil)
//            } else if let error = error {
//                //Something bad has occurred
//                self.showErrorView(error)
//            }
//        }
//    }
