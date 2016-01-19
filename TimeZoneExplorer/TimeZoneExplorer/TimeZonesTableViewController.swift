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
    
    private func presentLoginScreen() {
        if !TZClient.loggedIn {
            let vc = TZClient.getLoginViewControllerFor(self)
            self.presentViewController(vc, animated: true, completion: nil)
        }
        if TZClient.loggedIn {
            self.navigationItem.prompt = TZClient.getFormattedUsernameTitle()
        }
    }

    // hide the tab bar controller when in User role (does the toolbar leave too? I hope not...)
    override var hidesBottomBarWhenPushed: Bool {
        get {return false} // uncomment when role detection is working { return TZClient.role == .User }
        set { super.hidesBottomBarWhenPushed = newValue }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presentLoginScreen()

        // Do any additional setup after loading the view.
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItems?.append(self.editButtonItem())
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
       presentLoginScreen()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func logOutPressed(sender: AnyObject) {
        PFUser.logOut()
        //If logout succesful:
        navigationController?.popToRootViewControllerAnimated(false)
        presentLoginScreen()
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "AddTimeZoneSegue" {
            // just need to specify ourselves as the TimeZoneAddDelegate to answer questions about our list
            if let dvc = segue.destinationViewController as? AddTimeZonesTableViewController {
                dvc.tzaDelegate = self
            }
        }
    }


}

// MARK: Parse delegate for PFLogInViewController
extension TimeZonesTableViewController: PFLogInViewControllerDelegate {
    func logInViewController( controller: PFLogInViewController, didLogInUser user: PFUser ) -> Void {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func logInViewControllerDidCancelLogIn( controller: PFLogInViewController ) -> Void {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

// MARK: App TimeZone add delegate
extension TimeZonesTableViewController: TimeZoneAddDelegate {
    
    func isZoneIDInList(zoneID: String?) -> Bool {
        var result = false
        if let zid = zoneID, objects = objects {
            // scan objects array for one with the supplied ZID
            print("TZAD: Filtering \(objects.count) objects for ID=\(zid)")
            let found = (objects.filter({ object in
                return (object["name"] as? String) == zid
            }))
            if found.count > 0 {
                result = true
            }
        } else {
            print("TZAD: No objects in array.")
        }
        return result
    }
    
    func saveZoneIDToList(zoneID: String) -> Bool {
        if let user = PFUser.currentUser() {
            let username = user.username ?? "Anonymous"
            print("TZAD: Save queued for \(zoneID) for user \(username)")
            return true
        } else {
            print("TZAD: No user logged in, cannot save \(zoneID).")
        }
        return false
    }
}

