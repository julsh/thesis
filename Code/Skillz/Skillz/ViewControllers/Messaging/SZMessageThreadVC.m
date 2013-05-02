//
//  SZMessageThreadVC.m
//  Skillz
//
//  Created by Julia Roggatz on 22.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SZMessageThreadVC.h"
#import "SZMessageView.h"
#import "SZNewMessageVC.h"
#import "SZEntryDetailVC.h"
#import "SZMyEntryVC.h"
#import "SZButton.h"
#import "SZDataManager.h"
#import "Reachability.h"

@interface SZMessageThreadVC ()

@property (nonatomic, strong) UIActivityIndicatorView* spinner;
@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) UIView* messageAreaView;
@property (nonatomic, strong) NSArray* messageThreadArray;
@property (nonatomic, strong) NSString* otherUserName;
@property (nonatomic, strong) PFUser* otherUser;
@property (nonatomic, strong) UIImage* ownUserImage;
@property (nonatomic, strong) UIImage* otherUserImage;
@property (nonatomic, strong) NSDictionary* entryDict;
@property (nonatomic, strong) SZEntryObject* entry;
@property (nonatomic, strong) UIButton* entryButton;
@property (nonatomic, strong) NSMutableDictionary* pendingDealDict;
@property (nonatomic, strong) PFObject* pendingDeal;
@property (nonatomic, strong) UIView* pendingDealView;


@end

@implementation SZMessageThreadVC

- (id)initWithMessageThread:(NSArray*)messageThread {
	self = [super init];
	if (self) {
		self.messageThreadArray = messageThread;
		NSLog(@"%@", self.messageThreadArray);
		
		if ([[self.messageThreadArray objectAtIndex:0] valueForKey:@"otherUser"] && [[self.messageThreadArray objectAtIndex:0] valueForKey:@"otherUserImage"]) {
			self.otherUser = [[self.messageThreadArray objectAtIndex:0] valueForKey:@"otherUser"];
			self.otherUserName = [[[self.messageThreadArray objectAtIndex:0] valueForKey:@"otherUser"] valueForKey:@"firstName"];
			self.otherUserImage = [[self.messageThreadArray objectAtIndex:0] valueForKey:@"otherUserImage"];
		}
		else {
			
			NSDictionary* message = [messageThread objectAtIndex:0];
			NSString* otherUserID;
			if ([message valueForKey:@"fromUser"]) otherUserID = [message valueForKey:@"fromUser"];
			else if ([message valueForKey:@"toUser"]) otherUserID = [message valueForKey:@"toUser"];
			
			PFQuery *query = [PFUser query];
			[query getObjectInBackgroundWithId:otherUserID block:^(PFObject *object, NSError *error) {
				if (object) {
					self.otherUser = (PFUser*)object;
					self.otherUserName = [self.otherUser valueForKey:@"firstName"];
					PFFile* photo = [self.otherUser objectForKey:@"photo"];
					[photo getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
						if (data) {
							self.otherUserImage = [UIImage imageWithData:data];
//							[self displayContent];
						}
						else if (error) {
							NSLog(@"error %@", error);
						}
					}];
				}
			}];
		}
		
		PFFile* photo = [[PFUser currentUser] objectForKey:@"photo"];
		[photo getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
			if (data) {
				self.ownUserImage = [UIImage imageWithData:data];
//				[self displayContent];
			}
			else if (error) {
				NSLog(@"error %@", error);
			}
		}];
	}
	return self;
}

- (void)viewDidLoad {
	
	[super viewDidLoad];
	[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_pattern"]]];
	[self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Back"
																			   style:UIBarButtonItemStylePlain
																			  target:nil
																			  action:nil]];
	
	UIBarButtonItem* replyButton = [[UIBarButtonItem alloc] initWithTitle:@"Reply" style:UIBarButtonItemStylePlain target:self action:@selector(reply:)];
	[self.navigationItem setRightBarButtonItem:replyButton];
	[self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [SZGlobalConstants fontWithFontType:SZFontBold size:12.0], UITextAttributeFont,nil] forState:UIControlStateNormal];
	
	self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	[self.spinner setCenter:CGPointMake(160.0, 208.0)];
	[self.view addSubview:self.spinner];
	[self.spinner startAnimating];
	
}

- (void)viewDidAppear:(BOOL)animated {
	NSMutableArray* messagesGrouped = [[SZDataManager sharedInstance] getGroupedMessages];
	for (NSArray* messageThread in messagesGrouped) {
		NSDictionary* firstMessageDict = [messageThread objectAtIndex:0];
		if ([[firstMessageDict valueForKey:@"toUser"] isEqualToString:[self.otherUser objectId]] || [[firstMessageDict valueForKey:@"fromUser"] isEqualToString:[self.otherUser objectId]]) {
			self.messageThreadArray = messageThread;
			break;
		}
	}
//	self.hasEntry = NO;
//	self.hasPendingDeal = NO;
//	[self checkForEntry];
//	[self checkForPendingDeal];
	[self displayContent];
}

- (void)displayContent {
	
	for (UIView* view in [self.scrollView subviews]) {
		[view removeFromSuperview];
	}
	
//	BOOL entryLoaded = (self.hasEntry && self.entry) || !self.hasEntry;
//	BOOL dealLoaded = (self.hasPendingDeal && self.pendingDeal) || !self.hasPendingDeal;
	
	Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
	
	if ((self.ownUserImage && self.otherUserImage) || ![reach isReachable]) {
		
		[self.spinner stopAnimating];
		[self.spinner removeFromSuperview];
		
		[self.navigationItem setTitle:self.otherUserName];
		
		CGFloat contentHeight = 0.0;
		
		
		for (NSDictionary* message in self.messageThreadArray) {
			if ([message valueForKey:@"entry"]) {
				self.entryDict = [message valueForKey:@"entry"];
				[self.scrollView addSubview:self.entryButton];
				contentHeight+= self.entryButton.frame.size.height;
				
				PFObject* object = [PFObject objectWithoutDataWithClassName:@"Entry" objectId:[self.entryDict valueForKey:@"objectId"]];
				[object fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
					if (object) {
						self.entry = (SZEntryObject*)object;
					}
				}];
				break;
			}
		}
		
		for (NSDictionary* message in self.messageThreadArray) {
			if ([message valueForKey:@"proposedDeal"]) {
				self.pendingDealDict = [[NSMutableDictionary alloc] initWithDictionary:[message valueForKey:@"proposedDeal"]];
				self.pendingDealView = [self pendingDealViewContainer];
				[self.scrollView addSubview:self.pendingDealView];
				CGRect frame = self.pendingDealView.frame;
				frame.origin.y = contentHeight;
				self.pendingDealView.frame = frame;
				contentHeight += self.pendingDealView.frame.size.height;
				
				PFObject* object = [PFObject objectWithoutDataWithClassName:@"Deal" objectId:[self.pendingDealDict valueForKey:@"objectId"]];
				[object fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
					if (object) {
						self.pendingDeal = object;
					}
				}];
				break;
			}
		}
		
		self.messageAreaView = [[UIView alloc] initWithFrame:CGRectMake(0.0, contentHeight + 15.0, 320.0, 0.0)];
		[self.scrollView addSubview:self.messageAreaView];
		[self.view addSubview:self.scrollView];
		
		for (NSDictionary* message in self.messageThreadArray) {
			SZMessageView* messageView;
			if ([message valueForKey:@"fromUser"]) {
				messageView = [[SZMessageView alloc] initWithMessage:message image:self.otherUserImage position:SZMessageViewPositionRight];
			}
			else if ([message valueForKey:@"toUser"]) {
				messageView = [[SZMessageView alloc] initWithMessage:message image:self.ownUserImage position:SZMessageViewPositionLeft];
			}
			
			CGFloat contentHeight = self.messageAreaView.frame.size.height;
			
			CGRect frame = messageView.frame;
			frame.origin.y = contentHeight;
			messageView.frame = frame;
			[self.messageAreaView addSubview:messageView];
			
			frame = self.messageAreaView.frame;
			frame.size.height += messageView.frame.size.height;
			self.messageAreaView.frame = frame;
			
		}
		
		[self.scrollView setContentSize:CGSizeMake(self.scrollView.contentSize.width, self.messageAreaView.frame.origin.y + self.messageAreaView.frame.size.height)];
	}

}

- (UIScrollView*)scrollView {
	if (_scrollView == nil) {
		_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 416.0)];
		[_scrollView setContentSize:CGSizeMake(320.0, 15.0)];
	}
	return _scrollView;
}

#pragma mark - Entry View

//- (void)checkForEntry {
//	
//	// display entry that the message thread is referring to (if applicable)
//	NSString* entryId;
//	for (NSDictionary* message in self.messageThreadArray) {
//		if ([message valueForKey:@"entry"]) {
//			entryId = [message valueForKey:@"entry"];
//			self.hasEntry = YES;
//			break;
//		}
//	}
//	if (entryId) {
//		PFObject* entry = [PFObject objectWithoutDataWithClassName:@"Entry" objectId:entryId];
//		if ([entry isDataAvailable]) {
//			self.entry = (SZEntryObject*)entry;
//			[self displayContent];
//		}
//		else {
//			[entry fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
//				if (object) {
//					self.entry = (SZEntryObject*)entry;
//					[self displayContent];
//				}
//			}];
//		}
//	}
//	else {
//		[self displayContent];
//	}
//}


- (UIButton*)entryButton {
	
	if (_entryButton == nil) {
		_entryButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[_entryButton.layer setShadowColor:[UIColor blackColor].CGColor];
		[_entryButton.layer setShadowOpacity:0.3];
		[_entryButton.layer setShadowRadius:3.0];
		[_entryButton.layer setShadowOffset:CGSizeMake(0.0, 2.0)];
		
		[_entryButton setFrame:CGRectMake(0.0, 0.0, 320.0, 70.0)];
		[_entryButton setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.8]];
		
		UIView* lowerHighlight = [[UIView alloc] initWithFrame:CGRectMake(0.0, 69.0, 320.0, 1.0)];
		[lowerHighlight setBackgroundColor:[UIColor whiteColor]];
		[_entryButton addSubview:lowerHighlight];
		
		UILabel* regLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 10.0, 320.0, 14.0)];
		[regLabel setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:11.0]];
		[regLabel setTextColor:[SZGlobalConstants gray]];
		[regLabel applyWhiteShadow];
		
		NSString* whoseEntry;
		if ([[self.entryDict valueForKey:@"user"] isEqualToString:[self.otherUser objectId]]) {
			whoseEntry = [NSString stringWithFormat:@"Regarding %@'s %@:", [self.otherUser valueForKey:@"firstName"], [self.entryDict valueForKey:@"entryType"]];
		}
		else if ([[self.entryDict valueForKey:@"user"] isEqualToString:[[PFUser currentUser] objectId]]) {
			whoseEntry = [NSString stringWithFormat:@"Regarding Your %@:", [self.entryDict valueForKey:@"entryType"]];
		}
		[regLabel setText:whoseEntry];
		[_entryButton addSubview:regLabel];
		
		UILabel* entryTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40.0, 30.0, 250.0, 18.0)];
		[entryTitleLabel setFont:[SZGlobalConstants fontWithFontType:SZFontBold size:14.0]];
		[entryTitleLabel setTextColor:[SZGlobalConstants darkPetrol]];
		[entryTitleLabel applyWhiteShadow];
		[entryTitleLabel setText:[self.entryDict valueForKey:@"title"]];
		[_entryButton addSubview:entryTitleLabel];
		
		NSString* categoriesString = [self.entryDict valueForKey:@"category"];
		if ([self.entryDict valueForKey:@"subcategory"] != nil) {
			categoriesString = [categoriesString stringByAppendingFormat:@" > %@", [self.entryDict valueForKey:@"subcategory"]];
		}
		UILabel* categoriesLabel = [[UILabel alloc] initWithFrame:CGRectMake(40.0, 50.0, 260.0, 14.0)];
		[categoriesLabel setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBoldItalic size:11.0]];
		[categoriesLabel setTextColor:[SZGlobalConstants gray]];
		[categoriesLabel applyWhiteShadow];
		[categoriesLabel setText:categoriesString];
		[_entryButton addSubview:categoriesLabel];
		
		UIImageView* accessoryArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accessory_arrow"]];
		[accessoryArrow setCenter:CGPointMake(300.0, 35.0)];
		[_entryButton addSubview:accessoryArrow];
		
		[_entryButton addTarget:self action:@selector(deselectButton:) forControlEvents:UIControlEventTouchDragExit];
		[_entryButton addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchDown];
		[_entryButton addTarget:self action:@selector(showEntry:) forControlEvents:UIControlEventTouchUpInside];
	}
	
	return _entryButton;
}

- (void)selectButton:(UIButton*)sender {
	[sender setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.7]];
}

- (void)deselectButton:(UIButton*)sender {
	[sender setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.8]];
}

#pragma mark - Pending Deal View

//- (void)checkForPendingDeal {
//	
//	// display pending deal (if applicable)
//	NSString* pendingDealId;
//	for (NSDictionary* message in self.messageThreadArray) {
//		if ([message valueForKey:@"proposedDeal"]) {
//			pendingDealId = [message valueForKey:@"proposedDeal"];
//			self.hasPendingDeal = YES;
//			break;
//		}
//	}
//	if (pendingDealId) {
//		PFObject* pendingDeal = [PFObject objectWithoutDataWithClassName:@"Deal" objectId:pendingDealId];
//		if ([pendingDeal isDataAvailable]) {
//			self.pendingDeal = pendingDeal;
//			self.pendingDealView = [self pendingDealViewContainer];
//			[self displayContent];
//		}
//		else {
//			[pendingDeal fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
//				if (object) {
//					self.pendingDeal = object;
//					self.pendingDealView = [self pendingDealViewContainer];
//					[self displayContent];
//				}
//			}];
//		}
//	}
//	else {
//		[self displayContent];
//	}
//	
//}

- (UIView*)pendingDealViewContainer {
	
	UIView* pendingDealView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 80.0)];
	[pendingDealView setBackgroundColor:[SZGlobalConstants petrol]];
	
	UIView* darkUpperHighlight = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 1.0)];
	[darkUpperHighlight setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.7]];
	[pendingDealView addSubview:darkUpperHighlight];
	
	UIView* brightUpperHighlight = [[UIView alloc] initWithFrame:CGRectMake(0.0, 1.0, 320.0, 1.0)];
	[brightUpperHighlight setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.2]];
	[pendingDealView addSubview:brightUpperHighlight];
	
	UIView* brightLowerHighlight = [[UIView alloc] initWithFrame:CGRectMake(0.0, 78.0, 320.0, 1.0)];
	[brightLowerHighlight setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.2]];
	[pendingDealView addSubview:brightLowerHighlight];
	
	UIView* darkLowerHighlight = [[UIView alloc] initWithFrame:CGRectMake(0.0, 79.0, 320.0, 1.0)];
	[darkLowerHighlight setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.7]];
	[pendingDealView addSubview:darkLowerHighlight];
	
	
	if ([[self.pendingDealDict valueForKey:@"isAccepted"] boolValue]) {
		UIImageView* shakeHandsView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hands_shaken_57"]];
		CGRect frame = shakeHandsView.frame;
		frame.origin.x = 7.0;
		frame.origin.y = 12.0;
		shakeHandsView.frame = frame;
		[pendingDealView addSubview: shakeHandsView];
		
		UILabel* dealSealed = [[UILabel alloc] initWithFrame:CGRectMake(100.0, 21.0, 180.0, 14.0)];
		[dealSealed setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:13.0]];
		[dealSealed setTextColor:[UIColor whiteColor]];
		[dealSealed applyBlackShadow];
		[dealSealed setText:@"Deal Sealed!"];
		[pendingDealView addSubview:dealSealed];
		
		UIImageView* skillPointsImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"skillpoints_small"]];
		[skillPointsImg setFrame:CGRectMake(100.0, 41.0, skillPointsImg.frame.size.width, skillPointsImg.frame.size.height)];
		[pendingDealView addSubview:skillPointsImg];
		
		NSNumber* value = [self.pendingDealDict valueForKey:@"dealValue"];
		NSString* valueString = [NSString stringWithFormat:@"%i", [value intValue]];
		if ([self.pendingDeal valueForKey:@"hours"]) {
			NSNumber* hours = [self.pendingDealDict valueForKey:@"hours"];
			valueString = [valueString stringByAppendingFormat:@" for %i hours", [hours intValue]];
		}
		else {
			valueString = [valueString stringByAppendingString:@" for the job"];
		}
		UILabel* valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(123.0, 39.0, 180.0, 24.0)];
		[valueLabel setFont:[SZGlobalConstants fontWithFontType:SZFontBold size:18.0]];
		[valueLabel setTextColor:[UIColor whiteColor]];
		[valueLabel applyBlackShadow];
		[valueLabel setText:valueString];
		[pendingDealView addSubview:valueLabel];
	}
	
	else {
		
		UILabel* pendingDealProposal = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 8.0, 180.0, 14.0)];
		[pendingDealProposal setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:11.0]];
		[pendingDealProposal setTextColor:[UIColor whiteColor]];
		[pendingDealProposal applyBlackShadow];
		[pendingDealProposal setText:@"Pending Deal Proposal:"];
		[pendingDealView addSubview:pendingDealProposal];
		
		UIImageView* skillPointsImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"skillpoints_small"]];
		[skillPointsImg setFrame:CGRectMake(40.0, 25.0, skillPointsImg.frame.size.width, skillPointsImg.frame.size.height)];
		[pendingDealView addSubview:skillPointsImg];
		
		NSNumber* value = [self.pendingDealDict valueForKey:@"dealValue"];
		NSString* valueString = [NSString stringWithFormat:@"%i", [value intValue]];
		if ([self.pendingDeal valueForKey:@"hours"]) {
			NSNumber* hours = [self.pendingDealDict valueForKey:@"hours"];
			valueString = [valueString stringByAppendingFormat:@" for %i hours", [hours intValue]];
		}
		else {
			valueString = [valueString stringByAppendingString:@" for the job"];
		}
		UILabel* valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(63.0, 25.0, 180.0, 20.0)];
		[valueLabel setFont:[SZGlobalConstants fontWithFontType:SZFontBold size:14.0]];
		[valueLabel setTextColor:[UIColor whiteColor]];
		[valueLabel applyBlackShadow];
		[valueLabel setText:valueString];
		[pendingDealView addSubview:valueLabel];
		
		
		if ([[self.pendingDealDict valueForKey:@"fromUser"] isEqualToString:[self.otherUser objectId]]) {
			UIImageView* rightHandView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hand_stretched_right_57"]];
			
			CGRect frame = rightHandView.frame;
			frame.origin.x = 240.0;
			frame.origin.y = 12.0;
			rightHandView.frame = frame;
			[pendingDealView addSubview: rightHandView];
			
			SZButton* acceptButton = [[SZButton alloc] initWithColor:SZButtonColorOrange size:SZButtonSizeSmall width:80.0];
			[acceptButton addTarget:self action:@selector(acceptDeal:) forControlEvents:UIControlEventTouchUpInside];
			[acceptButton setTitle:@"Accept" forState:UIControlStateNormal];
			frame = acceptButton.frame;
			frame.origin.x = 38.0;
			frame.origin.y = 50.0;
			acceptButton.frame = frame;
			[pendingDealView addSubview:acceptButton];
			
			SZButton* declineButton = [[SZButton alloc] initWithColor:SZButtonColorOrange size:SZButtonSizeSmall width:80.0];
			[acceptButton addTarget:self action:@selector(declineDeal:) forControlEvents:UIControlEventTouchUpInside];
			[declineButton setTitle:@"Decline" forState:UIControlStateNormal];
			frame = declineButton.frame;
			frame.origin.x = 128.0;
			frame.origin.y = 50.0;
			declineButton.frame = frame;
			[pendingDealView addSubview:declineButton];
		}
		else {
			UIImageView* leftHandView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hand_stretched_left_57"]];
			CGRect frame = leftHandView.frame;
			frame.origin.x = 5.0;
			frame.origin.y = 12.0;
			leftHandView.frame = frame;
			[pendingDealView addSubview: leftHandView];
			
			frame = pendingDealProposal.frame;
			frame.origin.x = 90.0;
			pendingDealProposal.frame = frame;
			
			frame = skillPointsImg.frame;
			frame.origin.y += 5;
			frame.origin.x = 120.0;
			skillPointsImg.frame = frame;
			
			frame = valueLabel.frame;
			frame.origin.x = 143.0;
			frame.origin.y += 5;
			valueLabel.frame = frame;
			
			[pendingDealView addSubview: leftHandView];
			
			UILabel* waitingForResponseLabel = [[UILabel alloc] initWithFrame:CGRectMake(120.0, 54.0, 220.0, 14.0)];
			[waitingForResponseLabel setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBoldItalic size:11.0]];
			[waitingForResponseLabel setTextColor:[UIColor whiteColor]];
			[waitingForResponseLabel applyBlackShadow];
			[waitingForResponseLabel setText:[NSString stringWithFormat:@"Waiting for %@'s Respose", [self.otherUser valueForKey:@"firstName"]]];
			[pendingDealView addSubview:waitingForResponseLabel];
			
		}
	}
	
	
	return pendingDealView;
}

#pragma mark - User Actions

- (void)acceptDeal:(id)sender {
	[self.pendingDealDict setValue:[NSNumber numberWithBool:YES] forKey:@"isAccepted"];
	[[SZDataManager sharedInstance] markDealAccepted:[self.pendingDealDict valueForKey:@"objectId"]];
	[self.pendingDeal setValue:[NSNumber numberWithBool:YES] forKey:@"isAccepted"];
	[self.pendingDeal saveInBackground];
	[[SZDataManager sharedInstance] addOpenDealToUserCache:self.pendingDeal];
	[self.pendingDealView removeFromSuperview];
	CGFloat y = self.pendingDealView.frame.origin.y;
	self.pendingDealView = [self pendingDealViewContainer];
	[self.pendingDealView setFrame:CGRectMake(0.0, y, self.pendingDealView.frame.size.width, self.pendingDealView.frame.size.height)];
	[self.scrollView addSubview:self.pendingDealView];
}

- (void)declineDeal:(id)sender {
	
}

- (void)reply:(id)sender {

	SZNewMessageVC* newMessageVC = [[SZNewMessageVC alloc] initWithRecipient:self.otherUser];
	newMessageVC.messageType = SZMessageTypeReply;
	[self.navigationController pushViewController:newMessageVC animated:YES];
}

- (void)showEntry:(UIButton*)sender {
	[self deselectButton:sender];
	
	UIViewController* entryVC;
	if ([[[self.entry valueForKey:@"user"] objectId] isEqualToString:[self.otherUser objectId]]) {
		entryVC = [[SZEntryDetailVC alloc] initWithEntry:self.entry];
	}
	else if ([[[self.entry valueForKey:@"user"] objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
		entryVC = [[SZMyEntryVC alloc] initWithEntry:self.entry];
	}
	[self.navigationController pushViewController:entryVC animated:YES];
}

@end
