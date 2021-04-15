#import "WiFiNetworkViewController.h"

@implementation WiFiNetworkViewController
@end

@implementation WiFiNetworkViewController (Delegates)

-(void)viewDidLoad {
    WifiManager *wifiManager = [[WifiManager alloc] init];
    self.ssid = [wifiManager networks];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleInsetGrouped];
	[self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"Cell"];
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
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = self.ssid[indexPath.row];
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.ssid.count;
}

@end