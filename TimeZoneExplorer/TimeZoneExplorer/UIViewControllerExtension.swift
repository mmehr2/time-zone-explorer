//
//  UIViewControllerExtension.swift
//  ParseTutorial
//
//  Created by Ron Kliffer on 3/8/15.
//  Copyright (c) 2015 Ron Kliffer. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    // find the topmost VC for presentation, no matter what
    // This additional code from: Stack Overflow.
    
    var topmostViewController: UIViewController? {
        var topController = UIApplication.sharedApplication().keyWindow?.rootViewController
        
        while topController?.presentedViewController != nil {
            topController = topController?.presentedViewController
        }
        
        return topController
    }
    
    func showErrorView(error: NSError) {
        if let errorMessage = error.userInfo["error"] as? String {
            let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            guard let vc = topmostViewController else {
                print("Couldn't find controller to present the error.")
                return
             }
            vc.presentViewController(alert, animated: true, completion: nil)
       }
    }
}