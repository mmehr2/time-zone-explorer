//
//  AddTimeZonesTableViewController.swift
//  TimeZoneExplorer
//
//  Created by Michael L Mehr on 1/18/16.
//  Copyright © 2016 Michael L. Mehr. All rights reserved.
//

import UIKit
import Parse
import ParseUI

protocol TimeZoneAddDelegate {
    // check if a zone exists in the list, returns T if in the list, false otherwise
    func isZoneIDInList(zoneID: String?) -> Bool
    // add a specific zone to the list, returns T if successfully queued to add, false otherwise
    func saveZoneIDToList(zoneID: String) -> Bool
}

class AddTimeZonesTableViewController: PFQueryTableViewController {
    
    var tzaDelegate: TimeZoneAddDelegate?
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var searchController: UISearchController!
    var searchString: String?// = "America"
    // the save button uses the selected value, if any (saved here)
    // This also updates the prompt on the nav.item when set
    var selectedZoneID: String? {
        didSet {
            let alreadyInList = tzaDelegate?.isZoneIDInList(selectedZoneID) ?? false// consult user's list
            if let ZID = selectedZoneID {
                // enable the save button only if the selected ID is NOT already in User's list
                if alreadyInList {
                    self.saveButton.enabled = false
                    self.navigationItem.prompt = "This zone is already in your list: \(ZID)."
                } else {
                    self.saveButton.enabled = true
                    self.navigationItem.prompt = "Press Save to add \(ZID) to your list."
                }
            } else {
                self.navigationItem.prompt = "Touch to select the Time Zone of interest."
                // also disable Save button if no selection
                self.saveButton.enabled = false
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // {DOESNT SEEM TO WORK THO} 
        self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

        // set up search controller for use in filtering and add to header view
        // FIX TO PREVENT UISEARCHCONTROLLER BUG (REVISED)
        /*
        Bug displays this error:
        2016-01-18 14:04:32.251 TimeZoneExplorer[50766:676731] Attempting to load the view of a view controller while it is deallocating is not allowed and may result in undefined behavior (<UISearchController: 0x7fa172757860>)
        Fix comes from here (further answer by Derek plus my comment):
        http://stackoverflow.com/questions/32282401/attempting-to-load-the-view-of-a-view-controller-while-it-is-deallocating-uis
        NOTE: Now bug doesn't seem to happen. Issue? I'll leave the code in.
        */
        self.searchController = {
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.delegate = self
            controller.searchBar.sizeToFit()
            
            //self.tableView.tableHeaderView = controller.searchBar
            
            return controller
            }()
        // NOTE: these lines were shown before the previous, but only work if called after
        // If not included, the bug is still there, but with the call to loadViewIfNeeded(), the bug goes away
        if #available(iOS 9.0, *) {
            self.searchController.loadViewIfNeeded()// iOS 9
        } else {
            // Fallback on earlier versions
            let _ = self.searchController.view          // iOS 8
        }
        // END OF BUGFIX
        
        // "also a good idea" on original source's discussion of this (not related to bugfix)
        self.definesPresentationContext = true
        // add search bar to UI as header view
        tableView.tableHeaderView = searchController.searchBar
        // show the prompt
        selectedZoneID = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Parse query to get objects from the cloud
    override func queryForTable() -> PFQuery {
        let query = PFQuery(className: "TimeZones")
        query.orderByAscending("name")
        if let searchString = searchString {
            // in order to get case-insensitive search, we need to use PFQuery's regex search options
            let regex = ".*" + searchString + ".*" // naive to assume user knows regex tho
            // specifically, user-entered regex strings such as ".*" will have the desired effects
            // this probably won't interfere with naive users, since those are not usually characters
            //   that appear in time zone names
            query.whereKey("name", matchesRegex: regex, modifiers: "i")
        }
        return query
    }
    
    // save the selection for the save button
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = self.tableView(tableView, cellForRowAtIndexPath: indexPath)
        let text = cell.textLabel?.text ?? ""
        let ID = TZTimeZone.getZoneID(text)
        selectedZoneID = ID
    }

    // MARK: - Actions
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        if let selectedZoneID = selectedZoneID {
            print("Saving ID=\(selectedZoneID) to user's list.")
            tzaDelegate?.saveZoneIDToList(selectedZoneID)
        }
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}

// MARK: - Search results update
extension AddTimeZonesTableViewController: UISearchResultsUpdating {

    func updateSearchResultsForSearchController(searchController: UISearchController) {
        searchString = searchController.searchBar.text
        if let searchString = searchString {
            // TBD: search for the text string here
            print("FILTER: Searching for {\(searchString)}")
            // then trigger the reload of only the relevant data
            loadObjects() // uses the PFQuery defined by searchString to reload the table from Parse (internet required!)
        }
    }
    
}

extension AddTimeZonesTableViewController: UISearchBarDelegate {
    
    
}

// MARK: - Table view data source
extension AddTimeZonesTableViewController {
    

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        let cellIdentifier = "MasterTimeZoneCell"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? PFTableViewCell
        if cell == nil {
            cell = PFTableViewCell(style: .Subtitle, reuseIdentifier: cellIdentifier)
        }

        let zoneID = (object?["name"] as? String ?? "")
        let formattedID = TZTimeZone.getStandardFormat(zoneID)
        cell?.textLabel?.text = formattedID
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
}
