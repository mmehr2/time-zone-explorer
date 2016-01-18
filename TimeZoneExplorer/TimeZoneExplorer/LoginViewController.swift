//
//  LoginViewController.swift
//  TimeZoneExplorer
//
//  Created by Michael L Mehr on 1/17/16.
//  Copyright © 2016 Michael L. Mehr. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let userSegue = "LoginUserSuccessfulSegue"
    let managerSegue = "LoginManagerSuccessfulSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Check if user exists and logged in
        performLoginSegue()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isUserAManager() -> Bool {
        return false
    }
    
    func isUserLoggedIn() -> Bool {
        var result = false
        if let user = PFUser.currentUser() {
            if user.authenticated {
                result = true;
            }
        }
        return result
    }
    
    func performLoginSegue() {
        if isUserLoggedIn() {
            let loginSegue = self.getLoginSegue()
            self.performSegueWithIdentifier(loginSegue, sender: nil)
            print("Transferring to \(loginSegue) screen")
        }
    }
    
    func getLoginSegue() -> String {
        return isUserAManager() ? managerSegue : userSegue
    }
   
    
    // MARK: - Actions
    @IBAction func logInPressed(sender: AnyObject) {
        performLoginSegue()
        // perform some basic validation checks -- disallow blanks anyway
        guard let userText = userTextField.text where userText != "" else {return}
        guard let passwordText = passwordTextField.text where passwordText != "" else {return}
        
        PFUser.logInWithUsernameInBackground(userText, password: passwordText) { user, error in
            if user != nil {
                // if successfully logged in, go to the main screen for the type of user
                let loginSegue = self.getLoginSegue()
                self.performSegueWithIdentifier(loginSegue, sender: nil)
            } else if let error = error {
                self.showErrorView(error)
            }
        }
    }
    
    @IBAction func logOutPressed(sender: AnyObject) {
        PFUser.logOut()
        //If logout succesful:
        navigationController?.popToRootViewControllerAnimated(true)
    }

//    @IBAction func signUpPressed(sender: AnyObject) {
//        // perform some basic validation checks -- disallow blanks anyway
//        guard let userText = userTextField.text where userText != "" else {return}
//        guard let passwordText = passwordTextField.text where passwordText != "" else {return}
//        
//        // create a parse user here (rely on Parse validation?)
//        let user = PFUser();
//        user.username = userText
//        user.password = passwordText
//        
//        user.signUpInBackgroundWithBlock { succeeded, error in
//            if (succeeded) {
//                //The registration was successful, go to the main screen
//                self.performSegueWithIdentifier(self.someSegue, sender: nil)
//            } else if let error = error {
//                //Something bad has occurred
//                self.showErrorView(error)
//            }
//        }
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
