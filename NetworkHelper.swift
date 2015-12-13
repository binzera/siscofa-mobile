//
//  NetworkHelper.swift
//  SiscofaMobile
//
//  Created by Glaubert Moreira Schult on 15/06/15.
//  Copyright (c) 2015 GMS. All rights reserved.
//

import Foundation
import SystemConfiguration

class NetworkHelper {
    
    static var retorno : NSData!;
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    
    
//    class func send(request: NSMutableURLRequest) -> NSURLSessiond {
//        
//        //let semaphore = dispatch_semaphore_create(0);
//        
//        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
//            data, response, error in
//            
//            if error != nil
//            {
//                print("error=\(error)")
//                return
//            }
//        
//        }
//        
//        task.resume();
//        
//        //dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
//
//        return task;
//    }
    
    
//    func sendSyncronos(url: String, f: (NString?)-> ()) {
//        let request = NSURLRequest(URL: NSURL(string: url)!)
//        var data: NSData
//        
//        let semaphore = dispatch_semaphore_create(0)
//        
//        NSURLSession.sharedSession().dataTaskWithRequest(request) { (responseData, _, _) -> Void in
//            data = responseData! //treat optionals properly
//            dispatch_semaphore_signal(semaphore)
//        }
//        
//        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
//        
//        let reply = NSString(data: data, encoding: NSUTF8StringEncoding)
//        f(reply)
//    }
}