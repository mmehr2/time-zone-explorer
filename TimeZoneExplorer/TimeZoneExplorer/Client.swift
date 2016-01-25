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

protocol TZClientSecurityDelegate {
    /// Notify the client that security info has been refreshed on login
    func loginDidFinish( role: TZClient.Role );
}

class TZClient {
    
    // delegates
    static var securityDelegate: TZClientSecurityDelegate?
    
    static var username: String {
        if TZClient.loggedIn {
            let username = currentUser.username ?? "Anonymous"
            return username
        }
        return "UserIsNotLoggedIn"
    }

    private static var currentUser: PFUser!
    
    private static var currentRoles = [PFRole]()
    
    enum LoginState {
        case NoUser
        case NotAuthenticated
        case Authenticated
    }
    
    static func getLoginState() -> LoginState {
        var result = LoginState.NoUser
        if let user = PFUser.currentUser() {
            if currentUser == nil {
                // time to kick off the static first-try init of the role objects
                queryRoleObjects()
                print("Called getLoginState() for the 1st time to ask for Roles.")
            }
            currentUser = user
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
        // trigger the logout using cached Parse objects
        PFUser.logOut()
    }

    static func registerLoginSuccess(user: PFUser) {
        // it's not necessary to pass the user in, it is available as the cached PFUser.currentUser() object.
        // However it is better to use Dependency Injection here to allow for better testing.
        currentUser = user
        // this is the point we need to kick off the security check mechanism (count _Role objects)
        // this will allow us to set the current Role (security level), which allows many other features
        queryRoleObjects()
    }
    
    static func registerLoginFailure(error: NSError?) {
        if let error=error {
            print("Login failure with error \(error)")
        } else {
            print("Login failure with no error object supplied.")
        }
    }

    // manually trigger the login (deprecated, use PFLogInViewController instead)
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
        switch currentRoles.count {
        case 2: return Role.Manager
        case 3: return Role.Administrator
        default: break
        }
        return Role.User
    }

    private static func queryRoleObjects() {
        // find out the _Role class objects we can find
        let query = PFQuery(className:"_Role")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) Roles.")
                // Do something with the found objects
                if let objects = objects as? [PFRole] {
                    currentRoles = objects
                    // notify the primary observer
                    securityDelegate?.loginDidFinish(role)
                }
            } else {
                // Log details of the failure
                print("Role retrieval error: \(error!) \(error!.userInfo)")
            }
        }
    }
}
