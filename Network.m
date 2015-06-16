//
//  Network.m
//  Sinesp
//
//  Created by serpro on 09/06/14.
//  Copyright (c) 2014 Serpro. All rights reserved.
//

#import "Network.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#include <netinet/in.h>


@implementation Network

+ (BOOL)hasConnection {
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    if (!didRetrieveFlags)
    {
        printf("Error. Could not recover network reachability flags\n");
        return 0;
    }
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    BOOL nonWifi = flags & kSCNetworkFlagsTransientConnection;
    
    return ((isReachable && !needsConnection) || !nonWifi) ? YES : NO;
}

@end
