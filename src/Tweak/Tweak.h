#import <Foundation/Foundation.h>
#include <dlfcn.h>
#import "NSTask.h"
#define plistPath @"/var/mobile/Library/Preferences/com.amywhile.macspoof.plist"
#define prefsNoti CFSTR("com.amywhile.macspoof.update")
#define forceReloadNoti CFSTR("com.amywhile.macspoof.force")

typedef struct __WiFiNetwork* WiFiNetworkRef;

@interface WFNetworkScanRecord : NSObject
@property (nonatomic,copy) NSString * ssid; 
-(NSString *)randomMACAddress;
@end

@interface WFClient : NSObject
+(id)sharedInstance;
-(void)setEnableRandomMACForNetwork:(id)arg1 enable:(BOOL)arg2 randomMAC:(id)arg3 ;
-(void)setCoreWiFiEnabled:(BOOL)arg1 ;
@end