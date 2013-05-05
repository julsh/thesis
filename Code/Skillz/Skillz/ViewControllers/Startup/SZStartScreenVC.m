//
//  SZStartScreenVC.m
//  Skillz
//
//  Created by Julia Roggatz on 26.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZStartScreenVC.h"
#import "SZForm.h"
#import "SZFormFieldVO.h"
#import "SZDataManager.h"
#import "MBProgressHUD.h"
#import "SZUserPhotoView.h"
#import "NSDate+TimeAgo.h"
#import "SZMessageThreadVC.h"

@interface SZStartScreenVC ()

@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) MBProgressHUD* hud;
@property (nonatomic, strong) NSMutableArray* unreadMessages;
@property (nonatomic, strong) UITableView* unreadMessagesView;
@property (nonatomic, strong) UITableView* openDealsView;

@end

@implementation SZStartScreenVC

@synthesize unreadMessagesView = _unreadMessagesView;
@synthesize scrollView = _scrollView;
@synthesize hud = _hud;

- (void)viewDidLoad {
    [super viewDidLoad];
	[self addMenuButton];
	[self.navigationItem setTitle:@"Welcome!"];
	
	[self.view addSubview:self.scrollView];
	[self.scrollView addSubview:[self logo]];
	[self.hud show:YES];
	[SZDataManager updateMessageCacheWithCompletionBlock:^(NSArray* newMessages) {
		NSLog(@"message check completed");
		[self.hud hide:YES];
		if (newMessages && [newMessages count] > 0) {
			self.unreadMessages = [[NSMutableArray alloc] initWithArray:newMessages];
			
			[self.scrollView addSubview:self.unreadMessagesView];
			CGRect frame = self.unreadMessagesView.frame;
			frame.size.height = 36.0 + 64.0 * [self.unreadMessages count];
			self.unreadMessagesView.frame = frame;
			NSLog(@"contentheight: %f", self.unreadMessagesView.contentSize.height);
			
			
			NSLog(@"new messages: %i", [newMessages count]);
		}
	}];
	[SZDataManager updateOpenDealsCacheWithCompletionBlock:^(BOOL finished) {
		NSLog(@"deals check completed");
		// TODO somehow indicate if there are new messages
	}];
}

- (UIScrollView*)scrollView {
	if (_scrollView == nil) {
		_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 416.0)];
		[_scrollView setBackgroundColor:[UIColor clearColor]];
		[_scrollView setClipsToBounds:NO];
		[_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height)];
	}
	return _scrollView;
}

- (UIImageView*)logo {
	UIImageView* logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_transparent_shadow"]];
	[logo setCenter:CGPointMake(160.0, 65.0)];
	return logo;
}

- (MBProgressHUD*)hud {
	
	if (_hud == nil) {
		_hud = [[MBProgressHUD alloc] initWithView:self.view];
		[_hud setLabelFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:16.0]];
		[_hud setLabelText:@"Checking for new messages"];
		[_hud setDimBackground:YES];
		[_hud setRemoveFromSuperViewOnHide:YES];
		[self.view addSubview:_hud];
	}
	return _hud;
}

- (UITableView*)unreadMessagesView {
	if (_unreadMessagesView == nil) {
		_unreadMessagesView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 130.0, 320.0, 0.0)];
		[_unreadMessagesView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.3]];
		[_unreadMessagesView setScrollEnabled:NO];
		[_unreadMessagesView setDelegate:self];
		[_unreadMessagesView setDataSource:self];
	}
	return _unreadMessagesView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (tableView == self.unreadMessagesView) {
		return [self.unreadMessages count];
	}
	else {
		return 4;
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 30.0)];
	[view setBackgroundColor:[SZGlobalConstants petrol]];
	return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 36;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 64;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (tableView == self.unreadMessagesView) {
		
		static NSString *cellId = @"newMessageCell";
		
		UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
		
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
		}
		
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		PFObject* message = [self.unreadMessages objectAtIndex:indexPath.row];
		
		UILabel* messageTeaser = [[UILabel alloc] initWithFrame:CGRectMake(65.0, 45.0, 230.0, 15.0)];
		[messageTeaser setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:13.0]];
		[messageTeaser setTextColor:[SZGlobalConstants gray]];
		[messageTeaser applyWhiteShadow];
		[messageTeaser setText:[message valueForKey:@"messageText"]];
		[cell addSubview:messageTeaser];
		
		UILabel* timeAgoLabel = [[UILabel alloc] initWithFrame:CGRectMake(65.0, 24.0, 230.0, 15.0)];
		[timeAgoLabel setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBoldItalic size:13.0]];
		[timeAgoLabel setTextColor:[SZGlobalConstants gray]];
		[timeAgoLabel applyWhiteShadow];
		[timeAgoLabel setText:[[message valueForKey:@"createdAt"] timeAgo]];
		[cell addSubview:timeAgoLabel];
		
		PFUser* fromUser = [message valueForKey:@"fromUser"];
		[fromUser fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
			if (object) {
				UILabel* fromLabel = [[UILabel alloc] initWithFrame:CGRectMake(65.0, 5.0, 230.0, 15.0)];
				[fromLabel setFont:[SZGlobalConstants fontWithFontType:SZFontBold size:13.0]];
				[fromLabel setTextColor:[SZGlobalConstants darkPetrol]];
				[fromLabel applyWhiteShadow];
				[fromLabel setText:[object valueForKey:@"firstName"]];
				[cell addSubview:fromLabel];
				
				PFFile* photo = [object objectForKey:@"photo"];
				SZUserPhotoView* photoView = [SZUserPhotoView userPhotoViewWithSize:SZUserPhotoViewSizeSmall fileReference:photo];
				[photoView setFrame:CGRectMake(4.0, 4.0, photoView.frame.size.width, photoView.frame.size.height)];
				[cell addSubview:photoView];
//				[photo getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
//					if (data) {
//						NSLog(@"fetched photo!");
//						UIImage* img = [UIImage imageWithData:data];
//						[photoView setPhoto:img];
//					}
//					else if (error) {
//						NSLog(@"ERORRRR %@", error);
//					}
//				}];
			}
		}];
		
		return cell;
		
	}
	else return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	PFObject* message = [self.unreadMessages objectAtIndex:indexPath.row];
	NSString* fromUserId = [[message valueForKey:@"fromUser"] objectId];
	NSArray* messageThread = [SZDataManager getMessageThreadForUserId:fromUserId];
	
	SZMessageThreadVC* messageThreadVC = [[SZMessageThreadVC alloc] initWithMessageThread:messageThread];
	[self.navigationController pushViewController:messageThreadVC animated:YES];
	
}

@end
