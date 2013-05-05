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
#import "SZDataManager.h"

@interface SZMyMessagesVC ()

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* messagesGrouped;

@end

@implementation SZMyMessagesVC

- (void)viewDidLoad {
    [super viewDidLoad];
	[self addMenuButton];
	[self setTitle:@"Messages"];
	
	UIActivityIndicatorView* spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	[spinner setCenter:CGPointMake(160.0, 208.0)];
	[spinner startAnimating];
	[self.view addSubview:spinner];
	
	__block BOOL messagesUpdated;
	__block BOOL dealsUpdated;
	
	[SZDataManager updateMessageCacheWithCompletionBlock:^(NSArray* newMessages) {
			messagesUpdated = YES;
			if (dealsUpdated) {
				[spinner removeFromSuperview];
				[self displayMessages];
			}
	}];
	[SZDataManager updateOpenDealsCacheWithCompletionBlock:^(BOOL finished) {
		if (finished) {
			dealsUpdated = YES;
			if (messagesUpdated) {
				[spinner removeFromSuperview];
				[self displayMessages];
			}
		}
	}];
}

- (void)displayMessages {
	self.messagesGrouped = [SZDataManager getGroupedMessages];
	[self.view addSubview:self.tableView];
	if ([self.messagesGrouped count] == 0) {
		[self showNoMessages];
	}
}

- (void)viewDidAppear:(BOOL)animated {
	self.messagesGrouped = [SZDataManager getGroupedMessages];
	[self.tableView reloadData];
	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
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
					[cell.userPhoto setPhoto:img];
				}
				else if (error) {
					NSLog(@"error %@", error);
				}
			}];
		}
	}];
	
	if ([message objectForKey:@"proposedDeal"]) {
		
		NSDictionary* deal = [message objectForKey:@"proposedDeal"];
		SZDealType dealType;
		if ([[deal valueForKey:@"isAccepted"] boolValue]) {
			dealType = SZDealSealed;
		}
		else {
			if ([[deal valueForKey:@"fromUser"] isEqualToString:[[PFUser currentUser] objectId]]) {
				dealType = SZDealOfferedToOtherUser;
			}
			else {
				dealType = SZDealOfferedFromOtherUser;
			}
		}
		UIView* dealBadge = [SZDealView dealBadgeForDealType:dealType];
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


@end
