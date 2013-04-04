//
//  SZMyOffersVC.m
//  Skillz
//
//  Created by Julia Roggatz on 04.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZMyOffersVC.h"
#import "SZDataManager.h"
#import "SZEntryCell.h"
#import "SZButton.h"
#import "SZMyEntryVC.h"
#import "SZNewEntryStep1VC.h"
#import "SZNavigationController.h"

@interface SZMyOffersVC ()

@property (nonatomic, strong) NSMutableArray* offers;
@property (nonatomic, strong) UITableView* offersTableView;

@end

@implementation SZMyOffersVC

@synthesize offers = _offers;
@synthesize offersTableView = _offersTableView;


- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.navigationItem setTitle:@"My Offers"];
	[self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil]];
	
	[self.view addSubview:self.offersTableView];
}

- (NSMutableArray*)offers {
	if (_offers == nil) {
		_offers = [[NSMutableArray alloc] init];
	}
	return _offers;
}

- (UITableView*)offersTableView {
	if (_offersTableView == nil) {
		_offersTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 416.0) style:UITableViewStylePlain];
		[_offersTableView setBackgroundColor:[UIColor clearColor]];
		[_offersTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
		[_offersTableView setDelegate:self];
		[_offersTableView setDataSource:self];
	}
	return _offersTableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.offers count] + 1;
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
		[newRequestButton setTitle:@"Create New Offer" forState:UIControlStateNormal];
		[newRequestButton setCenter:CGPointMake(160.0, 34.0)];
		[newRequestButton addTarget:self action:@selector(newRequest:) forControlEvents:UIControlEventTouchUpInside];
		[newRequestCell addSubview:newRequestButton];
		
		return newRequestCell;
	}
	
	SZEntryCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
	
	if (cell == nil) {
		cell = [[SZEntryCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
	}
	
	SZEntryVO *offer = [self.offers objectAtIndex:indexPath.row - 1];
	
	cell.textLabel.text = offer.title;
	
	NSString* category = offer.category;
	if (offer.subcategory) category = [category stringByAppendingFormat:@" > %@", offer.subcategory];
	cell.detailTextLabel.text = category;
	
	cell.activeSwitch.on = offer.isActive;
	[cell.activeSwitch setTag:indexPath.row - 1];
	[cell.activeSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.row == 0) {
		return;
	}
	
	SZEntryVO* offer = [self.offers objectAtIndex:indexPath.row - 1];
	SZMyEntryVC* vc = [[SZMyEntryVC alloc] initWithEntry:offer type:SZEntryTypeRequest];
	[self.navigationController pushViewController:vc animated:YES];
	
}

- (void)switchChanged:(UISwitch*)sender {
	
	SZEntryVO* offer = [self.offers objectAtIndex:sender.tag];
	offer.isActive = sender.isOn;
	
	PFObject* serverObject = [PFQuery getObjectOfClass:@"Request" objectId:offer.objectID];
	[serverObject setValue:[NSNumber numberWithBool:offer.isActive] forKey:@"isActive"];
	[serverObject saveInBackground];
	
	[[SZDataManager sharedInstance] updateEntryCacheWithEntry:offer type:SZEntryTypeRequest];
	
}

- (void)newRequest:(id)sender {
	[SZDataManager sharedInstance].currentEntryType = SZEntryTypeOffer;
	SZNavigationController* navController = [[SZNavigationController alloc] initWithRootViewController:[[SZNewEntryStep1VC alloc] initWithEntry:nil]];
	[navController setModalPresentationStyle:UIModalPresentationFullScreen];
	[self presentViewController:navController animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSIndexPath* selection = [self.offersTableView indexPathForSelectedRow];
    if (selection) {
        [self.offersTableView deselectRowAtIndexPath:selection animated:YES];
    }
	
	[self reloadRequests];
	[self.offersTableView reloadData];
}

- (void)reloadRequests {
	self.offers = [[NSMutableArray alloc] init];
	NSArray* myOffers = [[NSUserDefaults standardUserDefaults] objectForKey:@"offers"];
	if ([myOffers count] != 0) {
		for (NSDictionary* reqDict in myOffers) {
			SZEntryVO* offer = [SZEntryVO entryVOfromDictionary:reqDict];
			offer.user = [SZDataManager sharedInstance].currentUser;
			[self.offers addObject:offer];
		}
	}
}

@end
