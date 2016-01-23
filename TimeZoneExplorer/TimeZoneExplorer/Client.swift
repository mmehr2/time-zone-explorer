//
//  Client.swift
//  TimeZoneExplorer
//
//  Created by Michael L Mehr on 1/21/16.
//  Copyright © 2016 Michael L. Mehr. All rights reserved.
//

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
    
    static func loginUser(username: String, password: String, completion: ((TZClient?, String?) -> ())? = nil) {
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
    }
    
    static var role: Role {
        // TBD: figure out from current PFUser role
        return Role.User
    }
    
}
