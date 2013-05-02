//
//  SZNewMessageVC.m
//  Skillz
//
//  Created by Julia Roggatz on 20.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZNewMessageVC.h"
#import "SZButton.h"
#import "SZSegmentedControlHorizontal.h"
#import "SZFormFieldVO.h"
#import "SZUtils.h"
#import "MBProgressHUD.h"
#import "SZDataManager.h"
#import "Reachability.h"

@interface SZNewMessageVC ()

@property (nonatomic, strong) SZEntryObject* entry;
@property (nonatomic, strong) PFUser* recipient;
@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) SZForm* messageForm;
@property (nonatomic, strong) SZButton* dealButton;
@property (nonatomic, strong) SZButton* sendButton;
@property (nonatomic, strong) UIView* dealView;
@property (nonatomic, strong) UIView* dealFormArea;
@property (nonatomic, strong) SZForm* hourForm;
@property (nonatomic, strong) SZForm* hourRateForm;
@property (nonatomic, strong) SZForm* jobRateForm;
@property (nonatomic, strong) UILabel* totalLabel;
@property (nonatomic, strong) UIImageView* totalPointsIcon;
@property (nonatomic, strong) SZSegmentedControlHorizontal* dealTypeSelector;
@property (nonatomic, assign) BOOL hasDealProposal;

@end

@implementation SZNewMessageVC

@synthesize messageForm = _messageForm;
@synthesize dealButton = _dealButton;
@synthesize sendButton = _sendButton;
@synthesize dealTypeSelector = _dealTypeSelector;

- (id)initWithRecipient:(PFUser*)recipient {
	self = [super init];
	if (self) {
		self.recipient = recipient;
	}
	return self;
}

- (id)initWithEntry:(SZEntryObject*)entry {
	self = [super init];
	if (self) {
		self.entry = entry;
		self.recipient = entry.user;
	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	switch (self.messageType) {
		case SZMessageTypeFirstContact:
			[self.navigationItem setTitle:[NSString stringWithFormat:@"Contact %@", [self.recipient valueForKey:@"firstName"]]];
			break;
			
		case SZMessageTypeReply:
			[self.navigationItem setTitle:@"Reply"];
			break;
	}
	
	UIBarButtonItem* sendButton = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStylePlain target:self action:@selector(sendMessage:)];
	[self.navigationItem setRightBarButtonItem:sendButton];
	[self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [SZGlobalConstants fontWithFontType:SZFontBold size:12.0], UITextAttributeFont,nil] forState:UIControlStateNormal];
	
	[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_pattern"]]];
	
	[self.view addSubview:self.scrollView];
	[self.scrollView addSubview:self.messageForm];
	[self.scrollView addSubview:self.dealButton];
	[self.scrollView addSubview:self.sendButton];
}

- (UIScrollView*)scrollView {
	if (_scrollView == nil) {
		_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 416.0)];
		[_scrollView setBackgroundColor:[UIColor clearColor]];
		[_scrollView setClipsToBounds:NO];
		[_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height)];
		
		UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTapped:)];
		[tapRecognizer setNumberOfTapsRequired:1];
		[_scrollView addGestureRecognizer:tapRecognizer];
	}
	return _scrollView;
}

- (SZForm*)messageForm {
	if (_messageForm == nil) {
		SZFormFieldVO* messageField = [[SZFormFieldVO alloc] init];
		messageField.key = @"message";
		_messageForm = [[SZForm alloc] initForTextViewWithItem:messageField width:310.0 height:290.0];
		[_messageForm setDelegate:self];
		CGRect frame = _messageForm.frame;
		frame.origin.x = frame.origin.y = 5.0;
		_messageForm.frame = frame;
		[_messageForm configureKeyboard];
	}
	return _messageForm;
}

- (SZButton*)dealButton {
	
	if (_dealButton == nil) {
		_dealButton = [[SZButton alloc] initWithColor:SZButtonColorPetrol size:SZButtonSizeLarge width:290.0];
		[_dealButton setTitle:@"Attach a Deal Proposal" forState:UIControlStateNormal];
		[_dealButton setCenter:CGPointMake(160.0, 330.0)];
		[_dealButton addTarget:self action:@selector(attachDeal:) forControlEvents:UIControlEventTouchUpInside];
	}
	
	return _dealButton;
}

- (SZButton*)sendButton {
	
	if (_sendButton == nil) {
		_sendButton = [[SZButton alloc] initWithColor:SZButtonColorPetrol size:SZButtonSizeLarge width:290.0];
		[_sendButton setTitle:@"Send Message" forState:UIControlStateNormal];
		[_sendButton setCenter:CGPointMake(160.0, 380.0)];
		[_sendButton addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
		return _sendButton;
	}
	return _sendButton;
}

- (UIView*)dealView {
	if (_dealView == nil) {
		_dealView = [[UIView alloc] initWithFrame:CGRectMake(320.0, 170.0, 320.0, 130.0)];
		[_dealView addSubview:self.dealTypeSelector];
		[_dealView addSubview:self.dealFormArea];
		
		if (self.entry && self.entry.price) {
			if (self.entry.priceIsFixedPerHour) {
				[self.dealTypeSelector setSelectedSegmentIndex:0];
				
				CGRect frame = self.dealFormArea.frame;
				frame.origin.x = 0.0;
				self.dealFormArea.frame = frame;
				
				frame = _dealView.frame;
				frame.origin.x = 320.0;
				_dealView.frame = frame;
				
				[self.hourRateForm setText:[self.entry.price stringValue] forFieldAtIndex:0];
			}
			else if (self.entry.priceIsFixedPerJob) {
				[self.dealTypeSelector setSelectedSegmentIndex:1];
				
				CGRect frame = self.dealFormArea.frame;
				frame.origin.x = -320.0;
				self.dealFormArea.frame = frame;
				
				frame = _dealView.frame;
				frame.origin.x = -320.0;
				_dealView.frame = frame;
				
				[self.jobRateForm setText:[self.entry.price stringValue] forFieldAtIndex:0];
			}
		}
	}
	return _dealView;
}

- (UIView*)dealFormArea {
	if (_dealFormArea == nil) {
		_dealFormArea = [[UIView alloc] initWithFrame:CGRectMake(0.0, 50.0, 640.0, 80.0)];
		
		UILabel* hoursLabel = [[UILabel alloc] initWithFrame:CGRectMake(85.0, 7.0, 70.0, 15.0)];
		[hoursLabel setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:14.0]];
		[hoursLabel setTextColor:[SZGlobalConstants darkGray]];
		[hoursLabel applyWhiteShadow];
		[hoursLabel setText:@"hours at"];
		
		UILabel* hourRateLabel = [[UILabel alloc] initWithFrame:CGRectMake(87.0, 23.0, 70.0, 15.0)];
		[hourRateLabel setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:14.0]];
		[hourRateLabel setTextColor:[SZGlobalConstants darkGray]];
		[hourRateLabel applyWhiteShadow];
		[hourRateLabel setText:@"a rate of:"];
		
		UIImageView* hourPointsIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"skillpoints_medium"]];
		[hourPointsIcon setFrame:CGRectMake(162.0, 5.0, hourPointsIcon.frame.size.width, hourPointsIcon.frame.size.height)];
		
		UILabel* perHourLabel = [[UILabel alloc] initWithFrame:CGRectMake(265.0, 15.0, 65.0, 15.0)];
		[perHourLabel setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:14.0]];
		[perHourLabel setTextColor:[SZGlobalConstants darkGray]];
		[perHourLabel applyWhiteShadow];
		[perHourLabel setText:@"/hour"];
		
		UIImageView* hourPointsIcon2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"skillpoints_medium"]];
		[hourPointsIcon2 setFrame:CGRectMake(375.0, 25.0, hourPointsIcon.frame.size.width, hourPointsIcon.frame.size.height)];
		
		UILabel* jobLabel = [[UILabel alloc] initWithFrame:CGRectMake(480.0, 30.0, 150.0, 24.0)];
		[jobLabel setFont:[SZGlobalConstants fontWithFontType:SZFontBold size:20.0]];
		[jobLabel setTextColor:[SZGlobalConstants darkPetrol]];
		[jobLabel applyWhiteShadow];
		[jobLabel setText:@"for the job"];
		
		[_dealFormArea addSubview:self.hourForm];
		[_dealFormArea addSubview:hoursLabel];
		[_dealFormArea addSubview:hourRateLabel];
		[_dealFormArea addSubview:self.hourRateForm];
		[_dealFormArea addSubview:hourPointsIcon];
		[_dealFormArea addSubview:perHourLabel];
		[_dealFormArea addSubview:self.totalLabel];
		[_dealFormArea addSubview:self.totalPointsIcon];
		
		[_dealFormArea addSubview:self.jobRateForm];
		[_dealFormArea addSubview:hourPointsIcon2];
		[_dealFormArea addSubview:jobLabel];
	}
	return _dealFormArea;
}

- (SZForm*)hourForm {
	if (_hourForm == nil) {
		_hourForm = [[SZForm alloc] initWithWidth:60.0];
		[_hourForm setDelegate:self];
		SZFormFieldVO* hourField = [SZFormFieldVO formFieldValueObjectForTextWithKey:@"hours" placeHolderText:@"4" keyboardType:UIKeyboardTypeDecimalPad];
		[_hourForm addItem:hourField showsClearButton:NO isLastItem:YES];
		[_hourForm setScrollContainer:self.scrollView];
		[_hourForm configureKeyboard];
		[_hourForm setFrame:CGRectMake(15.0, 0.0, _hourForm.frame.size.width, _hourForm.frame.size.height)];
	}
	return _hourForm;
}

- (SZForm*)hourRateForm {
	if (_hourRateForm == nil) {
		_hourRateForm = [[SZForm alloc] initWithWidth:60.0];
		[_hourRateForm setDelegate:self];
		SZFormFieldVO* hourRateField = [SZFormFieldVO formFieldValueObjectForTextWithKey:@"hourRate" placeHolderText:@"15" keyboardType:UIKeyboardTypeDecimalPad];
		[_hourRateForm addItem:hourRateField showsClearButton:NO isLastItem:YES];
		[_hourRateForm setScrollContainer:self.scrollView];
		[_hourRateForm configureKeyboard];
		[_hourRateForm setFrame:CGRectMake(198.0, 0.0, _hourRateForm.frame.size.width, _hourRateForm.frame.size.height)];
	}
	return _hourRateForm;
}

- (UILabel*)totalLabel {
	if (_totalLabel == nil) {
		_totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 290.0, 24.0)];
		[_totalLabel setCenter:CGPointMake(160.0, 60.0)];
		[_totalLabel setFont:[SZGlobalConstants fontWithFontType:SZFontBold size:20.0]];
		[_totalLabel setTextColor:[SZGlobalConstants darkPetrol]];
		[_totalLabel applyWhiteShadow];
		[_totalLabel setHidden:YES];
	}
	return _totalLabel;
}

- (UIImageView*)totalPointsIcon {
	if (_totalPointsIcon == nil) {
		_totalPointsIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"skillpoints_medium"]];
		[_totalPointsIcon setFrame:CGRectMake(0.0, 48.0, _totalPointsIcon.frame.size.width, _totalPointsIcon.frame.size.height)];
		[_totalPointsIcon setHidden:YES];
	}
	return _totalPointsIcon;
}

- (void)formInputDidChange:(UITextField*)textField {
	
	if (([[textField superview] superview] == self.hourRateForm && textField.text && [self.hourForm textFieldAtIndex:0].text ) ||
		([[textField superview] superview] == self.hourForm && textField.text && [self.hourRateForm textFieldAtIndex:0].text)) {
		[self setTotalText];
	}
}

- (void)setTotalText {
	
	if ([self.hourForm textFieldAtIndex:0].text && [self.hourRateForm textFieldAtIndex:0].text) {
		CGFloat hours = [[self.hourForm textFieldAtIndex:0].text floatValue];
		NSLog(@"hours %f", hours);
		CGFloat hourRate = [[self.hourRateForm textFieldAtIndex:0].text floatValue];
		CGFloat total = hours * hourRate;
		
		if (total > 0.0) {
			
			if (total - (NSInteger)total == 0.0) {
				[self.totalLabel setText:[NSString stringWithFormat:@"That's a total of        %i.", (NSInteger)total]];
			}
			else {
				[self.totalLabel setText:[NSString stringWithFormat:@"That's a total of        %2f.", total]];
			}
			
			[self.totalLabel sizeToFit];
			[self.totalLabel setCenter:CGPointMake(160.0, self.totalLabel.center.y)];
			
			CGRect frame = self.totalPointsIcon.frame;
			frame.origin.x = self.totalLabel.frame.origin.x + 165.0;
			self.totalPointsIcon.frame = frame;
			
			[self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, 146.0) animated:YES];
			[self.totalPointsIcon setHidden:NO];
			[self.totalLabel setHidden:NO];
		}
		else {
			[self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, 116.0) animated:YES];
			[self.totalPointsIcon setHidden:YES];
			[self.totalLabel setHidden:YES];
		}
	}
}

- (SZForm*)jobRateForm {
	if (_jobRateForm == nil) {
		_jobRateForm = [[SZForm alloc] initWithWidth:60.0];
		SZFormFieldVO* jobRateField = [SZFormFieldVO formFieldValueObjectForTextWithKey:@"jobRate" placeHolderText:@"60" keyboardType:UIKeyboardTypeDecimalPad];
		[_jobRateForm addItem:jobRateField showsClearButton:NO isLastItem:YES];
		[_jobRateForm setScrollContainer:self.scrollView];
		[_jobRateForm configureKeyboard];
		[_jobRateForm setFrame:CGRectMake(410.0, 20.0, _jobRateForm.frame.size.width, _jobRateForm.frame.size.height)];
	}
	return _jobRateForm;
}

- (SZSegmentedControlHorizontal*)dealTypeSelector {
	if (_dealTypeSelector == nil) {
		_dealTypeSelector = [[SZSegmentedControlHorizontal alloc] initWithFrame:CGRectMake(15.0, 0.0, 290.0, 40.0)];
		[_dealTypeSelector insertSegmentWithTitle:@"Hour-based" atIndex:0 animated:NO];
		[_dealTypeSelector insertSegmentWithTitle:@"Job-based" atIndex:1 animated:NO];
		[_dealTypeSelector setSelectedSegmentIndex:0];
		[_dealTypeSelector addTarget:self action:@selector(dealTypeChanged:) forControlEvents:UIControlEventValueChanged];
	}
	return _dealTypeSelector;
}

- (void)dealTypeChanged:(SZSegmentedControlHorizontal*)sender {
	NSLog(@"deal type changed");
	if (sender.selectedSegmentIndex == 0) {
		[UIView animateWithDuration:0.2 animations:^{
			CGRect frame = self.dealFormArea.frame;
			frame.origin.x = 0.0;
			self.dealFormArea.frame = frame;
		}];
	}
	else if (sender.selectedSegmentIndex == 1) {
		[UIView animateWithDuration:0.2 animations:^{
			CGRect frame = self.dealFormArea.frame;
			frame.origin.x = -320.0;
			self.dealFormArea.frame = frame;
		}];
	}
}

- (void)formDidBeginEditing:(SZForm *)form {
	
	if (form == self.messageForm && !self.hasDealProposal) {
		[self.messageForm setTextViewHeight:145.0 forTextViewAtIndex:0 animated:YES];
		[UIView animateWithDuration:0.3 animations:^{
			[_dealButton setCenter:CGPointMake(160.0, 185.0)];
			[_sendButton setCenter:CGPointMake(160.0, 235.0)];
		} completion:nil];
	}
	else if ((form == self.hourRateForm && !self.hourForm.isActive) || (form == self.hourForm && !self.hourRateForm.isActive)) {
		if (!self.totalLabel.hidden) {
			[self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, 30.0) animated:YES];
		}
	}
}

- (void)formDidEndEditing:(SZForm *)form {
	
	if (form == self.messageForm && !self.hasDealProposal) {
		[self.messageForm setTextViewHeight:290.0 forTextViewAtIndex:0 animated:YES];
		[UIView animateWithDuration:0.3 animations:^{
			[_dealButton setCenter:CGPointMake(160.0, 330.0)];
			[_sendButton setCenter:CGPointMake(160.0, 380.0)];
		} completion:nil];
	}
	
}


- (void)attachDeal:(id)sender {
	
	self.hasDealProposal = YES;
	
	[self.messageForm setTextViewHeight:155.0 forTextViewAtIndex:0 animated:YES];
	
	[self.scrollView addSubview:self.dealView];
	[UIView animateWithDuration:0.2 delay:0.3 options:UIViewAnimationOptionCurveLinear animations:^{
		CGRect frame = self.dealView.frame;
		frame.origin.x = 0.0;
		self.dealView.frame = frame;
	} completion:^(BOOL finished) {
		[self.dealButton changeBackgroundColor:SZButtonColorOrange];
		[self.dealButton setTitle:@"Remove Deal Proposal" forState:UIControlStateNormal];
		[self.sendButton setTitle:@"Send Message & Deal Proposal" forState:UIControlStateNormal];
		
		[self.dealButton removeTarget:self action:@selector(attachDeal:) forControlEvents:UIControlEventTouchUpInside];
		[self.dealButton addTarget:self action:@selector(removeDeal:) forControlEvents:UIControlEventTouchUpInside];
	}];
	
}

- (void)removeDeal:(id)sender {
	
	self.hasDealProposal = NO;

	[UIView animateWithDuration:0.2 animations:^{
		CGRect frame = self.dealView.frame;
		frame.origin.x = self.dealFormArea.frame.origin.x == 0.0 ? 320.0 : -320.0;
		self.dealView.frame = frame;
		
	} completion:^(BOOL finished) {
		
		[self.dealView removeFromSuperview];
		
		[self.messageForm setTextViewHeight:290.0 forTextViewAtIndex:0 animated:YES];
		[self.dealButton changeBackgroundColor:SZButtonColorPetrol];
		[self.dealButton setTitle:@"Add Deal Proposal" forState:UIControlStateNormal];
		[self.sendButton setTitle:@"Send Message" forState:UIControlStateNormal];
		
		[self.dealButton removeTarget:self action:@selector(removeDeal:) forControlEvents:UIControlEventTouchUpInside];
		[self.dealButton addTarget:self action:@selector(attachDeal:) forControlEvents:UIControlEventTouchUpInside];
		
	}];
}

- (UIView*)successView {
	
	UIView* successView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 416.0)];
	UIImageView* checkMark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark_big"]];
	[checkMark setCenter:CGPointMake(180.0, 175.0)];
	[successView addSubview:checkMark];
	
	UILabel* sentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 210.0, 320.0, 100.0)];
	[sentLabel setFont:[SZGlobalConstants fontWithFontType:SZFontBold size:24.0]];
	[sentLabel setTextColor:[SZGlobalConstants darkPetrol]];
	[sentLabel applyWhiteShadow];
	[sentLabel setTextAlignment:NSTextAlignmentCenter];
	[sentLabel setText:@"Message Sent"];
	[successView addSubview:sentLabel];
	
	return successView;
}

- (void)sendMessage:(id)sender {
	
	[self resignAllForms];
	
	PFObject* message = [self createMessageObject];
	if (!message) {
		return;
	}
	
	MBProgressHUD* hud = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:hud];
	[hud setDimBackground:YES];
	[hud setRemoveFromSuperViewOnHide:YES];
	[hud show:YES];
	
	Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
	if (![reach isReachable]) {	// network not available
		NSLog(@"network not available");
		[hud hide:YES];
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Couldn't send your message. Please check your network connection and try again." delegate:nil cancelButtonTitle:@"Okay!" otherButtonTitles:nil];
		[alertView show];
		return;
	}
	else {	// network available
		[message saveEventually:^(BOOL succeeded, NSError *error) {
			if (succeeded) {
				
				[hud setLabelText:@"Message Sent"];
				[hud setMode:MBProgressHUDModeCustomView];
				[hud setCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark_hud"]]];
				
				dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
				dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
					[hud hide:YES];
					[self.navigationController popViewControllerAnimated:YES];
				});
				
				[[SZDataManager sharedInstance] addMessageToUserCache:message completionBlock:nil];
				
				PFQuery *pushQuery = [PFInstallation query];			// creating a query
				[pushQuery whereKey:@"user" equalTo:self.recipient];	// finding the user receiving the message
				PFPush *push = [[PFPush alloc] init];					// creating the push object
				[push setQuery:pushQuery];								// assigning the query to the push object
				[push setMessage:@"You received a new message!"];		// specifying the notification message
				[push sendPushInBackground];							// sending out the notification
			}	
			else if (error) {
				[hud hide:YES];
				NSLog(@"%@ %@", error, error.userInfo);
			}
		}];
	}
	
	
}

- (PFObject*)createMessageObject {
	
	PFObject* message = [PFObject objectWithClassName:@"Message"];
	[message setObject:self.recipient forKey:@"toUser"];
	[message setObject:[PFUser currentUser] forKey:@"fromUser"];
	
	// check if neither message nor deal proposal has been specified, show alert
	if (![self.messageForm.userInputs valueForKey:@"message"] && !self.hasDealProposal) {
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"No Content." message:@"To send a message, you should provide at least a message text or a deal proposal" delegate:self cancelButtonTitle:@"Okay!" otherButtonTitles:nil];
		[alertView show];
		return nil;
	}
	
	if ([self.messageForm.userInputs valueForKey:@"message"]) {
		[message setObject:[self.messageForm.userInputs valueForKey:@"message"] forKey:@"messageText"];
	}
	if (self.entry) {
		[message setObject:self.entry forKey:@"entry"];
	}
	
	if (self.hasDealProposal) {
		
		PFObject* dealProposal = [PFObject objectWithClassName:@"Deal"];
		[dealProposal setValue:[NSNumber numberWithBool:NO] forKey:@"isAccepted"];
		
		if (self.dealTypeSelector.selectedSegmentIndex == 0) {
			if (self.totalLabel.isHidden) {
				UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Incomplete Deal Proposal" message:@"Please enter the number of hours and the hourly rate." delegate:self cancelButtonTitle:@"Okay!" otherButtonTitles:nil];
				[alertView show];
				return nil;
			}
			else {
				CGFloat value = [[self.hourForm textFieldAtIndex:0].text floatValue] * [[self.hourRateForm textFieldAtIndex:0].text floatValue];
				[dealProposal setValue:[NSNumber numberWithFloat:value] forKey:@"dealValue"];
				[dealProposal setValue:[NSNumber numberWithFloat:[[self.hourForm textFieldAtIndex:0].text floatValue]] forKey:@"hours"];
			}
		}
		
		else if (self.dealTypeSelector.selectedSegmentIndex == 1) {
			if (![self.jobRateForm.userInputs valueForKey:@"jobRate"]) {
				UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Incomplete Deal Proposal" message:@"Please enter a price for the deal." delegate:self cancelButtonTitle:@"Okay!" otherButtonTitles:nil];
				[alertView show];
				return nil;
			}
			else {
				CGFloat value = [[self.jobRateForm textFieldAtIndex:0].text floatValue];
				[dealProposal setValue:[NSNumber numberWithFloat:value] forKey:@"dealValue"];
			}
		}
		
		if (self.entry) {
			[dealProposal setObject:self.entry forKey:@"entry"];
		}
		
		[dealProposal setObject:self.recipient forKey:@"toUser"];
		[dealProposal setObject:[PFUser currentUser] forKey:@"fromUser"];
		
		
		[message setObject:dealProposal forKey:@"proposedDeal"];
	}
	
	return message;
	
}

- (void)resignAllForms {
	
	if (self.messageForm.isActive) {
		[self.messageForm resign:nil completion:nil];
	}
	else if (self.hourForm.isActive) {
		[self.hourForm resign:nil completion:nil];
	}
	else if (self.hourRateForm.isActive) {
		[self.hourRateForm resign:nil completion:nil];
	}
	else if (self.jobRateForm.isActive) {
		[self.jobRateForm resign:nil completion:nil];
	}
}

- (void)scrollViewTapped:(id)sender {
	
	[self resignAllForms];
	
}

@end
