#import "Tweak.h"

BOOL tweakEnabled;
NSDictionary *config;

%hook WFNetworkListRandomMACManager 

-(void)setRandomMAC:(id)arg1 forNetwork:(id)arg2 enabled:(BOOL)arg3 shouldAlwaysDisplayRandomAddress:(BOOL)arg4 {
	if (tweakEnabled) {
		if (config[arg2][@"Address"]) {
			%orig(config[arg2][@"Address"], arg2, arg3, arg4);
		}
	} 
	return %orig;
}

%end

%hook WFClient

-(void)setEnableRandomMACForNetwork:(id)arg1 enable:(BOOL)arg2 randomMAC:(id)arg3 {
	if (tweakEnabled) {
		if (config[arg1][@"Address"]) {
			%orig(arg1, arg2, config[arg1][@"Address"]);
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
/*
%hook WFDetailContextPrivateAddressConfig 

-(NSString *)randomMACAddress { 
	if (tweakEnabled) {
		if (config[self.ssid][@"Address"]) {
			return config[self.ssid][@"Address"];
		}
	} 
	return %orig;
}

-(id)initWithRandomMACAddress:(id)arg1 hardwareMACAddress:(id)arg2 randomMACSwitchOn:(BOOL)arg3 randomMACFeatureEnabled:(BOOL)arg4 randomMACAddressConfigurable:(BOOL)arg5 enabledForSecureNetworks:(BOOL)arg6 randomMACAddressDisabled:(BOOL)arg7 connectedWithHardwareAddress:(BOOL)arg8 {
	if (tweakEnabled) {
		if (config[self.ssid][@"Address"]) {
			return %orig(config[self.ssid][@"Address"], arg2, arg3, arg4, arg5, arg6, arg7, arg8);
		}
	} 
	return %orig;
}

%end
*/

%hook WFInterface 

-(void)_updateCurrentNetworkWithNetwork:(WiFiNetworkRef)arg1 forceUpdateNetwork:(BOOL)arg2 callback:(/*^block*/id)arg3 userInfo:(id)arg4 {
	NSLog(@"[MacSpoof] userInfo = %@", arg4);
	%orig;
}

%end
void reloadPrefs() {
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:plistPath] ?: [NSDictionary dictionary];
    tweakEnabled = [[dict objectForKey:@"GlobalEnable"] ?: @YES boolValue];
	config = dict[@"NetworksConfig"] ?: [[NSDictionary alloc] init];
	NSLog(@"[MacSpoof] Prefs have loaded");
}

%ctor {
	reloadPrefs();
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)reloadPrefs, prefsNoti, NULL, CFNotificationSuspensionBehaviorCoalesce);
	dlopen("/System/Library/PrivateFrameworks/WiFiKit.framework/WiFiKit", RTLD_LAZY);
	%init;
}