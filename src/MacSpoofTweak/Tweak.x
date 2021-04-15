#import <Foundation/Foundation.h>
#include <dlfcn.h>

NSString *macWeGoingFor = @"c6:a0:2f:34:9d:e3";

%hook WFNetworkListRandomMACManager 

-(void)setRandomMAC:(id)arg1 forNetwork:(id)arg2 enabled:(BOOL)arg3 shouldAlwaysDisplayRandomAddress:(BOOL)arg4 {
	%orig(macWeGoingFor, arg2, arg3, arg4);
}

%end

%hook WFClient

-(void)setEnableRandomMACForNetwork:(id)arg1 enable:(BOOL)arg2 randomMAC:(id)arg3 {
	%orig(arg1, arg2, macWeGoingFor);
}

%end

%hook WFNetworkScanRecord 

-(NSString *)randomMACAddress {
	return macWeGoingFor;
}

-(void)setRandomMACAddress:(NSString *)arg1 {
	%orig(macWeGoingFor);
}

%end

%hook WFDetailContextPrivateAddressConfig 

-(NSString *)randomMACAddress { 
	return macWeGoingFor;
}

-(id)initWithRandomMACAddress:(id)arg1 hardwareMACAddress:(id)arg2 randomMACSwitchOn:(BOOL)arg3 randomMACFeatureEnabled:(BOOL)arg4 randomMACAddressConfigurable:(BOOL)arg5 enabledForSecureNetworks:(BOOL)arg6 randomMACAddressDisabled:(BOOL)arg7 connectedWithHardwareAddress:(BOOL)arg8 {
	return %orig(macWeGoingFor, arg2, arg3, arg4, arg5, arg6, arg7, arg8);
}

%end

%ctor {
	dlopen("/System/Library/PrivateFrameworks/WiFiKit.framework/WiFiKit", RTLD_LAZY);
	%init;
}