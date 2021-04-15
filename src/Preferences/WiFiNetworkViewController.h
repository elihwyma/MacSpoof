#import <UIKit/UIKit.h>
#import <Preferences/PSViewController.h>
#import <Preferences/PSSpecifier.h>
#import "WifiManager.h"

@interface WiFiNetworkViewController: PSViewController
@property UITableView *tableView;
@property NSMutableArray *ssid;
@end

@interface WiFiNetworkViewController (Delegates) <UITableViewDelegate, UITableViewDataSource>
@end