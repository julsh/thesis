//
//  SZMyEntriesVC.m
//  Skillz
//
//  Created by Julia Roggatz on 04.05.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZMyEntriesVC.h"
#import "SZDataManager.h"
#import "SZEntryCell.h"
#import "SZButton.h"
#import "SZMyEntryVC.h"
#import "SZNewEntryStep1VC.h"
#import "SZNavigationController.h"

@interface SZMyEntriesVC ()

@property (nonatomic, assign) SZEntryType entryType;
@property (nonatomic, strong) NSMutableArray* entries;
@property (nonatomic, strong) UITableView* entriesTableView;

@end

@implementation SZMyEntriesVC

@synthesize entries = _entries;
@synthesize entriesTableView = _entriesTableView;

- (id)initWithEntryType:(SZEntryType)entryType {
	self = [super init];
	if (self) {
		self.entryType = entryType;
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self addMenuButton];
	switch (self.entryType) {
		case SZEntryTypeOffer:
			[self.navigationItem setTitle:@"My Offers"];
			break;
		case SZEntryTypeRequest:
			[self.navigationItem setTitle:@"My Requests"];
			break;
	}
	[self.view addSubview:self.entriesTableView];
}

- (NSMutableArray*)entries {
	if (_entries == nil) {
		_entries = [[NSMutableArray alloc] init];
	}
	return _entries;
}

- (UITableView*)entriesTableView {
	if (_entriesTableView == nil) {
		_entriesTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 416.0) style:UITableViewStylePlain];
		[_entriesTableView setBackgroundColor:[UIColor clearColor]];
		[_entriesTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
		[_entriesTableView setDelegate:self];
		[_entriesTableView setDataSource:self];
	}
	return _entriesTableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.entries count] + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 64.0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *cellId = @"myEntryCell";
	static NSString *newCellId = @"newEntryCell";
	
	if (indexPath.row == 0) {
		UITableViewCell* newEntryCell = [tableView dequeueReusableCellWithIdentifier:newCellId];
		
		if (newEntryCell == nil) {
			newEntryCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:newCellId];
		}
		[newEntryCell setSelectionStyle:UITableViewCellSelectionStyleNone];
		
		SZButton* newEntryButton = [SZButton buttonWithColor:SZButtonColorPetrol size:SZButtonSizeLarge width:290.0];
		switch (self.entryType) {
			case SZEntryTypeOffer:
				[newEntryButton setTitle:@"Create New Offer" forState:UIControlStateNormal];
				break;
			case SZEntryTypeRequest:
				[newEntryButton setTitle:@"Create New Request" forState:UIControlStateNormal];
				break;
		}
		[newEntryButton setCenter:CGPointMake(160.0, 34.0)];
		[newEntryButton addTarget:self action:@selector(newEntry:) forControlEvents:UIControlEventTouchUpInside];
		[newEntryCell addSubview:newEntryButton];
		
		return newEntryCell;
	}
	
	SZEntryCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
	
	if (cell == nil) {
		cell = [[SZEntryCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
	}
	
	SZEntryObject *entry = [self.entries objectAtIndex:indexPath.row - 1];
	
	cell.textLabel.text = entry.title;
	
	NSString* category = entry.category;
	if (entry.subcategory) category = [category stringByAppendingFormat:@" > %@", entry.subcategory];
	cell.detailTextLabel.text = category;
	
	cell.activeSwitch.on = entry.isActive;
	[cell.activeSwitch setTag:indexPath.row - 1];
	[cell.activeSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.row == 0) {
		return;
	}
	
	SZEntryObject* entry = [self.entries objectAtIndex:indexPath.row - 1];
	SZMyEntryVC* vc = [[SZMyEntryVC alloc] initWithEntry:entry];
	[self.navigationController pushViewController:vc animated:YES];
	
}

- (void)switchChanged:(UISwitch*)sender {
	
	SZEntryObject* entry = [self.entries objectAtIndex:sender.tag];
	entry.isActive = sender.isOn;
	
	NSString* className;
	switch (self.entryType) {
		case SZEntryTypeOffer:
			className = @"Offer";
			break;
		case SZEntryTypeRequest:
			className = @"Request";
			break;
	}
	
	PFObject* serverObject = [PFQuery getObjectOfClass:className objectId:entry.objectId];
	[serverObject setValue:[NSNumber numberWithBool:entry.isActive] forKey:@"isActive"];
	[serverObject saveInBackground];
	
	[SZDataManager addEntryToUserCache:entry];
	
}

- (void)newEntry:(id)sender {
	[SZDataManager sharedInstance].currentEntryType = self.entryType;
	SZNavigationController* navController = [[SZNavigationController alloc] initWithRootViewController:[[SZNewEntryStep1VC alloc] initWithEntry:nil]];
	[navController setModalPresentationStyle:UIModalPresentationFullScreen];
	[self presentViewController:navController animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSIndexPath* selection = [self.entriesTableView indexPathForSelectedRow];
    if (selection) {
        [self.entriesTableView deselectRowAtIndexPath:selection animated:YES];
    }
	
	[self reloadRequests];
	[self.entriesTableView reloadData];
}

- (void)reloadRequests {
	self.entries = [[NSMutableArray alloc] init];
	
	NSString* key;
	switch (self.entryType) {
		case SZEntryTypeOffer:
			key = @"offers";
			break;
		case SZEntryTypeRequest:
			key = @"requests";
			break;
	}
	
	NSArray* myEntries = [[NSUserDefaults standardUserDefaults] objectForKey:key];
	if ([myEntries count] != 0) {
		for (NSDictionary* entryDict in myEntries) {
			SZEntryObject* entry = [SZEntryObject entryVOfromDictionary:entryDict];
			entry.type = SZEntryTypeRequest;
			entry.user = [PFUser currentUser];
			[self.entries addObject:entry];
		}
		if ([self.entriesTableView viewWithTag:99]) {
			[[self.entriesTableView viewWithTag:99] removeFromSuperview];
		}
	}
	else {
		[self showNoEntries];
	}
}

- (void)showNoEntries {
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 160.0, 320.0, 80.0)];
	[label setTag:99];
	[label setTextAlignment:NSTextAlignmentCenter];
	[label setFont:[SZGlobalConstants fontWithFontType:SZFontBold size:30.0]];
	[label setTextColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5]];
	[label applyWhiteShadow];
	switch (self.entryType) {
		case SZEntryTypeOffer:
			[label setText:@"No offer"];
			break;
		case SZEntryTypeRequest:
			[label setText:@"No requests"];
			break;
	}
	[self.entriesTableView addSubview:label];
}

@end
