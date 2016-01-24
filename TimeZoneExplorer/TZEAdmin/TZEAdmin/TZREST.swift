//
//  TZREST.swift
//  TZEAdmin
//
//  Created by Michael L Mehr on 1/23/16.
//  Copyright © 2016 Michael L. Mehr. All rights reserved.
//

import Foundation

class TZREST {
    
    enum Keys : String {
        case App = "8DmXDEVyXx5obB5xjkXuGcffbI35ViFeo8AlSD79"
        case Client = "n70sX5raWJw8hFJnBcnH6etdcG4SVm2b0zr3Oc1S"
    }
    
    static let errorDomain = "com.Parse.TimeZoneExplorer"
    
    enum Verb {
        case GET
        case POST
        case PUT
        case DELETE
    }

    enum RESTHeader {
        case AppID
        case ApiKey
        case ContentType
    }
    
    class func loadDataFromURL(urlr: NSURLRequest, completion:(data: NSData?, error: NSError?) -> Void) {
        let session = NSURLSession.sharedSession()
        
        // Use NSURLSession to get data from an NSURL
        let loadDataTask = session.dataTaskWithRequest(urlr, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if let responseError = error {
                completion(data: nil, error: responseError)
            } else if let httpResponse = response as? NSHTTPURLResponse {
                if !(200...299).contains(httpResponse.statusCode) {
                    let statusError = NSError(domain: errorDomain, code:httpResponse.statusCode, userInfo:[NSLocalizedDescriptionKey : "HTTP status code has unexpected value."])
                    completion(data: nil, error: statusError)
                } else {
                    completion(data: data, error: nil)
                }
            }
        })
        
        loadDataTask.resume()
    }

}