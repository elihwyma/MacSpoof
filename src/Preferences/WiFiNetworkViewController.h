#import <UIKit/UIKit.h>
#import <Preferences/PSViewController.h>
#import <Preferences/PSSpecifier.h>
#import "WifiManager.h"
#define prefsNoti CFSTR("com.amywhile.macspoof.update")

@interface WiFiNetworkViewController: PSViewController
@property UITableView *tableView;
@property NSMutableArray *ssid;
@property NSUserDefaults *defaults;
- (BOOL)isValidMacAddress:(NSString *)macAddress;
- (void)presentConfigAlert:(NSString *)ssid;
- (void)presentErrorAlert:(NSString *)invalidMac ssid:(NSString *)ssid;
@end

@interface WiFiNetworkViewController (Delegates) <UITableViewDelegate, UITableViewDataSource>
@end