//
//  UsersTableViewController.swift
//  TimeZoneExplorer
//
//  Created by Michael L Mehr on 1/18/16.
//  Copyright © 2016 Michael L. Mehr. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class UsersTableViewController: PFQueryTableViewController {

    // Names for relevant external constants (storyboard, Parse, etc.)
    // NOTE: This pattern allows compiler to check use of things, avoiding string typos and misuse
    enum DataClassNames: String {
        case Main = "_User" // PARSE class
        case MainPrimaryKey = "username"
    }
    
    enum SegueNames: String {
        case Add = "AddUserDetailsSegue"
        case Display = "SelectUserDetailsSegue"
    }
    
    enum CellNames: String {
        case Main = "UserCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItems?.append(self.editButtonItem())
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        reload()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == SegueNames.Add.rawValue {
            // just need to specify ourselves as the UserDisplayDelegate to supply data details
            if let dvc = segue.destinationViewController as? UserDetailsViewController {
                dvc.currentObject = nil
            }
        }
        if segue.identifier == SegueNames.Display.rawValue {
            if let cell = sender as? PFTableViewCell,
                let dvc = segue.destinationViewController as? UserDetailsViewController,
                let indexPath = tableView.indexPathForCell(cell),
                let object = objects?[indexPath.row] as? PFUser {
                    dvc.currentObject = object
            }
        }
    }

}

// MARK: table view data source (Parse override)
extension UsersTableViewController {
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        let cellIdentifier = CellNames.Main.rawValue
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? PFTableViewCell
        if cell == nil {
            cell = PFTableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
        }
        
        let data = (object?[DataClassNames.MainPrimaryKey.rawValue] as? String ?? "")
        let formatted = data
        cell?.textLabel?.text = formatted
        
        return cell
    }
    
    // row deletion
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // do NOT allow deletion of current user!
            let object = objectAtIndexPath(indexPath) as! PFUser
            if object.objectId != PFUser.currentUser()?.objectId {
                removeObjectAtIndexPath(indexPath) //PARSE
            }
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        var result = true
        // do NOT allow editing of current user!
        let object = objectAtIndexPath(indexPath) as! PFUser
        if object.objectId != PFUser.currentUser()?.objectId {
            result = false
        }
        return result
    }
    
}

// MARK: PARSE-related dependencies
extension UsersTableViewController {
    
    // Parse query to get objects from the cloud
    override func queryForTable() -> PFQuery {
        let query = PFQuery(className: DataClassNames.Main.rawValue)
        query.orderByAscending(DataClassNames.MainPrimaryKey.rawValue)
        return query
    }
    
    // reload all the data objects from the cloud
    private func reload() {
        loadObjects() // through base class PFQueryTableViewController
    }
    
    // UTILITY: return the PARSE object associated with a particular ID
    private func findObjectWithID(username: String) -> [PFObject] {
        
        guard let objects = objects else { return Array() }
        
        let found = (objects.filter({ object in
            return (object[DataClassNames.MainPrimaryKey.rawValue] as? String) == username
        }))
        return found
    }
    
    // log the current user out
    private func logout() {
        PFUser.logOut()
    }
    
}
