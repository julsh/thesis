//
//  SZOpenDealsVC.m
//  Skillz
//
//  Created by Julia Roggatz on 05.05.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZOpenDealsVC.h"
#import "SZDataManager.h"
#import "SZOpenDealCell.h"

@interface SZOpenDealsVC ()

@property (nonatomic, strong) NSMutableArray* openDeals;

@end

@implementation SZOpenDealsVC

- (id)init
{
    self = [super init];
    if (self) {
		self.tableView.delegate = self;
		self.tableView.dataSource = self;
		[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
		self.openDeals = [[NSMutableArray alloc] initWithArray:[SZDataManager getOpenDeals]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[self addMenuButton];
	[self.navigationItem setTitle:@"Open Deals"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.openDeals count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 114.0;
}

- (SZOpenDealCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *cellId = @"dealCell";
	
	SZOpenDealCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
	
	if (cell == nil) {
		cell = [[SZOpenDealCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
	}
	
	NSMutableDictionary* deal = [self.openDeals objectAtIndex:indexPath.row];
	
	// setting the title of the deal
	cell.entryTitleLabel.text = [deal valueForKey:@"entryTitle"];
	
	NSString* otherUserName = @"";
	
	// determining whose entry the deal refers to and what kind of entry it is
	NSString* whoseEntryText;
	if ([[deal valueForKey:@"isOwnEntry"] boolValue]) {
		whoseEntryText = @"Your";
	}
	else {
		if ([deal valueForKey:@"fromUserName"]) {
			otherUserName = [deal valueForKey:@"fromUserName"];
			whoseEntryText = [NSString stringWithFormat:@"%@'s", otherUserName];
		}
		else if ([deal valueForKey:@"toUserName"]) {
			otherUserName = [deal valueForKey:@"toUserName"];
			whoseEntryText = [NSString stringWithFormat:@"%@'s", otherUserName];
		}
	}
	if ([[deal valueForKey:@"entryType"] isEqual:@"request"])
		whoseEntryText = [whoseEntryText stringByAppendingString:@" Request:"];
	else if ([[deal valueForKey:@"entryType"] isEqual:@"offer"])
		whoseEntryText = [whoseEntryText stringByAppendingString:@" Offer:"];
	
	cell.whoseEntryLabel.text = whoseEntryText;
	
	NSNumber* hours = [deal valueForKey:@"hours"];
	
	// determining if u get paid for the deal or if you have to pay
	if (([[deal valueForKey:@"isOwnEntry"] boolValue] && [[deal valueForKey:@"entryType"] isEqual:@"request"]) ||
	   (![[deal valueForKey:@"isOwnEntry"] boolValue] && [[deal valueForKey:@"entryType"] isEqual:@"offer"])) {
		
			// It's your own request. You'll pay the other user for it
			[cell setDealPartnerName:[NSString stringWithFormat:@"%@ gets paid", otherUserName]
						   dealPrice:[NSString stringWithFormat:@"%i for %@", [[deal valueForKey:@"dealValue"] integerValue],
									  hours ? [NSString stringWithFormat:@"%i hours", [hours integerValue]] : @"the job"]];

	}
	else {
		// It's your own offer. Someone else will pay you for it
		[cell setDealPartnerName:[NSString stringWithFormat:@"%@ pays you", otherUserName]
					   dealPrice:[NSString stringWithFormat:@"%i for %@", [[deal valueForKey:@"dealValue"] integerValue],
								  hours ? [NSString stringWithFormat:@"%i hours", [hours integerValue]] : @"the job"]];
	}
	
	NSString* otherUserId;
	if ([[deal valueForKey:@"fromUser"] isEqual:@"self"]) otherUserId = [deal valueForKey:@"toUser"];
	else otherUserId = [deal valueForKey:@"fromUser"];
	
	PFQuery *query = [PFUser query];
	[query getObjectInBackgroundWithId:otherUserId block:^(PFObject *object, NSError *error) {
		if (object) {
			PFUser* otherUser = (PFUser*)object;
			PFFile* photo = [otherUser objectForKey:@"photo"];
			[photo getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
				if (data) {
					UIImage* img = [UIImage imageWithData:data];
					[cell.userPhoto setPhoto:img];
				}
				else if (error) {
					NSLog(@"error %@", error);
				}
			}];
		}
	}];
	
	return cell;
}



@end
