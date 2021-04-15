#import "WifiManager.h"

@implementation WifiManager

-(NSMutableArray *)networks {
    WiFiNetworkRef manager = WiFiManagerClientCreate(kCFAllocatorDefault, 0);
    NSArray *networkRefs = (__bridge NSArray *) WiFiManagerClientCopyNetworks(manager);
    NSMutableArray *ssids = [[NSMutableArray alloc] init];
    for (id networkRef in networkRefs) {
        NSString *ssid = (__bridge NSString *) WiFiNetworkGetSSID((__bridge WiFiNetworkRef) networkRef);
        [ssids addObject: ssid];
    }
    return ssids;
}

@end
