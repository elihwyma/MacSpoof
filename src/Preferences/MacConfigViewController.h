#import <UIKit/UIKit.h>
#import <Preferences/PSViewController.h>
#import <Preferences/PSSpecifier.h>

@interface MacConfigViewController: PSViewController
@property UITableView *tableView;
@end

@interface MacConfigViewController (Delegates) <UITableViewDelegate, UITableViewDataSource>
@end