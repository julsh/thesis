//
//  SZMyRequestsVC.m
//  Skillz
//
//  Created by Julia Roggatz on 02.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZMyRequestsVC.h"
#import "SZDataManager.h"
#import "SZEntryCell.h"
#import "SZButton.h"
#import "SZMyEntryVC.h"
#import "SZNewEntryStep1VC.h"
#import "SZNavigationController.h"

@interface SZMyRequestsVC ()

@property (nonatomic, strong) NSMutableArray* requests;
@property (nonatomic, strong) UITableView* requestsTableView;

@end

@implementation SZMyRequestsVC

@synthesize requests = _requests;
@synthesize requestsTableView = _requestsTableView;


- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.navigationItem setTitle:@"My Requests"];
	[self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil]];
	
	[self.view addSubview:self.requestsTableView];
}

- (NSMutableArray*)requests {
	if (_requests == nil) {
		_requests = [[NSMutableArray alloc] init];
	}
	return _requests;
}

- (UITableView*)requestsTableView {
	if (_requestsTableView == nil) {
		_requestsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 416.0) style:UITableViewStylePlain];
		[_requestsTableView setBackgroundColor:[UIColor clearColor]];
		[_requestsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
		[_requestsTableView setDelegate:self];
		[_requestsTableView setDataSource:self];
	}
	return _requestsTableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.requests count] + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 64.0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *cellId = @"myEntryCell";
	static NSString *newCellId = @"newEntryCell";
	
	if (indexPath.row == 0) {
		UITableViewCell* newRequestCell = [tableView dequeueReusableCellWithIdentifier:newCellId];
		
		if (newRequestCell == nil) {
			newRequestCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:newCellId];
		}
		[newRequestCell setSelectionStyle:UITableViewCellSelectionStyleNone];
		
		SZButton* newRequestButton = [[SZButton alloc] initWithColor:SZButtonColorPetrol size:SZButtonSizeLarge width:290.0];
		[newRequestButton setTitle:@"Create New Request" forState:UIControlStateNormal];
		[newRequestButton setCenter:CGPointMake(160.0, 34.0)];
		[newRequestButton addTarget:self action:@selector(newRequest:) forControlEvents:UIControlEventTouchUpInside];
		[newRequestCell addSubview:newRequestButton];
		
		return newRequestCell;
	}
	
	SZEntryCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
	
	if (cell == nil) {
		cell = [[SZEntryCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
	}
	
	SZEntryObject *request = [self.requests objectAtIndex:indexPath.row - 1];
	
	cell.textLabel.text = request.title;
	
	NSString* category = request.category;
	if (request.subcategory) category = [category stringByAppendingFormat:@" > %@", request.subcategory];
	cell.detailTextLabel.text = category;
	
	cell.activeSwitch.on = request.isActive;
	[cell.activeSwitch setTag:indexPath.row - 1];
	[cell.activeSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.row == 0) {
		return;
	}
	
	SZEntryObject* request = [self.requests objectAtIndex:indexPath.row - 1];
	SZMyEntryVC* vc = [[SZMyEntryVC alloc] initWithEntry:request];
	[self.navigationController pushViewController:vc animated:YES];
	
}

- (void)switchChanged:(UISwitch*)sender {
	
	SZEntryObject* request = [self.requests objectAtIndex:sender.tag];
	request.isActive = sender.isOn;
	
	PFObject* serverObject = [PFQuery getObjectOfClass:@"Request" objectId:request.objectId];
	[serverObject setValue:[NSNumber numberWithBool:request.isActive] forKey:@"isActive"];
	[serverObject saveInBackground];
	
	[[SZDataManager sharedInstance] updateEntryCacheWithEntry:request];
	
}

- (void)newRequest:(id)sender {
	[SZDataManager sharedInstance].currentEntryType = SZEntryTypeRequest;
	SZNavigationController* navController = [[SZNavigationController alloc] initWithRootViewController:[[SZNewEntryStep1VC alloc] initWithEntry:nil]];
	[navController setModalPresentationStyle:UIModalPresentationFullScreen];
	[self presentViewController:navController animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSIndexPath* selection = [self.requestsTableView indexPathForSelectedRow];
    if (selection) {
        [self.requestsTableView deselectRowAtIndexPath:selection animated:YES];
    }
	
	[self reloadRequests];
	[self.requestsTableView reloadData];
}

- (void)reloadRequests {
	self.requests = [[NSMutableArray alloc] init];
	NSArray* myRequests = [[NSUserDefaults standardUserDefaults] objectForKey:@"requests"];
	if ([myRequests count] != 0) {
		for (NSDictionary* reqDict in myRequests) {
			SZEntryObject* request = [SZEntryObject entryVOfromDictionary:reqDict];
			request.type = SZEntryTypeRequest;
			request.user = [PFUser currentUser];
			[self.requests addObject:request];
		}
	}
}

@end
