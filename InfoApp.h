//
//  InfoApp.h
//  SinespCidadao
//
//  Created by Robson Saraiva Ximenes on 14/11/13.
//
//
#import <Foundation/Foundation.h>

@interface InfoApp : NSObject
    
+ (NSMutableArray*) getAppInfo;
+ (NSMutableArray*) getLocation;
+ (NSString*) getToken:(NSString*)value;

+ (double) getLatitude;
+ (void) setLatitude:(double)value;

+ (double) getLongitude;
+ (void) setLongitude:(double)value;
    
@end