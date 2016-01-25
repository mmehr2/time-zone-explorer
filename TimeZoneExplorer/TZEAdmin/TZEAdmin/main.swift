//
//  main.swift
//  TZEAdmin
//
//  Created by Michael L Mehr on 1/16/16.
//  Copyright © 2016 Michael L. Mehr. All rights reserved.
//

import Foundation

let cli = CommandLine()

let commandList: String = [
    "SESSIONS (for all)\n",
    "\tSIGNUP - Create a new user (takes -n Name -p Password, returns SessionID,UserID)\n",
    "\tLOGIN - Login specified user (takes -n Name -p Password, returns SessionID,UserID)\n",
    "\tLOGOUT - Logout current user session (takes -i SessionID)\n",
    "DATA (for all)\n",
    "\tGETZONELIST - Get specified user's time zone list (takes -u UserID, returns List[ZoneName])\n",
    "\tADDTOZONELIST - Adds an entry to specified user's time zone list (takes -u UserID -n ZoneName)\n",
    "\tDELETEFROMZONELIST - Deletes an entry from specified user's time zone list (takes -u UserID -n ZoneName)\n",
    "\tGETMASTERTZLIST - Get the master list of time zone names (returns List[ZoneName])\n",
    "\tSETMASTERTZLIST - Set the master list of time zone names (takes -a AdminID -D CSV-Data-File-Path)\n",
    "USERS (for MgrID,AdminID only)\n",
    "\tGETUSERLIST - Get specified mgr's user list (takes -m MgrID, returns List[UserName])\n",
    "\tGETUSERDATA - Get specified user's object data (takes -m MgrID, returns Obj[UserData])\n",
    "\tCREATEUSER - Create a new user w/o login (takes -m MgrID -n Name -p Password [-e email][-P phone], returns UserID)\n",
    "\tUPDATEUSER - Update user data (takes -m MgrID -u UserID [-n Name][-p Password][-e email][-P phone])\n",
    "\tDELETEUSER - Delete user from system (takes -m MgrID -n Name)\n",
    "ROLES (for AdminID only)\n",
    "\tGETROLELIST - Get security role list (takes -a AdminID, returns List[RoleName])\n",
    "\tCREATEROLE - Create a new security role (takes -a AdminID -n RoleName, returns RoleID)\n",
    "\tDELETEROLE - Delete role from system (takes -a AdminID -n RoleName)\n",
    "\tGETUSERROLE - Get RoleName of specified user (takes -a AdminID [-u UserID | -U UserName], returns RoleName)\n",
    "\tSETUSERROLE - Sets RoleName of specified user (takes -a AdminID [-u UserID | -U UserName] -n RoleName)\n",
    "\tGETROLEUSERS - Get list of user names with given role (takes -a AdminID -n RoleName, returns List[UserName])\n",
    "MISC\n",
    "\tGENMASTERTZLIST - Generate the master time zone list data in CSV format (takes -a AdminID)\n",
    ].reduce("") { acc, str in acc + str }

enum TZError: ErrorType {
    case ShowHelp
    case ShowCommandList
}


let command = StringOption(shortFlag: "c", helpMessage: "Specify the REST API command to use.\n\(commandList)")
let data = StringOption(shortFlag: "D", helpMessage: "Specify the REST API DataFile path command parameter.")
let list = MultiStringOption(shortFlag: "L", helpMessage: "Specify the REST API List[X] command parameter.")
let curl = BoolOption(shortFlag: "C", helpMessage: "Specify whether to just generate cURL output (default is to execute cmd).")

let id = StringOption(shortFlag: "i", helpMessage: "Specify the REST API Object ID command parameter.")
let adminid = StringOption(shortFlag: "a", helpMessage: "Specify the REST API Admin UserID command parameter.")
let mgrid = StringOption(shortFlag: "m", helpMessage: "Specify the REST API Manager UserID command parameter.")
let usrid = StringOption(shortFlag: "u", helpMessage: "Specify the REST API UserID command parameter.")

let name = StringOption(shortFlag: "n", helpMessage: "Specify the REST API Name command parameter.")
let pwd = StringOption(shortFlag: "p", helpMessage: "Specify the REST API Password command parameter.")
let phone = StringOption(shortFlag: "P", helpMessage: "Specify the REST API Phone command parameter.")
let email = StringOption(shortFlag: "e", helpMessage: "Specify the REST API Email command parameter.")

let options = [command,    adminid, curl, data, email, id, list, mgrid, name, pwd, phone, usrid]

// ADMIN TASKS:
cli.addOptions(options)

do {
    try cli.parse()
    
    if let comd = command.value {
        switch command.value! {
        case "GENMASTERTZLIST":
            print(serializeTimeZoneNames(true))
        case "SIGNUP":
            // requires -n UserName -p Pwd
            // returns SID (USID if User role, MSID if Mgr role, ASID if Admin role)
            break
        case "LOGIN":
            // requires -n UserName -p Pwd
            // returns SID (USID if User role, MSID if Mgr role, ASID if Admin role)
            break
        case "LOGOUT":
            // requires -s SID
            break
        case "GETZONELIST":
            // requires -s SID
            // returns L[ZoneName]
            break
        case "ADDTOZONELIST":
            // requires -s SID -n ZoneName
            break
        case "DELETEFROMZONELIST":
            // requires -s SID -n ZoneName
            break
        case "GETMASTERTZLIST":
            // returns L[ZoneName] (all possible names)
            break
        case "SETMASTERTZLIST":
            // requires -s ASID -D dataFileCSVPath
            break
        case "GETUSERLIST":
            // requires -s MASID
            // returns L[UserName]
            break
        case "GETUSERDATA":
            // requires -s MASID -u UID
            // returns UserData (name, email, phone, pwdFlag)
            break
        case "CREATEUSER":
            // requires -s MASID -n UserName -p Pwd
            // optional -n UserName -p Pwd -e Email -P phone
            // returns UID (no login)
            // validates: UserName unique/nonblank, Email unique/nonblank
            break
        case "UPDATEUSER":
            // requires -s MASID -u UID
            // optional -n UserName -p Pwd -e Email -P phone
            // validates: UserName unique/nonblank, Email unique if nonblank
            break
        case "DELETEUSER":
            // requires -s MASID -u UID
            break
        case "GETROLELIST":
            // requires -s ASID
            // returns L[RoleName,RID]
            break
        case "GETROLEDATA":
            // requires -s ASID -i RID
            // returns RoleName, L[UID], L[RID](0 or 1 child)
            break
        case "CREATEROLE":
            // requires -s ASID -n RoleName (unique among Roles)
            break
        case "DELETEROLE":
            // requires -s ASID -i RID
            // deletes role from system IFF users is empty
            break
        case "GETUSERROLE":
            // requires -s ASID -u UID
            // returns RID of role user is member of users list of
            break
        case "SETUSERROLE":
            // requires -s ASID -u UID -i RID
            // adds user to users relation of role
            break
        case "GETROLEUSERS":
            // requires -s ASID -i RID
            // returns L[UID] that is contents of users relation of role
            break
        default:
            throw TZError.ShowCommandList
        }
    } else {
        throw TZError.ShowHelp
    }
    exit(EX_OK)
} catch TZError.ShowCommandList {
    print("Invalid command; Please use the following list of comamnds:\n\(commandList)")
    exit(EX_USAGE)
} catch TZError.ShowHelp {
    cli.printUsage()
    exit(EX_USAGE)
} catch {
    cli.printUsage(error)
    exit(EX_USAGE)
}
