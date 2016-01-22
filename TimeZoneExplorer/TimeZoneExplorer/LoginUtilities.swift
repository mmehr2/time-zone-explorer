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

    enum LoginState {
        case NoUser
        case NotAuthenticated
        case Authenticated
    }
    
    static func getLoginState() -> LoginState {
        var result = LoginState.NoUser
        if let user = PFUser.currentUser() {
            if user.authenticated {
                result = .Authenticated;
            } else {
                result = .NotAuthenticated
            }
        }
        return result
    }
    
    static var loggedIn: Bool {
        return TZClient.getLoginState() == .Authenticated
    }
    
    static func logoutCurrentUser() {
        PFUser.logOut()
    }
    
    static func loginUser(username: String, password: String, completion: ((TZClient?, String?) -> ())? = nil) {
        PFUser.logInWithUsernameInBackground(username, password: password) { user, error in
        }
    }
    
    enum Role : CustomStringConvertible {
        case User
        case Manager
        case Administrator
    
        var description: String {
            switch self {
            case .User: return "User"
            case .Manager: return "Manager"
            case .Administrator: return "Administrator"
            }
        }
    }
    
    static var role: Role {
        // TBD: figure out from current PFUser role
        return Role.User
    }
    
    static func getLoginViewControllerFor(presentingVC: UIViewController) -> PFLogInViewController {
        let logInController = PFLogInViewController()
        if TZClient.loggedIn {
            logInController.fields = [ .UsernameAndPassword, .DismissButton ]
        } else {
            logInController.fields = [ .UsernameAndPassword ]
        }
        logInController.delegate = (presentingVC as! PFLogInViewControllerDelegate)
        return logInController
    }

    static var username: String {
        if TZClient.loggedIn {
            let user = PFUser.currentUser()!
            let username = user.username ?? "Anonymous"
            return username
        }
        return "UserIsNotLoggedIn"
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
