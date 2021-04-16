#import "WiFiNetworkViewController.h"
#import "MacConfigViewController.h"

@implementation WiFiNetworkViewController
@end

@implementation WiFiNetworkViewController (Delegates)

-(void)viewDidLoad {
    WifiManager *wifiManager = [[WifiManager alloc] init];
    self.ssid = [wifiManager networks];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
	[self.view addSubview:self.tableView];
	
	self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
	[self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
	[self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
	[self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
	[self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;

	self.tableView.delegate = self;
	self.tableView.dataSource = self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    cell.textLabel.text = self.ssid[indexPath.row];
	cell.detailTextLabel.text = @"test";
	cell.accessoryType = 1;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath: indexPath animated: true];
	MacConfigViewController *configVC = [[MacConfigViewController alloc] init];
	[self.navigationController pushViewController: configVC animated: true];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.ssid.count;
}

@end