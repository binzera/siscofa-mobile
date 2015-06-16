
#import "InfoApp.h"
#import "Criptografia.h"

#import <ifaddrs.h>
#import <arpa/inet.h>

static double latitude = 0;
static double longitude = 0;

@implementation InfoApp

    NSString* salt = @"7lYS859X6fhB5Ow";

+ (NSMutableDictionary*) getAppInfo{

    NSString* appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSString *ipAddress = [self getIPAddress];
    NSNumber *ltt = [NSNumber numberWithDouble:latitude];
    NSNumber *lng = [NSNumber numberWithDouble:longitude];
    
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc] initWithCapacity:5];
    
    [result setObject:appName forKey:@"appName"];
    [result setObject:appVersion forKey:@"appVersion"];
    [result setObject:ipAddress forKey:@"ipAddress"];
    [result setObject:ltt forKey:@"latitude"];
    [result setObject:lng forKey:@"longitude"];
    

    
    NSLog(@"IP: %@", ipAddress);
    
    return result;
}

+ (NSMutableArray*) getLocation{

    
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:3];
    [result addObject:[NSNumber numberWithDouble:latitude]];
    [result addObject:[NSNumber numberWithDouble:longitude]];
    
    return result;

}
    
+(NSString*)getToken:(NSString *)placa{
    NSString *key = [NSString stringWithFormat:@"%@%@", placa, salt];
    
    NSString *hash = [Criptografia codificarHmacAlgSHA1:key :placa];
    
    return hash;
}
    
// Get IP Address
+ (NSString *)getIPAddress {
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    NSString *wifiAddress = nil;
    NSString *cellAddress = nil;
    
    // retrieve the current interfaces - returns 0 on success
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            sa_family_t sa_type = temp_addr->ifa_addr->sa_family;
            if(sa_type == AF_INET || sa_type == AF_INET6) {
                NSString *name = [NSString stringWithUTF8String:temp_addr->ifa_name];
                NSString *addr = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)]; // pdp_ip0
                NSLog(@"NAME: \"%@\" addr: %@", name, addr); // see for yourself
                
                if([name isEqualToString:@"en0"]) {
                    // Interface is the wifi connection on the iPhone
                    wifiAddress = addr;
                } else
                if([name isEqualToString:@"pdp_ip0"]) {
                    // Interface is the cell connection on the iPhone
                    cellAddress = addr;
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    NSString *addr = wifiAddress ? wifiAddress : cellAddress;
    return addr ? addr : @"0.0.0.0";
}

+ (double) getLatitude{return latitude;}

+ (void)setLatitude:(double)value{
    latitude = value;
}

+ (double) getLongitude{return longitude;}

+ (void) setLongitude:(double)value{
    longitude = value;
}
    
    @end