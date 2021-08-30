#import "Tweak.h"

BOOL tweakEnabled;
NSDictionary *config;

%hook WFNetworkListRandomMACManager 

-(void)setRandomMAC:(id)arg1 forNetwork:(id)arg2 enabled:(BOOL)arg3 shouldAlwaysDisplayRandomAddress:(BOOL)arg4 {
	if (tweakEnabled) {
		if (config[arg2][@"Address"]) {
			return %orig(config[arg2][@"Address"], arg2, arg3, arg4);
		}
	} 
	return %orig;
}

%end

%hook WFClient

-(void)setEnableRandomMACForNetwork:(id)arg1 enable:(BOOL)arg2 randomMAC:(id)arg3 {
	if (tweakEnabled) {
		if (config[arg1][@"Address"]) {
			return %orig(arg1, arg2, config[arg1][@"Address"]);
		}
	} 
	return %orig;
}

%end

%hook WFNetworkScanRecord 

-(NSString *)randomMACAddress {
	if (tweakEnabled) {
		if (config[self.ssid][@"Address"]) {
			return config[self.ssid][@"Address"];
		}
	} 
	return %orig;
}

%end

void forceReload() {
	BOOL shouldToggle = false;
	for (id ssid in config.allKeys) {
		if (config[ssid][@"Address"]) {
			[[%c(WFClient) sharedInstance] setEnableRandomMACForNetwork:ssid enable: NO randomMAC: (config[ssid][@"Address"])];
			[[%c(WFClient) sharedInstance] setEnableRandomMACForNetwork:ssid enable: YES randomMAC: (config[ssid][@"Address"])];
			shouldToggle = true;
		}
	}
	if (!shouldToggle) {
		return;
	}
	NSTask *task = [[NSTask alloc] init];
	[task setLaunchPath:@"/usr/bin/killall"];
	[task setArguments:@[@"/usr/bin/killall", @"wifid" ]];
	[task launch];
}

void reloadPrefs() {
    NSUserDefaults *dict = [[NSUserDefaults alloc] initWithSuiteName: @"com.amywhile.macspoof"];
    tweakEnabled = [[dict objectForKey:@"GlobalEnable"] ?: @YES boolValue];
	config = [dict objectForKey:@"NetworksConfig"] ?: [[NSDictionary alloc] init];
	NSLog(@"[MacSpoof] TweakEnabled: %d, Config = %@", tweakEnabled, config);
	
}

%ctor {
	reloadPrefs();
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)reloadPrefs, prefsNoti, NULL, CFNotificationSuspensionBehaviorCoalesce);
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)forceReload, forceReloadNoti, NULL, CFNotificationSuspensionBehaviorCoalesce);
	dlopen("/System/Library/PrivateFrameworks/WiFiKit.framework/WiFiKit", RTLD_LAZY);
	%init;
}
