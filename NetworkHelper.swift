//
//  NetworkHelper.swift
//  SiscofaMobile
//
//  Created by Glaubert Moreira Schult on 15/06/15.
//  Copyright (c) 2015 GMS. All rights reserved.
//

import Foundation

class NetworkHelper {
    
    class func isConnectedToNetwork() -> Bool {
        var status:Bool = false
        
        let url = NSURL(string: "http://localhost:8080")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "HEAD"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0
        
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            
            if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    status = true
                }
            }
        }
        
        task.resume()
        
        return status
    }
}