//
//  TimeZonesTableViewController.swift
//  TimeZoneExplorer
//
//  Created by Michael L Mehr on 1/18/16.
//  Copyright © 2016 Michael L. Mehr. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class TimeZonesTableViewController: PFQueryTableViewController {

    // Names for relevant external constants (storyboard, Parse, etc.)
    // NOTE: This pattern allows compiler to check use of things, avoiding string typos and misuse
    enum DataClassNames: String {
        case Main = "MyTimeZones" // PARSE class
    }
    
    enum SegueNames: String {
        case Add = "AddTimeZoneSegue"
        case Display = "SelectTimeZoneSegue"
    }
    
    enum CellNames: String {
        case Main = "TimeZoneCell"
    }
    
    // NOTE: this variable will track the set of zones the user owns, caching it locally
    // This is needed since the objects list itself is updated asynchronously over the network
    //  and it's easier to just maintain this list for the TimeZoneAddDelegate's use.
    private var myZoneNames = Set<String>();

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presentLoginScreen()

        // Do any additional setup after loading the view.
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItems?.append(self.editButtonItem())
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        presentLoginScreen() // only if needed
        reload()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func logOutPressed(sender: AnyObject) {
        // user logout
        logout()
        
        //If logout succesful:
        navigationController?.popToRootViewControllerAnimated(false)
        
        presentLoginScreen()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == SegueNames.Add.rawValue {
            // just need to specify ourselves as the TimeZoneAddDelegate to answer questions about our list
            if let dvc = segue.destinationViewController as? AddTimeZonesTableViewController {
                dvc.tzaDelegate = self
            }
        }
        if segue.identifier == SegueNames.Display.rawValue {
            if let cell = sender as? PFTableViewCell,
                let dvc = segue.destinationViewController as? TimeZoneDetailsViewController,
                let indexPath = tableView.indexPathForCell(cell),
                let object = objects?[indexPath.row],
                let name = object["name"] as? String {
                    dvc.zoneID = name
            }
        }
    }


}

// MARK: table view data source (Parse override)
extension TimeZonesTableViewController {
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        let cellIdentifier = CellNames.Main.rawValue
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? PFTableViewCell
        if cell == nil {
            cell = PFTableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
        }
        
        let zoneID = (object?["name"] as? String ?? "")
        let formattedID = TZTimeZone.getStandardFormat(zoneID)
        cell?.textLabel?.text = formattedID
        
        return cell
    }

    // row deletion
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // remove this object's name from our list too
            if let name = objectAtIndexPath(indexPath)?["name"] as? String {
                myZoneNames.remove(name)
                //print("Removed list item \(name); now \(myZoneNames.count) names")
            }
            removeObjectAtIndexPath(indexPath) //PARSE (NOTE: changes which object is at path)
        }
    }
    
    // table view object load
    override func objectsDidLoad(error: NSError?) {
        super.objectsDidLoad(error)
        
        myZoneNames = Set<String>()
        guard error == nil else { return }
        // we have a new objects table - make sure the names are kept up to date
        if let objects = objects {
            for object in objects {
                if let name = object["name"] as? String {
                    myZoneNames.insert(name)
                }
            }
        }
        //print("List has \(myZoneNames.count) objects: \(myZoneNames)")
    }
    
}

// MARK: TZClient dependencies
extension TimeZonesTableViewController {
    
    // hide the tab bar controller when in User role (does the toolbar leave too? I hope not...)
    override var hidesBottomBarWhenPushed: Bool {
        get {return false} // uncomment when role detection is working { return TZClient.role == .User }
        set { super.hidesBottomBarWhenPushed = newValue }
    }
    
    private func presentLoginScreen() {
        if !TZClient.loggedIn {
            let vc = TZClient.getLoginViewControllerFor(self)
            self.presentViewController(vc, animated: true, completion: nil)
        }
        if TZClient.loggedIn {
            self.navigationItem.prompt = TZClient.getFormattedUsernameTitle()
        }
    }
    
}

// MARK: PARSE-related dependencies
extension TimeZonesTableViewController {
    
    // Parse query to get objects from the cloud
    override func queryForTable() -> PFQuery {
        let query = PFQuery(className: DataClassNames.Main.rawValue)
        query.orderByAscending("name")
        return query
    }

    // reload all the data objects from the cloud
    private func reload() {
        loadObjects() // through base class PFQueryTableViewController
    }
    
    // UTILITY: return the PARSE object associated with a particular ID
    private func findObjectWithID(zoneID: String) -> [PFObject] {
        
        guard let objects = objects else { return Array() }
        
        let found = (objects.filter({ object in
            return (object["name"] as? String) == zoneID
        }))
        return found
    }
    
    // log the current user out
    private func logout() {
        TZClient.logoutCurrentUser()
    }
    
    // login has succeeded, do other related tasks
    private func registerLoginForUser(user: PFUser) {
        TZClient.registerLoginSuccess()
    }
    
    // login has succeeded, do other related tasks
    private func registerLoginFailure(error: NSError?) {
        TZClient.registerLoginFailure(error)
    }
    
}

// MARK: Parse dependenciy (delegate for PFLogInViewController)
extension TimeZonesTableViewController: PFLogInViewControllerDelegate {
    // LOGIN SUCCESS
    func logInViewController( controller: PFLogInViewController, didLogInUser user: PFUser ) -> Void {
        self.dismissViewControllerAnimated(true, completion: nil)
        registerLoginForUser(user)
    }

    // LOGIN CANCELED
    func logInViewControllerDidCancelLogIn( controller: PFLogInViewController ) -> Void {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // LOGIN FAILURE
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        // NOTE: do NOT dismiss the VC - it needs to stay up until login or signup is successful!
        
        // BUT - we can log the event anyway (log to cloud somehow too?)
        registerLoginFailure(error)
    }
}

// MARK: App TimeZone Add delegate
extension TimeZonesTableViewController: TimeZoneAddDelegate {
    
    func isZoneIDInList(zoneID: String) -> Bool {
        let result = myZoneNames.contains(zoneID)
        print("Checking \(zoneID) in list: \(result)")
        return result
    }
    
    func saveZoneIDToList(zoneID: String) -> Bool {
        if let user = PFUser.currentUser() {
            let username = user.username ?? "Anonymous"
            
            // PARSE: create the new object
            let object = PFObject(className: DataClassNames.Main.rawValue)
            let ACL = PFACL(user: user)
            object.ACL = ACL
            object["name"] = zoneID
            
            // PARSE: send the object to the server on a background task
            object.saveEventually(nil)
            // and make sure we remember the name even before the objects come back from a reload
            myZoneNames.insert(zoneID)
            
            print("TZAD: Save queued for \(zoneID) for user \(username)")
            return true
        } else {
            print("TZAD: No user logged in, cannot save \(zoneID).")
        }
        return false
    }
}

