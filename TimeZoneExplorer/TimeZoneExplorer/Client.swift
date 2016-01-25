//
//  Client.swift
//  TimeZoneExplorer
//
//  Created by Michael L Mehr on 1/21/16.
//  Copyright © 2016 Michael L. Mehr. All rights reserved.
//

/*
PARSE SECURITY MODEL USED BY THIS APP
Please see the approach taken in the README.md file.
*/

import Foundation
import Parse

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
    
    static func logoutCurrentUser() {
        PFUser.logOut()
    }

    static func registerLoginSuccess() {
        // it's not necessary to pass the user in, it is available as the cached PFUser.currentUser() object.
        // this is the point we need to kick off the security check mechanism (count _Role objects)
        // this will allow us to set the current Role (security level), which allows many other features
    }
    
    static func registerLoginFailure(error: NSError?) {
        if let error=error {
            print("Login failure with error \(error)")
        } else {
            print("Login failure with no error object supplied.")
        }
    }
    
    static func loginUserEx(username: String, password: String, completion: ((TZClient?, String?) -> ())? = nil) {
        PFUser.logInWithUsernameInBackground(username, password: password) { user, error in
        }
    }
    
    // MARK: role functions
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
        
        /// The name of the _Role object in Parse
        var name: String {
            switch self {
            case .User: return "Users"
            case .Manager: return "Managers"
            case .Administrator: return "Administrators"
            }
        }
    }
    
    static var role: Role {
        // TBD: figure out from current PFUser role
        return Role.User
    }
    
}
