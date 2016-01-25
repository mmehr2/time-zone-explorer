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
    
    static func isObjectCurrentUser(object: AnyObject?) -> Bool {
        var result = false
        if let cuser = currentUser, object = object as? PFUser where object.objectId == cuser.objectId {
            result = true
        }
        return result
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
            if user.ACL == nil {
                print("Deferred security check - no permissions object. Will it go away?")
            } else {
                print("Security check went away.")
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

    static func registerLoginSuccess(user: PFUser, withSignUp signupFlag: Bool = false) {
        // it's not necessary to pass the user in, it is available as the cached PFUser.currentUser() object.
        // However it is better to use Dependency Injection here to allow for better testing.
        currentUser = user
        // this is the point we need to kick off the security check mechanism (count _Role objects)
        // this will allow us to set the current Role (security level), which allows many other features
        queryRoleObjects(signupFlag)
        
        if signupFlag {
            // we also need to augment the security ACL on the provided user object and save it again to the cloud
            augmentUserSecurity()
        }
    }
    
    static func registerLoginFailure(error: NSError?, withSignUp signupFlag: Bool = false) {
        let type = signupFlag ? "Signup" : "Login"
        if let error=error {
            print("\(type) failure with error \(error)")
        } else {
            print("\(type) failure with no error object supplied.")
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

    private static func queryRoleObjects(signup: Bool = false) {
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
                }
                // NOTE: all new users are Users after signup, so there will be no objects
                // However, the search has completed without error (I hope), so run the permission change and notification.
                // user role management for new user
                if signup {
                    addCurrentUserToRole(role)
                }
                // notify the primary observer
                securityDelegate?.loginDidFinish(role)
            } else {
                // Log details of the failure
                print("Role retrieval error: \(error!) \(error!.userInfo)")
            }
        }
    }
}

// MARK: data creation services with proper ACL permissions

extension TZClient {
    
    static func createDataObjectForCurrentUser(className: String) -> PFObject {
        let object = PFObject(className: className)
        // make sure proper security ACL is provided for normal data class
        // NOTE: this also works for User objects
        addManagerPermissions(object)
        return object
    }
    
    static func addManagerPermissions(object: PFObject) {
        // if object has no ACL, make one like Parse defaults
        if object.ACL == nil {
            // regular data: step 1 - RW by current user
            // save this permission into the data object
            object.ACL = PFACL(user: currentUser)
        }
        // step 2 - RW by Managers role
        // takes the ACL from object if it exists, and adds manager RW access to it
        if let ACL = object.ACL {
            ACL.setReadAccess(true, forRoleWithName: Role.Manager.name)
            ACL.setWriteAccess(true, forRoleWithName: Role.Manager.name)
        }
    }
    
    static func augmentUserSecurity() {
        // set manager permissions on currentUser's ACL
        addManagerPermissions(currentUser)
        // save the object on a background thread eventually
        currentUser.saveEventually()
    }
    
    static func addCurrentUserToRole(role: Role) {
        // NOTE: THIS DOESN'T WORK FOR THE USER ROLE, ONLY MGR OR ADMIN
        // Unfortunately on signup ALL users are in the User role, and only a Manager or Admin can do their Role management.
        // We could punt and just say that the Users role isn't used anyway, so no need to fill it out.
        // And the managers may opt to add the user role using the script in the meantime, anyway.
        // This will probably prove useful later when we add UI to change roles by Admins in the app.
        if let roleObj = getObjectForRole(role) {
            // add the current logged-in user to this roleObj's users relation
            roleObj.users.addObject(currentUser)
        }
    }
    
    static func getObjectForRole(role: Role) -> PFRole? {
        var result: PFRole?
        // user can't access the Users PFRole object to add his name.. hmmmmm!
        if role != .User {
            // else if we are a Manager, there are 2 to choose from, and 3 for an Admin
            result = currentRoles.filter{ $0.name == role.name }.first
        }
        return result
    }

}

extension TZClient {
    /// determine if provided object (as PFObject) has ACL that allows write explicity to current user
    /// This is the only way currently to tell if the given object was created by the current user.
    static func isObjectMine(object: AnyObject?) -> Bool {
        var result = false
        if let object = object as? PFObject,
            access = object.ACL?.getWriteAccessForUser(currentUser) {
                result = access
        }
        return result
    }

    /// Splits an array of PFObjects into two using the criterion of whether currentUser has Write access.
    /// Returns a tuple of arrays; the first one contains those with W access, the second, those without.
    static func getMyObjects(objects: [AnyObject]) -> (mine: [AnyObject], theirs: [AnyObject]) {
        var myobjs = [AnyObject]()
        var theirobjs = [AnyObject]()
        for obj in objects {
            if isObjectMine(obj) {
                myobjs.append(obj)
            } else {
                theirobjs.append(obj)
            }
        }
        return (myobjs, theirobjs)
    }
}

