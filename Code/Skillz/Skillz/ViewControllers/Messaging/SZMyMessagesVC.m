//
//  SZMyMessagesVC.m
//  Skillz
//
//  Created by Julia Roggatz on 21.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZMyMessagesVC.h"
#import <Parse/Parse.h>
#import "SZMessageCell.h"
#import "NSDate+TimeAgo.h"
#import "SZDealView.h"
#import "SZMessageThreadVC.h"

@interface SZMyMessagesVC ()

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* messagesGrouped;
@property (nonatomic, strong) NSMutableDictionary* usersArray;
//@property (nonatomic, assign) NSInteger fetchCount;

@end

@implementation SZMyMessagesVC

- (id)init
{	
    if (self) {
		
		NSMutableDictionary* messagesGrouped = [[NSMutableDictionary alloc] init];
		NSDictionary* messages = [[NSUserDefaults standardUserDefaults] objectForKey:@"messages"];
		self.usersArray = [[NSMutableDictionary alloc] init];
		
		self.messagesGrouped = [[NSMutableArray alloc] init];
		
		NSArray* messageKeys = [messages allKeys];
		for (NSString* key in messageKeys) {
			NSMutableDictionary* message = [[NSMutableDictionary alloc] initWithDictionary:[messages valueForKey:key]];
			[message setObject:key forKey:@"timeStamp"];
			
			NSString* userID;
			if ([message valueForKey:@"fromUser"]) userID = [message valueForKey:@"fromUser"];
			else if ([message valueForKey:@"toUser"]) userID = [message valueForKey:@"toUser"];
			
			NSMutableArray* messageArray;
			if ([messagesGrouped valueForKey:userID]) {
				messageArray = [messagesGrouped valueForKey:userID];
			}
			else {
				messageArray = [[NSMutableArray alloc] init];
				[messagesGrouped setObject:messageArray forKey:userID];
				
			}
			[messageArray addObject:message];
		}
		
		// sort messages within each message group, display the newest first
		for (NSString* key in [messagesGrouped allKeys]) {
			NSMutableArray* messageArray = [messagesGrouped valueForKey:key];
			[messageArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
				if ([[obj1 valueForKey:@"timeStamp"] compare:[obj2 valueForKey:@"timeStamp"] options:NSCaseInsensitiveSearch] == NSOrderedAscending) {
					return NSOrderedDescending;
				}
				if ([[obj1 valueForKey:@"timeStamp"] compare:[obj2 valueForKey:@"timeStamp"] options:NSCaseInsensitiveSearch] == NSOrderedDescending) {
					return NSOrderedAscending;
				}
				else {
					return NSOrderedSame;
				}
			}];
			[self.messagesGrouped addObject:messageArray];
		}
		
		// sort grouped messages, diplay the newest first
		[self.messagesGrouped sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
			if ([[[obj1 objectAtIndex:0] valueForKey:@"timeStamp"] compare:[[obj2 objectAtIndex:0] valueForKey:@"timeStamp"] options:NSCaseInsensitiveSearch] == NSOrderedAscending) {
				return NSOrderedDescending;
			}
			if ([[[obj1 objectAtIndex:0] valueForKey:@"timeStamp"] compare:[[obj2 objectAtIndex:0] valueForKey:@"timeStamp"] options:NSCaseInsensitiveSearch] == NSOrderedDescending) {
				return NSOrderedAscending;
			}
			else {
				return NSOrderedSame;
			}
		}];
		
		NSLog(@"%@", self.messagesGrouped);
		
		
//		self.fetchCount = 0;
		
//		PFQuery* query = [PFQuery queryWithClassName:@"Message"];
//		[query whereKey:@"toUser" equalTo:[PFUser currentUser]];
//
//        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//			if (objects) {
//				NSLog(@"number of objects: %i", [objects count]);
//				if ([objects count] > 0) { // found something!
//					NSLog(@"found something");
//					for (int i = 0; i < [objects count]; i++) {
//						PFObject* result = [objects objectAtIndex:i];
//						PFUser *user = [result objectForKey:@"fromUser"];
//						[user fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
//							NSLog(@"fetched User");
//							if (object) {
//								NSLog(@"successfully");
//								[self.messages addObject:result];
//								
//								self.fetchCount++;
//								NSLog(@"fetchCount: %i", self.fetchCount);
//								if (self.fetchCount == [objects count]) {
//									[self.tableView reloadData];
//								}
//							}
//							else if (error) {
//								NSLog(@"Error: %@ %@", error, [error userInfo]);
//								self.fetchCount++;
//								if (self.fetchCount == [objects count]) {
//									[self.tableView reloadData];
//								}
//							}
//						}];
//					}
//				}
//				else { // nothing found
//					[self showNoMessages];
//				}
//			}
//			else if (error) {
//				NSLog(@"Error: %@ %@", error, [error userInfo]);
//			}
//		}];
    }
    return self;
}

- (UITableView*)tableView {
	if (_tableView == nil) {
		_tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
		[_tableView setDelegate:self];
		[_tableView setDataSource:self];
		[_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
		[_tableView setBackgroundColor:[UIColor clearColor]];
	}
	return _tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Back"
																			   style:UIBarButtonItemStylePlain
																			  target:nil
																			  action:nil]];
	[self setTitle:@"My Messages"];
	
	[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_pattern"]]];
	[self.view addSubview:self.tableView];
	
	if ([self.messagesGrouped count] == 0) {
		[self showNoMessages];
	}
}

- (void)showNoMessages {
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 160.0, 320.0, 80.0)];
	[label setTextAlignment:NSTextAlignmentCenter];
	[label setFont:[SZGlobalConstants fontWithFontType:SZFontBold size:30.0]];
	[label setTextColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5]];
	[label applyWhiteShadow];
	[label setText:@"No messages"];
	[self.tableView addSubview:label];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.messagesGrouped count];}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 104.0;
}

- (SZMessageCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *cellId = @"messageCell";
	
	SZMessageCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
	
	if (cell == nil) {
		cell = [[SZMessageCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
	}
	
	NSMutableDictionary* message = [[self.messagesGrouped objectAtIndex:indexPath.row] objectAtIndex:0];
	
	NSString* otherUserName;
	if ([message valueForKey:@"fromUser"]) otherUserName = [message valueForKey:@"fromUserName"];
	else if ([message valueForKey:@"toUser"]) otherUserName = [message valueForKey:@"toUserName"];
	
	cell.userNameLabel.text = otherUserName;
	cell.timeLabel.text = [[NSDate dateWithTimeIntervalSince1970:[[message valueForKey:@"timeStamp"] floatValue]] timeAgo];
	
	if ([message valueForKey:@"messageText"]) {
		NSString* messageText = [message valueForKey:@"messageText"];
		cell.messageTeaserLabel.text = [messageText stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
	}
	
	NSString* otherUserID;
	if ([message valueForKey:@"fromUser"]) otherUserID = [message valueForKey:@"fromUser"];
	else if ([message valueForKey:@"toUser"]) otherUserID = [message valueForKey:@"toUser"];
	
	PFQuery *query = [PFUser query];
	NSLog(@"query for user id: %@", otherUserID);
	[query getObjectInBackgroundWithId:otherUserID block:^(PFObject *object, NSError *error) {
		if (object) {
			PFUser* otherUser = (PFUser*)object;
			[message setObject:otherUser forKey:@"otherUser"];
			PFFile* photo = [otherUser objectForKey:@"photo"];
			[photo getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
				if (data) {
					UIImage* img = [UIImage imageWithData:data];
					[message setObject:img forKey:@"otherUserImage"];
					[cell.userPhoto.photo setImage:img];
				}
				else if (error) {
					NSLog(@"error %@", error);
				}
			}];
		}
	}];
	
	if ([message objectForKey:@"proposedDeal"]) {
		
		UIView* dealBadge = [SZDealView dealBadgeForDealAccepted:[[message valueForKey:@"hasAcceptedDeal"] boolValue]];
		CGRect frame = dealBadge.frame;
		frame.origin.x = 220.0;
		frame.origin.y = 2.0;
		dealBadge.frame = frame;
		[cell addSubview:dealBadge];
		
	}
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	SZMessageThreadVC* messageThreadVC = [[SZMessageThreadVC alloc] initWithMessageThread:[self.messagesGrouped objectAtIndex:indexPath.row]];
	[self.navigationController pushViewController:messageThreadVC animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

@end
