//
//  main.swift
//  TZEAdmin
//
//  Created by Michael L Mehr on 1/16/16.
//  Copyright © 2016 Michael L. Mehr. All rights reserved.
//

// NOTE: This looks like it's still as useful as ever: rm -rf ~/Library/Developer/Xcode/DerivedData/ModuleCache

import Foundation

class Main {
    
    let commandList: String = [
        "SESSIONS (for all)\n",
        "\tSIGNUP - Create a new user (takes -n Name -p Password, returns SessionID,UserID)\n",
        "\tLOGIN - Login specified user (takes -n Name -p Password, returns SessionID,UserID)\n",
        "\tLOGOUT - Logout current user session (takes -s SessionID)\n",
        
        "DATA (for all, but -u ignored for non-Mgr/Admin sessions)\n",
        "\tGETZONELIST - Get specified user's time zone list (takes -s SessionID [[-u UserID | -U UserName]], returns List[ZoneName])\n",
        "\tADDTOZONELIST - Adds an entry to specified user's time zone list (takes -s SessionID [[-u UserID | -U UserName]] -n ZoneName)\n",
        "\tDELETEFROMZONELIST - Deletes an entry from specified user's time zone list (takes -s SessionID [[-u UserID | -U UserName]] -n ZoneName)\n",
        "\tGETMASTERTZLIST - Get the master list of time zone names (takes -s SessionID, returns List[ZoneName])\n",
        
        "USERS (for Mgr,Admin sessions only)\n",
        "\tGETUSERLIST - Get specified mgr's user list (takes -s SessionID, returns List[UserName])\n",
        "\tGETUSERDATA - Get specified user's user data (takes -s SessionID [-u UserID | -U UserName], returns Obj[UserData])\n",
        "\tCREATEUSER - Create a new user w/o login (takes -s SessionID -n Name -p Password [-e email][-P phone], returns newly created UserID)\n",
        "\tUPDATEUSER - Update user data (takes -s SessionID [-u UserID | -U UserName] [-n Name][-p Password][-e email][-P phone])\n",
        "\tDELETEUSER - Delete user from system (takes -s SessionID [-u UserID | -U UserName])\n",
        
        "ROLES (for Admin sessions only)\n",
        "\tGETROLELIST - Get security role list (takes -s SessionID, returns List[RoleName])\n",
        "\tGETROLEDATA - Get security role data (takes -s SessionID -r RoleName, returns {RoleName, List[RoleName], List[UserName]})\n",
        "\tCREATEROLE - Create a new security role (takes -s SessionID -r RoleName, returns newly created RoleID)\n",
        "\tDELETEROLE - Delete role from system (takes -s SessionID -r RoleName)\n",
        "\tGETROLEUSERS - Get list of user names with given role (takes -s SessionID -r RoleName, returns List[UserName])\n",
        "\tGETUSERROLE - Get role of specified user (takes -s SessionID [-u UserID | -U UserName], returns RoleName)\n",
        "\tSETUSERROLE - Sets role of specified user (takes -s SessionID [-u UserID | -U UserName] -r RoleName)\n",
        "\tGETROLEROLES - Get list of child roles of the given role (takes -s SessionID -r RoleName, returns List[RoleName])\n",
        "\tADDROLEROLES - Add role to roles/children of target role (takes -s SessionID -r TargetRoleName -n RoleName)\n",
        "\tREMOVEROLEROLES - Remove role from roles/children of target role (takes -s SessionID -r TargetRoleName -n RoleName)\n",
       
        "MISC (for Admin sessions only)\n",
        "\tGENMASTERTZLIST - Generate the master time zone list data in CSV format (takes -s SessionID)\n",
        "\tSETMASTERTZLIST - Set the master list of time zone names (takes -s SessionID -D CSV-Data-File-Path)\n",
        ].reduce("") { acc, str in acc + str }
    
    enum TZError: ErrorType {
        case ShowHelp
        case ShowCommandList
        case MissingOption(String)
        case IncompatibleOption(String)
    }
    
    
    
    // ADMIN TASKS:
    func runCommands(arguments: [String] = Process.arguments) -> Int32 {

        // capture current values of CL variables from arguments list
        let command = StringOption(shortFlag: "c", helpMessage: "Specify the REST API command to use.\n\(commandList)")
        let data = StringOption(shortFlag: "D", helpMessage: "Specify the REST API DataFile path command parameter.")
        //let list = MultiStringOption(shortFlag: "L", helpMessage: "Specify the REST API List[X] command parameter.")
        let curl = BoolOption(shortFlag: "C", helpMessage: "Specify whether to just generate cURL output (default is to execute cmd).")
        
        let id = StringOption(shortFlag: "i", helpMessage: "Specify the REST API Object ID command parameter.")
        let session = StringOption(shortFlag: "s", helpMessage: "Specify the REST API SessionID command parameter.")
        let usrid = StringOption(shortFlag: "u", helpMessage: "Specify the REST API UserID command parameter.")
        let usrname = StringOption(shortFlag: "U", helpMessage: "Specify the REST API User Name command parameter.")
        let role = StringOption(shortFlag: "r", helpMessage: "Specify the REST API Role Name command parameter.")
        
        let name = StringOption(shortFlag: "n", helpMessage: "Specify the REST API Name command parameter.")
        let pwd = StringOption(shortFlag: "p", helpMessage: "Specify the REST API Password command parameter.")
        let phone = StringOption(shortFlag: "P", helpMessage: "Specify the REST API Phone command parameter.")
        let email = StringOption(shortFlag: "e", helpMessage: "Specify the REST API Email command parameter.")
        
        let options = [command,    curl, data, email, id, name, pwd, phone, role, session, usrid, usrname]
        
        let cli = CommandLine(arguments: arguments)
        
        cli.addOptions(options)
        
        do {
            try cli.parse()
            
            if let comd = command.value {
                
                // set up some common usage variables
                let curlOpt = curl.value ? " {CURL=ON}" : ""
                let cmdStr = comd + curlOpt + " ("
                let sidopt = session.wasSet ? " SID=\(session.value!)" : ""
                let nameopt = name.wasSet ? " name=\(name.value!)" : ""
                let roleopt = role.wasSet ? " role=\(role.value!)" : ""
                let pwdopt = pwd.wasSet ? " pwd=\(pwd.value!)" : ""
                let dataopt = data.wasSet ? " data=\(data.value!)" : ""
                let emailopt = email.wasSet ? " email=\(email.value!)" : ""
                let phoneopt = phone.wasSet ? " phone=\(phone.value!)" : ""
                let retVoid = " ) -> ()"
                let retSID = " ) -> SID"
                let retZL = " ) -> [ZoneName]"
                let retUL = " ) -> [UserName]"
                // guard against using BOTH user options
                let usropt: String
                switch (usrid.value, usrname.value) {
                case (.Some, .Some): throw TZError.IncompatibleOption(usrid.shortFlag! + " and " + usrname.shortFlag!)
                case (.Some(let uid), .None): usropt = ", UID=\(uid)"
                case (.None, .Some(let uname)): usropt = ", UsrName=\(uname)"
                default: usropt = ""
                }
                
                // dispatch all -c commands
                switch command.value! {
                case "SIGNUP":
                    // requires -n UserName -p Pwd
                    if !name.wasSet { throw TZError.MissingOption(name.shortFlag!) }
                    if !pwd.wasSet { throw TZError.MissingOption(pwd.shortFlag!) }
                    // returns SID (USID if User session, MSID if Mgr session, ASID if Admin session)
                    print(cmdStr + nameopt + pwdopt + retSID)
                    break
                case "LOGIN":
                    // requires -n UserName -p Pwd
                    if !name.wasSet { throw TZError.MissingOption(name.shortFlag!) }
                    if !pwd.wasSet { throw TZError.MissingOption(pwd.shortFlag!) }
                    // returns SID (USID if User session, MSID if Mgr session, ASID if Admin session)
                    print(cmdStr + nameopt + pwdopt + retSID)
                    break
                case "LOGOUT":
                    // requires -s SID
                    if !session.wasSet { throw TZError.MissingOption(session.shortFlag!) }
                    print(cmdStr + sidopt + retVoid)
                    break
                case "GETZONELIST":
                    // requires -s SID
                    if !session.wasSet { throw TZError.MissingOption(session.shortFlag!) }
                    // optional -u UID or -U username (for Mgr/Admin)
                    // returns L[ZoneName]
                    print(cmdStr + sidopt + usropt + retZL)
                    break
                case "ADDTOZONELIST":
                    // requires -s SID -n ZoneName
                    if !session.wasSet { throw TZError.MissingOption(session.shortFlag!) }
                    if !name.wasSet { throw TZError.MissingOption(name.shortFlag!) }
                    // optional -u UID or -U username (for Mgr/Admin)
                    print(cmdStr + sidopt + nameopt + usropt + retVoid)
                    break
                case "DELETEFROMZONELIST":
                    // requires -s SID -n ZoneName
                    if !session.wasSet { throw TZError.MissingOption(session.shortFlag!) }
                    if !name.wasSet { throw TZError.MissingOption(name.shortFlag!) }
                    // optional -u UID or -U username (for Mgr/Admin)
                    print(cmdStr + sidopt + nameopt + usropt + retVoid)
                    break
                case "GETMASTERTZLIST":
                    // requires -s SID
                    if !session.wasSet { throw TZError.MissingOption(session.shortFlag!) }
                    // returns L[ZoneName] (all possible names)
                    print(cmdStr + sidopt + retZL)
                    break
                case "SETMASTERTZLIST":
                    // requires -s ASID -D dataFileCSVPath
                    if !session.wasSet { throw TZError.MissingOption(session.shortFlag!) }
                    if !data.wasSet { throw TZError.MissingOption(data.shortFlag!) }
                    print(cmdStr + sidopt + dataopt + retVoid)
                    break
                case "GETUSERLIST":
                    // requires -s MASID
                    if !session.wasSet { throw TZError.MissingOption(session.shortFlag!) }
                    // returns L[UserName]
                    print(cmdStr + sidopt + retUL)
                    break
                case "GETUSERDATA":
                    // requires -s MASID ...
                    if !session.wasSet { throw TZError.MissingOption(session.shortFlag!) }
                    // requires -u UID or -U username (for Mgr/Admin)
                    if !usrid.wasSet && !usrname.wasSet { throw TZError.MissingOption("\(usrid.shortFlag!) or \(usrname.shortFlag!)") }
                    // returns UserData (name, email, phone, pwdFlag)
                    print(cmdStr + sidopt + usropt + " ) -> {name,email,phone}")
                    break
                case "CREATEUSER":
                    // requires -s MASID -n UserName -p Pwd
                    if !session.wasSet { throw TZError.MissingOption(session.shortFlag!) }
                    if !name.wasSet { throw TZError.MissingOption(name.shortFlag!) }
                    if !pwd.wasSet { throw TZError.MissingOption(pwd.shortFlag!) }
                    // optional -e Email -P phone
                    // returns UID (no login)
                    // validates: UserName unique/nonblank, Email unique/nonblank
                    print(cmdStr + sidopt + nameopt + pwdopt + emailopt + phoneopt + retVoid)
                    break
                case "UPDATEUSER":
                    // requires -s MASID ...
                    if !session.wasSet { throw TZError.MissingOption(session.shortFlag!) }
                    // requires -u UID or -U username (for Mgr/Admin)
                    if !usrid.wasSet && !usrname.wasSet { throw TZError.MissingOption("\(usrid.shortFlag!) or \(usrname.shortFlag!)") }
                    // optional -n UserName -p Pwd -e Email -P phone
                    // validates: UserName unique/nonblank, Email unique if nonblank
                    print(cmdStr + sidopt + usropt + nameopt + pwdopt + emailopt + phoneopt + retVoid)
                    break
                case "DELETEUSER":
                    // requires -s MASID ...
                    if !session.wasSet { throw TZError.MissingOption(session.shortFlag!) }
                    // requires -u UID or -U username (for Mgr/Admin)
                    if !usrid.wasSet && !usrname.wasSet { throw TZError.MissingOption("\(usrid.shortFlag!) or \(usrname.shortFlag!)") }
                    print(cmdStr + sidopt + usropt + retVoid)
                    break
                    
                case "GETROLELIST":
                    // requires -s ASID
                    if !session.wasSet { throw TZError.MissingOption(session.shortFlag!) }
                    // returns L[RoleName]
                    print(cmdStr + sidopt + " ) -> [RoleName]")
                    break
                case "GETROLEDATA":
                    // requires -s ASID -r RoleName
                    if !session.wasSet { throw TZError.MissingOption(session.shortFlag!) }
                    if !role.wasSet { throw TZError.MissingOption(role.shortFlag!) }
                    // returns RoleName, L[UID], L[RID](0 or 1 child in problem's implementation)
                    print(cmdStr + sidopt + roleopt + " ) -> {RoleName,[RoleName],[UserName]}")
                    break
                case "CREATEROLE":
                    // requires -s ASID -r RoleName (must be unique among Roles)
                    if !session.wasSet { throw TZError.MissingOption(session.shortFlag!) }
                    if !role.wasSet { throw TZError.MissingOption(role.shortFlag!) }
                    print(cmdStr + sidopt + roleopt + retVoid)
                    break
                case "DELETEROLE":
                    // requires -s ASID -r RoleName
                    if !session.wasSet { throw TZError.MissingOption(session.shortFlag!) }
                    if !role.wasSet { throw TZError.MissingOption(role.shortFlag!) }
                    // deletes role from system IFF users list is empty
                    print(cmdStr + sidopt + roleopt + retVoid)
                    break
                case "GETROLEUSERS":
                    // requires -s ASID -r RoleName
                    if !session.wasSet { throw TZError.MissingOption(session.shortFlag!) }
                    if !role.wasSet { throw TZError.MissingOption(role.shortFlag!) }
                    // returns L[UserName] that is contents of users relation of role
                    print(cmdStr + sidopt + roleopt + retUL)
                    break
                case "GETUSERROLE":
                    // requires -s ASID ...
                    if !session.wasSet { throw TZError.MissingOption(session.shortFlag!) }
                    // requires -u UID or -U username
                    if !usrid.wasSet && !usrname.wasSet { throw TZError.MissingOption("\(usrid.shortFlag!) or \(usrname.shortFlag!)") }
                    // returns RoleName of role user is member of users list of
                    print(cmdStr + sidopt + usropt + " ) -> RoleName")
                    break
                case "SETUSERROLE":
                    // requires -s ASID -r RoleName ...
                    if !session.wasSet { throw TZError.MissingOption(session.shortFlag!) }
                    if !role.wasSet { throw TZError.MissingOption(role.shortFlag!) }
                    // requires -u UID or -U username (for Mgr/Admin)
                    if !usrid.wasSet && !usrname.wasSet { throw TZError.MissingOption("\(usrid.shortFlag!) or \(usrname.shortFlag!)") }
                    // adds user to users relation of role
                    print(cmdStr + sidopt + usropt + roleopt + retVoid)
                    break
                case "GETROLEROLES":
                    // requires -s ASID -r RoleName
                    if !session.wasSet { throw TZError.MissingOption(session.shortFlag!) }
                    if !role.wasSet { throw TZError.MissingOption(role.shortFlag!) }
                    // returns L[RoleName] that is contents of roles/child relation of role
                    print(cmdStr + sidopt + roleopt + retUL)
                    break
                case "ADDROLEROLES":
                    // requires -s ASID -r RoleName (target) -n RoleName (to be added to target's roles relation)
                    if !session.wasSet { throw TZError.MissingOption(session.shortFlag!) }
                    if !role.wasSet { throw TZError.MissingOption(role.shortFlag!) }
                    if !name.wasSet { throw TZError.MissingOption(name.shortFlag!) }
                    // adds specified role to roles relation of target role
                    print(cmdStr + sidopt + roleopt + nameopt + retVoid)
                    break
                case "REMOVEROLEROLES":
                    // requires -s ASID -r RoleName (target) -n RoleName (to be removed from target's roles relation)
                    if !session.wasSet { throw TZError.MissingOption(session.shortFlag!) }
                    if !role.wasSet { throw TZError.MissingOption(role.shortFlag!) }
                    if !name.wasSet { throw TZError.MissingOption(name.shortFlag!) }
                    // removes specified role from roles relation of target role
                    print(cmdStr + sidopt + roleopt + nameopt + retVoid)
                    break
               case "GENMASTERTZLIST":
                    // requires -s SID
                    if !session.wasSet { throw TZError.MissingOption(session.shortFlag!) }
                    // returns L[ZoneName] (all possible names)
                    print(serializeTimeZoneNames(true))
                default:
                    // other -c commands aren't currently accepted
                    throw TZError.ShowCommandList
                }
            } else {
                // no -c command specified
                throw TZError.ShowHelp
            }
            return(EX_OK)
        } catch TZError.ShowCommandList {
            print("Invalid command; Please use the following list of comamnds:\n\(commandList)")
            return(EX_USAGE)
        } catch TZError.ShowHelp {
            cli.printUsage()
            return(EX_USAGE)
        } catch {
            cli.printUsage(error)
            return(EX_USAGE)
        }
    }
    
}

let retval = Main().runCommands()
exit(retval)

