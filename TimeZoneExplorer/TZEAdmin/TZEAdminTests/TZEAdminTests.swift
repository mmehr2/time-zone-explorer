//
//  TZEAdminTests.swift
//  TZEAdminTests
//
//  Created by Michael L Mehr on 1/30/16.
//  Copyright © 2016 Michael L. Mehr. All rights reserved.
//

import XCTest
import Foundation
@testable import TZEAdmin

class TZEAdminTests: XCTestCase {

    let main = Main()

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    /// Tests a single command line via Main's runCommands() function.
    ///
    /// Operates in debug mode (currently simulated by -C cURL option).
    func testCommandLine(command: String) -> Int32 {
        var args = command.splitByCharacter(" ")
        args.append("-C") // force cURL output in lieu of debug-only mode (TBD)
        let retval = main.runCommands(args)
        return retval
    }

    func testMisc() {
        XCTAssert((testCommandLine("")) == EX_USAGE, "No commands")
        XCTAssert((testCommandLine("-c")) == EX_USAGE, "Command w/o name")
    }
    
    func testSignupOptions() {
        XCTAssert((testCommandLine("-c SIGNUP")) == EX_USAGE, "Signup command missing all")
        XCTAssert((testCommandLine("-c SIGNUP -n ")) == EX_USAGE, "Signup command missing NAME")
        XCTAssert((testCommandLine("-c SIGNUP -n 1NAME ")) == EX_USAGE, "Signup command missing PWD")
        XCTAssert((testCommandLine("-c SIGNUP -n 1NAME -p")) == EX_USAGE, "Signup command missing PWD value")
        XCTAssert((testCommandLine("-c SIGNUP -n 1NAME -p PWD")) == EX_OK, "Signup command OK")
    }
    
    func testLoginOptions() {
        XCTAssert((testCommandLine("-c LOGIN")) == EX_USAGE, "Login command missing all")
        XCTAssert((testCommandLine("-c LOGIN -n ")) == EX_USAGE, "Logout command missing NAME value")
        XCTAssert((testCommandLine("-c LOGIN -n 1NAME ")) == EX_USAGE, "Logout command missing PWD")
        XCTAssert((testCommandLine("-c LOGIN -n 1NAME -p")) == EX_USAGE, "Logout command missing PWD value")
        XCTAssert((testCommandLine("-c LOGIN -n 1NAME -p PWD")) == EX_OK, "Login command OK")
    }
    
    func testLogoutOptions() {
        XCTAssert((testCommandLine("-c LOGOUT")) == EX_USAGE, "Logout command missing all")
        XCTAssert((testCommandLine("-c LOGOUT -s")) == EX_USAGE, "Logout command missing SID value")
        XCTAssert((testCommandLine("-c LOGOUT -s SID")) == EX_OK, "Logout command OK")
    }
    
    func testGetzonelistOptions() {
        XCTAssert((testCommandLine("-c GETZONELIST")) == EX_USAGE, "GetZoneList command missing all")
        XCTAssert((testCommandLine("-c GETZONELIST -s")) == EX_USAGE, "GetZoneList command missing SID value")
        XCTAssert((testCommandLine("-c GETZONELIST -s SID")) == EX_OK, "GetZoneList command OK (simple)")
    }
    
    func testGetzonelistOptions_Mgr() {
        XCTAssert((testCommandLine("-c GETZONELIST -s SID -u")) == EX_USAGE, "GetZoneList command missing opt UID value")
        XCTAssert((testCommandLine("-c GETZONELIST -s SID -u UID")) == EX_OK, "GetZoneList command OK (w.opt UID)")
        XCTAssert((testCommandLine("-c GETZONELIST -s SID -U")) == EX_USAGE, "GetZoneList command missing opt UNAME value")
        XCTAssert((testCommandLine("-c GETZONELIST -s SID -U UNAME")) == EX_OK, "GetZoneList command OK (w.opt UNAME)")
        XCTAssert((testCommandLine("-c GETZONELIST -s SID -u 1 -U N")) == EX_USAGE, "GetZoneList command fail (both user options)")
    }
    
    func testAddtozonelistOptions() {
        XCTAssert((testCommandLine("-c ADDTOZONELIST")) == EX_USAGE, "AddToZoneList command missing all")
        XCTAssert((testCommandLine("-c ADDTOZONELIST -s")) == EX_USAGE, "AddToZoneList command missing SID value")
        XCTAssert((testCommandLine("-c ADDTOZONELIST -s SID")) == EX_USAGE, "AddToZoneList command missing name")
        XCTAssert((testCommandLine("-c ADDTOZONELIST -s SID -n")) == EX_USAGE, "AddToZoneList command missing name value")
        XCTAssert((testCommandLine("-c ADDTOZONELIST -s SID -n ZNAME")) == EX_OK, "AddToZoneList command OK (simple)")
    }
    
    func testAddtozonelistOptions_Mgr() {
        XCTAssert((testCommandLine("-c ADDTOZONELIST -s SID -n ZNAME -u")) == EX_USAGE, "AddToZoneList command missing opt UID value")
        XCTAssert((testCommandLine("-c ADDTOZONELIST -s SID -n ZNAME -u UID")) == EX_OK, "AddToZoneList command OK (w.opt UID)")
        XCTAssert((testCommandLine("-c ADDTOZONELIST -s SID -n ZNAME -U")) == EX_USAGE, "AddToZoneList command missing opt UNAME value")
        XCTAssert((testCommandLine("-c ADDTOZONELIST -s SID -n ZNAME -U UNAME")) == EX_OK, "AddToZoneList command OK (w.opt UNAME)")
        XCTAssert((testCommandLine("-c ADDTOZONELIST -s SID -n ZNAME -u 1 -U N")) == EX_USAGE, "AddToZoneList command fail (both user options)")
    }
    
    func testDeletefromzonelistOptions() {
        XCTAssert((testCommandLine("-c DELETEFROMZONELIST")) == EX_USAGE, "DeleteFromZoneList command missing all")
        XCTAssert((testCommandLine("-c DELETEFROMZONELIST -s")) == EX_USAGE, "DeleteFromZoneList command missing SID value")
        XCTAssert((testCommandLine("-c DELETEFROMZONELIST -s SID")) == EX_USAGE, "DeleteFromZoneList command missing name")
        XCTAssert((testCommandLine("-c DELETEFROMZONELIST -s SID -n")) == EX_USAGE, "DeleteFromZoneList command missing name value")
        XCTAssert((testCommandLine("-c DELETEFROMZONELIST -s SID -n ZNAME")) == EX_OK, "DeleteFromZoneList command OK (simple)")
    }
    
    func testDeletefromzonelistOptions_Mgr() {
        XCTAssert((testCommandLine("-c DELETEFROMZONELIST -s SID -n ZNAME -u")) == EX_USAGE, "DeleteFromZoneList command missing opt UID value")
        XCTAssert((testCommandLine("-c DELETEFROMZONELIST -s SID -n ZNAME -u UID")) == EX_OK, "DeleteFromZoneList command OK (w.opt UID)")
        XCTAssert((testCommandLine("-c DELETEFROMZONELIST -s SID -n ZNAME -U")) == EX_USAGE, "DeleteFromZoneList command missing opt UNAME value")
        XCTAssert((testCommandLine("-c DELETEFROMZONELIST -s SID -n ZNAME -U UNAME")) == EX_OK, "DeleteFromZoneList command OK (w.opt UNAME)")
        XCTAssert((testCommandLine("-c DELETEFROMZONELIST -s SID -n ZNAME -u 1 -U N")) == EX_USAGE, "DeleteFromZoneList command fail (both user options)")
    }
    
    func testGetmastertzlistOptions() {
        XCTAssert((testCommandLine("-c GETMASTERTZLIST")) == EX_USAGE, "GetMasterTZList command missing all")
        XCTAssert((testCommandLine("-c GETMASTERTZLIST -s")) == EX_USAGE, "GetMasterTZList command missing SID value")
        XCTAssert((testCommandLine("-c GETMASTERTZLIST -s SID")) == EX_OK, "GetMasterTZList command OK")
    }
    
    func testSetmastertzlistOptions() {
        XCTAssert((testCommandLine("-c SETMASTERTZLIST")) == EX_USAGE, "SetMasterTZList command missing all")
        XCTAssert((testCommandLine("-c SETMASTERTZLIST -s")) == EX_USAGE, "SetMasterTZList command missing SID value")
        XCTAssert((testCommandLine("-c SETMASTERTZLIST -s SID")) == EX_USAGE, "SetMasterTZList command missing filename")
        XCTAssert((testCommandLine("-c SETMASTERTZLIST -s SID -D")) == EX_USAGE, "SetMasterTZList command missing filename value")
        XCTAssert((testCommandLine("-c SETMASTERTZLIST -s SID -D FNAME")) == EX_OK, "SetMasterTZList command OK")
    }
    
    func testGetuserlistOptions() {
        XCTAssert((testCommandLine("-c GETUSERLIST")) == EX_USAGE, "GetUserList command missing all")
        XCTAssert((testCommandLine("-c GETUSERLIST -s")) == EX_USAGE, "GetUserList command missing SID value")
        XCTAssert((testCommandLine("-c GETUSERLIST -s SID")) == EX_OK, "GetUserList command OK")
    }
    
    func testGetuserdataOptions() {
        XCTAssert((testCommandLine("-c GETUSERDATA")) == EX_USAGE, "GetUserData command missing all")
        XCTAssert((testCommandLine("-c GETUSERDATA -s")) == EX_USAGE, "GetUserData command missing SID value")
        XCTAssert((testCommandLine("-c GETUSERDATA -s SID")) == EX_USAGE, "GetUserData command missing UID or UserName")
        XCTAssert((testCommandLine("-c GETUSERDATA -s SID -u")) == EX_USAGE, "GetUserData command missing UID value")
        XCTAssert((testCommandLine("-c GETUSERDATA -s SID -u UID")) == EX_OK, "GetUserData command OK (w. UID)")
        XCTAssert((testCommandLine("-c GETUSERDATA -s SID -U")) == EX_USAGE, "GetUserData command missing UNAME value")
        XCTAssert((testCommandLine("-c GETUSERDATA -s SID -U UNAME")) == EX_OK, "GetUserData command OK (w. UNAME)")
        XCTAssert((testCommandLine("-c GETUSERDATA -s SID -u 1 -U N")) == EX_USAGE, "GetUserData command fail (both user options)")
    }
    
    func testCreateuserOptions() {
        XCTAssert((testCommandLine("-c CREATEUSER")) == EX_USAGE, "CreateUser command missing all")
        XCTAssert((testCommandLine("-c CREATEUSER -s")) == EX_USAGE, "CreateUser command missing SID value")
        XCTAssert((testCommandLine("-c CREATEUSER -s SID")) == EX_USAGE, "CreateUser command missing UID or UserName")
        XCTAssert((testCommandLine("-c CREATEUSER -s SID -n ")) == EX_USAGE, "CreateUser command missing NAME value")
        XCTAssert((testCommandLine("-c CREATEUSER -s SID -n 1NAME ")) == EX_USAGE, "CreateUser command missing PWD")
        XCTAssert((testCommandLine("-c CREATEUSER -s SID -n 1NAME -p")) == EX_USAGE, "CreateUser command missing PWD value")
        XCTAssert((testCommandLine("-c CREATEUSER -s SID -n 1NAME -p PWD")) == EX_OK, "CreateUser command OK")
        XCTAssert((testCommandLine("-c CREATEUSER -s SID -n 1NAME -p PWD -e")) == EX_USAGE, "CreateUser command missing opt EMAIL value")
        XCTAssert((testCommandLine("-c CREATEUSER -s SID -n 1NAME -p PWD -e EMAIL")) == EX_OK, "CreateUser command OK (w.opt EMAIL)")
        XCTAssert((testCommandLine("-c CREATEUSER -s SID -n 1NAME -p PWD -P")) == EX_USAGE, "CreateUser command missing opt PHONE value")
        XCTAssert((testCommandLine("-c CREATEUSER -s SID -n 1NAME -p PWD -P PHONE")) == EX_OK, "CreateUser command OK (w.opt PHONE)")
        XCTAssert((testCommandLine("-c CREATEUSER -s SID -n 1NAME -p PWD -P PHONE -e EMAIL")) == EX_OK, "CreateUser command OK (w.opt PHONE and EMAIL)")
    }
    
    func testUpdateuserOptions() {
        XCTAssert((testCommandLine("-c UPDATEUSER")) == EX_USAGE, "UpdateUser command missing all")
        XCTAssert((testCommandLine("-c UPDATEUSER -s")) == EX_USAGE, "UpdateUser command missing SID value")
        XCTAssert((testCommandLine("-c UPDATEUSER -s SID")) == EX_USAGE, "UpdateUser command missing UID or UserName")
        XCTAssert((testCommandLine("-c UPDATEUSER -s SID -u")) == EX_USAGE, "UpdateUser command missing UID value")
        XCTAssert((testCommandLine("-c UPDATEUSER -s SID -u UID")) == EX_OK, "UpdateUser command OK (w. UID) but no update data") // EX_USAGE??
        XCTAssert((testCommandLine("-c UPDATEUSER -s SID -U")) == EX_USAGE, "UpdateUser command missing UNAME value")
        XCTAssert((testCommandLine("-c UPDATEUSER -s SID -U UNAME")) == EX_OK, "UpdateUser command OK (w. UNAME) but no update data") // EX_USAGE??
        XCTAssert((testCommandLine("-c UPDATEUSER -s SID -u 1 -U N")) == EX_USAGE, "UpdateUser command fail (both user options)")
        XCTAssert((testCommandLine("-c UPDATEUSER -s SID -U UNAME -n")) == EX_USAGE, "UpdateUser command OK (w. UNAME) missing update NAME value")
        XCTAssert((testCommandLine("-c UPDATEUSER -s SID -U UNAME -n NAME2")) == EX_OK, "UpdateUser command OK (w. UNAME) w.update NAME")
        XCTAssert((testCommandLine("-c UPDATEUSER -s SID -U UNAME -p")) == EX_USAGE, "UpdateUser command OK (w. UNAME) missing update PWD value")
        XCTAssert((testCommandLine("-c UPDATEUSER -s SID -U UNAME -p PWD2")) == EX_OK, "UpdateUser command OK (w. UNAME) w.update PWD")
        XCTAssert((testCommandLine("-c UPDATEUSER -s SID -U UNAME -e")) == EX_USAGE, "UpdateUser command OK (w. UNAME) missing update EMAIL value")
        XCTAssert((testCommandLine("-c UPDATEUSER -s SID -U UNAME -e EMAIL2")) == EX_OK, "UpdateUser command OK (w. UNAME) w.update EMAIL")
        XCTAssert((testCommandLine("-c UPDATEUSER -s SID -U UNAME -P")) == EX_USAGE, "UpdateUser command OK (w. UNAME) missing update PHONE value")
        XCTAssert((testCommandLine("-c UPDATEUSER -s SID -U UNAME -P PHONE2")) == EX_OK, "UpdateUser command OK (w. UNAME) w.update PHONE")
        XCTAssert((testCommandLine("-c UPDATEUSER -s SID -U UNAME -n NAME2 -p PWD2 -e EMAIL2 -P PHONE2")) == EX_OK, "UpdateUser command OK (w. UNAME) w.all data")
    }
    
    func testDeleteuserOptions() {
        XCTAssert((testCommandLine("-c DELETEUSER")) == EX_USAGE, "DeleteUser command missing all")
        XCTAssert((testCommandLine("-c DELETEUSER -s")) == EX_USAGE, "DeleteUser command missing SID value")
        XCTAssert((testCommandLine("-c DELETEUSER -s SID")) == EX_USAGE, "DeleteUser command missing UID or UserName")
        XCTAssert((testCommandLine("-c DELETEUSER -s SID -u")) == EX_USAGE, "DeleteUser command missing UID value")
        XCTAssert((testCommandLine("-c DELETEUSER -s SID -u UID")) == EX_OK, "DeleteUser command OK (w. UID)")
        XCTAssert((testCommandLine("-c DELETEUSER -s SID -U")) == EX_USAGE, "DeleteUser command missing UNAME value")
        XCTAssert((testCommandLine("-c DELETEUSER -s SID -U UNAME")) == EX_OK, "DeleteUser command OK (w. UNAME)")
        XCTAssert((testCommandLine("-c DELETEUSER -s SID -u 1 -U N")) == EX_USAGE, "DeleteUser command fail (both role options)")
    }
    
    func testGetrolelistOptions() {
        XCTAssert((testCommandLine("-c GETROLELIST")) == EX_USAGE, "GetRoleList command missing all")
        XCTAssert((testCommandLine("-c GETROLELIST -s")) == EX_USAGE, "GetRoleList command missing SID value")
        XCTAssert((testCommandLine("-c GETROLELIST -s SID")) == EX_OK, "GetRoleList command OK")
    }
    
    func testGetroledataOptions() {
        XCTAssert((testCommandLine("-c GETROLEDATA")) == EX_USAGE, "GetRoleData command missing all")
        XCTAssert((testCommandLine("-c GETROLEDATA -s")) == EX_USAGE, "GetRoleData command missing SID value")
        XCTAssert((testCommandLine("-c GETROLEDATA -s SID")) == EX_USAGE, "GetRoleData command missing RoleName")
        XCTAssert((testCommandLine("-c GETROLEDATA -s SID -r")) == EX_USAGE, "GetRoleData command missing RNAME value")
        XCTAssert((testCommandLine("-c GETROLEDATA -s SID -r RNAME")) == EX_OK, "GetRoleData command OK")
     }
    
    func testCreateroleOptions() {
        XCTAssert((testCommandLine("-c CREATEROLE")) == EX_USAGE, "CreateRole command missing all")
        XCTAssert((testCommandLine("-c CREATEROLE -s")) == EX_USAGE, "CreateRole command missing SID value")
        XCTAssert((testCommandLine("-c CREATEROLE -s SID")) == EX_USAGE, "CreateRole command missing RoleName")
        XCTAssert((testCommandLine("-c CREATEROLE -s SID -r ")) == EX_USAGE, "CreateRole command missing NAME value")
        XCTAssert((testCommandLine("-c CREATEROLE -s SID -r RNAME ")) == EX_OK, "CreateRole command OK")
    }
    
    func testDeleteroleOptions() {
        XCTAssert((testCommandLine("-c DELETEROLE")) == EX_USAGE, "DeleteRole command missing all")
        XCTAssert((testCommandLine("-c DELETEROLE -s")) == EX_USAGE, "DeleteRole command missing SID value")
        XCTAssert((testCommandLine("-c DELETEROLE -s SID")) == EX_USAGE, "DeleteRole command missing UID or RoleName")
        XCTAssert((testCommandLine("-c DELETEROLE -s SID -r ")) == EX_USAGE, "DeleteRole command missing NAME value")
        XCTAssert((testCommandLine("-c DELETEROLE -s SID -r RNAME ")) == EX_OK, "DeleteRole command OK")
    }
    
}
