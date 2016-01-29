//
//  DataConnection.swift
//  TZEAdmin
//
//  Created by Michael L Mehr on 1/26/16.
//  Copyright © 2016 Michael L. Mehr. All rights reserved.
//

import Foundation

/**
Currently this class is designed to handle needs for the Parse.com REST API 1.12.0 as defined by their REST API docs online.
It could evolve into a tool for my use with many clients.

As specified online:

## Request Format

For POST and PUT requests, the request body must be JSON, with the Content-Type header set to application/json.

Authentication is done via HTTP headers. The X-Parse-Application-Id header identifies which application you are accessing, and the X-Parse-REST-API-Key header authenticates the endpoint.

In the examples that follow, the keys for your app are included in the command. You can use the drop-down to construct example code for other apps.

You may also authenticate your REST API requests using basic HTTP authentication. For example, to retrieve an object you could set the URL using your Parse credentials in the following format:

```
https://myAppID:javascript-key=myJavaScriptKey@api.parse.com/1/classes/GameScore/Ed1nuqPvcm
```

## Response Format

The response format for all requests is a JSON object.

Whether a request succeeded is indicated by the HTTP status code. A 2xx status code indicates success, whereas a 4xx status code indicates failure. When a request fails, the response body is still JSON, but always contains the fields code and error which you can inspect to use for debugging. For example, trying to save an object with invalid keys will return the message:

```swift
{
"code": 105,
"error": "invalid field name: bl!ng"
}
```

## Calling from Client Apps

You should not use the REST API Key in client apps (i.e. code you distribute to your customers). If the Parse SDK is available for your client platform, we recommend using our SDK instead of the REST API. If you must call the REST API directly from the client, you should use the corresponding client-side Parse key for that plaform (e.g. Client Key for iOS/Android, or .NET Key for Windows/Xamarin/Unity).

If there is no Parse SDK for your client platform, please use your app's Client Key to call the REST API. Requests made with the Client Key, JavaScript Key, or Windows Key are restricted by client-side app settings that you configure in your Parse.com app dashboard. These settings make your app more secure. For example, we recommend that all production apps turn off the "Client Push Enabled" setting to prevent push notifications from being sent from any device using the Client Key, JavaScript Key, or .NET Key, but not the REST API Key. Therefore, if you plan on registering installations to enable Push Notifications for your app, you should not distribute any app code with the REST API key embedded in it.

*/

class DataConnection {
    
    static var errorDomain = "com.Parse.TimeZoneExplorer"
    
    class func loadDataFromURL(urlr: NSURLRequest, completion:(data: NSData?, error: NSError?) -> Void) {
        
        let session = NSURLSession.sharedSession()
        
        // Use NSURLSession to get data from an NSURL
        // TBD - may need a way to handle the NSURLResponse generically as well as the NSData
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