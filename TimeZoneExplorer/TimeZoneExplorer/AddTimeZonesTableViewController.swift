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

class AddTimeZonesTableViewController: PFQueryTableViewController {
    
    var searchController: UISearchController!
    var searchString: String?// = "America"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // {DOESNT SEEM TO WORK THO} // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

        // set up search controller for use in filtering and add to header view
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        
        // "also a good idea" on original source's discussion of this (not related to bugfix)
        self.definesPresentationContext = true
        // add search bar to UI as header view
        tableView.tableHeaderView = searchController.searchBar
    }
    
    // FIX TO PREVENT UISEARCHCONTROLLER BUG
    /*
    Bug displays this error:
    2016-01-18 14:04:32.251 TimeZoneExplorer[50766:676731] Attempting to load the view of a view controller while it is deallocating is not allowed and may result in undefined behavior (<UISearchController: 0x7fa172757860>)
    Fix comes from here:
    http://stackoverflow.com/questions/32282401/attempting-to-load-the-view-of-a-view-controller-while-it-is-deallocating-uis
    */
    deinit{
        if let superView = searchController.view.superview
        {
            superView.removeFromSuperview()
        }
    }
    // END BUG FIX
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func queryForTable() -> PFQuery {
        let query = PFQuery(className: "TimeZones")
        query.orderByAscending("name")
        if let searchString = searchString {
            query.whereKey("name", containsString: searchString)
        }
        return query
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
        cell?.textLabel?.text = zoneID + " (GMT+10:00)"
        
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
