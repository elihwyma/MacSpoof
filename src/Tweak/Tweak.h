#import <Foundation/Foundation.h>
#include <dlfcn.h>
#define plistPath @"/var/mobile/Library/Preferences/com.amywhile.macspoof.plist"
#define prefsNoti CFSTR("com.amywhile.macspoof.update")

typedef struct __WiFiNetwork* WiFiNetworkRef;

@interface WFNetworkScanRecord : NSObject
@property (nonatomic,copy) NSString * ssid; 
-(NSString *)randomMACAddress;
@end