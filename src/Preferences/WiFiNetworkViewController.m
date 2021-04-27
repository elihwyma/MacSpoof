#import "WiFiNetworkViewController.h"

@implementation WiFiNetworkViewController

- (BOOL)isValidMacAddress:(NSString *)macAddress {
    NSString *macRegEx = @"^([0-9A-Fa-f]{2}[:]){5}([0-9A-Fa-f]{2})$";
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:macRegEx options:NSRegularExpressionCaseInsensitive error:&error];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:macAddress options:0 range:NSMakeRange(0, [macAddress length])] ?: 0;
    if ((error != NULL) || (numberOfMatches == 0)) {
        return NO;
	}
    return YES;
}

-(void)presentErrorAlert:(NSString *)invalidMac ssid:(NSString *)ssid {
	NSString *message = [NSString stringWithFormat:@"The Mac Address %@ is invalid", invalidMac];
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Invalid Mac Address" message:message preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *retry = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:^(UIAlertAction *alertAction) {
		[self presentConfigAlert: ssid];
	}];
	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
	[alertController addAction:retry];
	[alertController addAction:cancelAction];
	[self presentViewController:alertController animated:YES completion:nil];
}

-(void)presentConfigAlert:(NSString *)ssid {
	NSString *message = [NSString stringWithFormat:@"Config for %@", ssid];
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:ssid message:message preferredStyle:UIAlertControllerStyleAlert];
	NSDictionary *configDict = [self.defaults dictionaryForKey: @"NetworksConfig"] ?: [[NSDictionary alloc] init];
	NSMutableDictionary *config = [[NSMutableDictionary alloc] init];
	for (id key in configDict.allKeys) {
		[config setObject: configDict[key] forKey: key];
	}
	[alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
		textField.placeholder = @"MAC Address";
		if ([config objectForKey: ssid]) {
			textField.text = ([config objectForKey: ssid])[@"Address"];
		}
	}];
	UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction *alertAction) {
		UITextField *mac = alertController.textFields.firstObject;
		NSString *lowerCased = [mac.text lowercaseString];
		if ([self isValidMacAddress: lowerCased]) {
			NSDictionary *ssidConfigDict = config[ssid] ?: [[NSDictionary alloc] init];
			NSMutableDictionary *ssidConfig = [[NSMutableDictionary alloc] init];
			for (id key in ssidConfigDict.allKeys) {
				[ssidConfig setObject: ssidConfigDict[key] forKey: key];
			}
			[ssidConfig setValue: lowerCased forKey: @"Address"];
			[config setValue: ssidConfig forKey: ssid];
			[self.defaults setObject:config forKey: @"NetworksConfig"];
			[self.defaults synchronize];
			[self.tableView reloadData];
			CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), prefsNoti, NULL, NULL, YES);
			return;
		} else {
			[self presentErrorAlert: lowerCased ssid: ssid];
			return;
		}
	}];
	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
	[alertController addAction:okAction];
	[alertController addAction:cancelAction];
	[self presentViewController:alertController animated:YES completion:nil];
}

@end

@implementation WiFiNetworkViewController (Delegates)

-(void)viewDidLoad {
    WifiManager *wifiManager = [[WifiManager alloc] init];
    self.ssid = [wifiManager networks];
	self.defaults = [[NSUserDefaults alloc] initWithSuiteName: @"com.amywhile.macspoof"];

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
	NSDictionary *configDict = [self.defaults dictionaryForKey: @"NetworksConfig"] ?: [[NSDictionary alloc] init];
	if (configDict[self.ssid[indexPath.row]]) {
		cell.detailTextLabel.text = configDict[self.ssid[indexPath.row]][@"Address"];
	} else {
		cell.detailTextLabel.text = @"Default";
	}
	cell.accessoryType = 1;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath: indexPath animated: true];
	[self presentConfigAlert: self.ssid[indexPath.row]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.ssid.count;
}

@end