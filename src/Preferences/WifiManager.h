#import <Foundation/Foundation.h>

typedef struct __WiFiNetwork* WiFiNetworkRef;
typedef struct __WiFiManager* WiFiManagerRef;

extern WiFiManagerRef WiFiManagerClientCreate(CFAllocatorRef allocator, int flags);
extern CFArrayRef WiFiManagerClientCopyNetworks(WiFiManagerRef manager);
extern CFStringRef WiFiNetworkGetSSID(WiFiNetworkRef network);

@interface WifiManager: NSObject
-(NSMutableArray *)networks;
@end

