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
class TZClient {

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
    
    enum Role {
        case User
        case Manager
        case Administrator
    }
    
    static var role: Role {
        // TBD: figure out from PFUser role
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

}
