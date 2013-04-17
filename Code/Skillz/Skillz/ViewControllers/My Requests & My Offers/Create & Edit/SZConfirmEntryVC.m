//
//  SZConfirmEntryVC.m
//  Skillz
//
//  Created by Julia Roggatz on 31.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "SZConfirmEntryVC.h"
#import "SZEntryView.h"
#import "SZDataManager.h"
#import "SZButton.h"
#import "UITextView+Shadow.h"
#import "MBProgressHUD.h"

@interface SZConfirmEntryVC ()

@property (nonatomic, strong) UIScrollView* mainView;
@property (nonatomic, strong) UIView* topView;
@property (nonatomic, strong) SZEntryView* entryView;
@property (nonatomic, strong) UIView* bottomView;
@property (nonatomic, assign) CGFloat contentHeight;

@end

@implementation SZConfirmEntryVC

@synthesize topView = _topView;
@synthesize entryView = _entryView;
@synthesize bottomView = _bottomView;
@synthesize mainView = _mainView;
@synthesize contentHeight = _contentHeight;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	switch ([SZDataManager sharedInstance].currentEntryType) {
		case SZEntryTypeRequest:
			[self.navigationItem setTitle:@"Review Request"];
			break;
		case SZEntryTypeOffer:
			[self.navigationItem setTitle:@"Review Offer"];
			break;
	}
	
	UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
	[self.navigationItem setRightBarButtonItem:cancelButton];
	[self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil]];
	[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_pattern"]]];
	
	[self.mainView addSubview:self.topView];
	[self.mainView addSubview:self.entryView];
	[self.mainView addSubview:self.bottomView];
	[self.view addSubview:self.mainView];
	
	[self.mainView setContentSize:CGSizeMake(320.0, self.contentHeight)];
}

- (UIScrollView*)mainView {
	if (_mainView == nil) {
		_mainView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 420.0)];
		[_mainView setContentSize:_mainView.frame.size];
	}
	return _mainView;
}

- (UIView*)topView {
	if (_topView == nil) {
		_topView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 170.0)];
		[_topView setBackgroundColor:[SZGlobalConstants orange]];
		
		UITextView* textView = [[UITextView alloc] initWithFrame:CGRectMake(10.0, 6.0, 290.0, 155.0)];
		[textView setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:14.0]];
		[textView setTextColor:[UIColor whiteColor]];
		[textView applyBlackShadow];
		[textView setUserInteractionEnabled:NO];
		[textView setScrollEnabled:NO];
		[textView setTextAlignment:NSTextAlignmentJustified];
		
		NSString* type;
		switch ([SZDataManager sharedInstance].currentEntryType) {
			case SZEntryTypeRequest:
				type = @"request";
				break;
			case SZEntryTypeOffer:
				type = @"offer";
				break;
		}
		[textView setText:[NSString stringWithFormat:@"This is how your %@ will be displayed to other users. Please make sure that everything is correct. If you want to make changes, simply go back and edit your %@. If you're happy with everything, you can post the %@ or save it and activate it later.", type, type, type]];
		[_topView addSubview:textView];
		
		self.contentHeight += _topView.frame.size.height;
	}
	return _topView;
}

- (SZEntryView*)entryView {
	if (_entryView == nil) {
		_entryView = [[SZEntryView alloc] initWithEntry:(SZEntryObject*)[SZDataManager sharedInstance].currentEntry];
		[_entryView setFrame:CGRectMake(15.0, self.contentHeight + 15.0, _entryView.frame.size.width, _entryView.frame.size.height + 30.0)];
		
		self.contentHeight += _entryView.frame.size.height;
		
	}
	return _entryView;
}

- (UIView*)bottomView {
	if (_bottomView == nil) {
		
		if ([SZDataManager sharedInstance].currentEntryIsNew) {
			_bottomView = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.contentHeight, 320.0, 105.0)];
			
			SZButton* postButton = [[SZButton alloc] initWithColor:SZButtonColorOrange size:SZButtonSizeLarge width:290.0];
			[postButton setTag:0];
			[postButton setTitle:[NSString stringWithFormat:@"Post %@", [SZDataManager sharedInstance].currentEntryType == SZEntryTypeRequest ? @"Request" : @"Offer"] forState:UIControlStateNormal];
			[postButton addTarget:self action:@selector(postEntry:) forControlEvents:UIControlEventTouchUpInside];
			[postButton setCenter:CGPointMake(160.0, 20.0)];
			
			SZButton* saveButton = [[SZButton alloc] initWithColor:SZButtonColorPetrol size:SZButtonSizeLarge width:290.0];
			[saveButton setTag:1];
			[saveButton setTitle:@"Save & Activate Later" forState:UIControlStateNormal];
			[saveButton addTarget:self action:@selector(postEntry:) forControlEvents:UIControlEventTouchUpInside];
			[saveButton setCenter:CGPointMake(160.0, 70.0)];
			
			[_bottomView addSubview:postButton];
			[_bottomView addSubview:saveButton];
		}
		else {
			_bottomView = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.contentHeight, 320.0, 55.0)];
			
			SZButton* saveButton = [[SZButton alloc] initWithColor:SZButtonColorOrange size:SZButtonSizeLarge width:290.0];
			[saveButton setTag:0];
			[saveButton setTitle:@"Save Changes" forState:UIControlStateNormal];
			[saveButton addTarget:self action:@selector(saveChanges:) forControlEvents:UIControlEventTouchUpInside];
			[saveButton setCenter:CGPointMake(160.0, 20.0)];
			
			[_bottomView addSubview:saveButton];
		}
		
		self.contentHeight += _bottomView.frame.size.height;
	}
	return _bottomView;
}

- (void)cancel:(id)sender {
	
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Do you really want to cancel?" message:@"All progress will be lost." delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
	[alertView setDelegate:self];
	[alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		
		[SZDataManager sharedInstance].currentEntry = nil;
		[SZDataManager sharedInstance].viewControllerStack = nil;
		[self.presentingViewController performSelector:@selector(dismiss:) withObject:self];
	}
}

- (void)postEntry:(SZButton*)sender {
	
	MBProgressHUD* hud = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:hud];
	[hud setDimBackground:YES];
	[hud setRemoveFromSuperViewOnHide:YES];
	[hud show:YES];
	
	SZEntryObject* entry = (SZEntryObject*)[SZDataManager sharedInstance].currentEntry;
	
	if (sender.tag == 0) {
		entry.isActive = YES;
	}
	else if (sender.tag == 1) {
		entry.isActive = NO;
	}
	
	// post to server
//	SZEntryVO* serverObject = [SZ]
//	PFObject* serverObject = [SZEntryVO serverObjectFromEntryVO:entry className:[SZDataManager sharedInstance].currentEntryType == SZEntryTypeRequest ? @"Request" : @"Offer"];
	[entry saveEventually:^(BOOL succeeded, NSError *error) {
		if (succeeded) {
			// cache the request to be used offline
			[[SZDataManager sharedInstance] updateEntryCacheWithEntry:entry type:[SZDataManager sharedInstance].currentEntryType];
			[SZDataManager sharedInstance].currentEntry = nil;
			[hud hide:YES];
			[self.presentingViewController performSelector:@selector(dismiss:) withObject:self];
		}
		else {
			if (error) {
				[hud hide:YES];
				NSLog(@"%@", error);
			}
		}
	}];
}

- (void)saveChanges:(SZButton*)sender {
	MBProgressHUD* hud = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:hud];
	[hud setDimBackground:YES];
	[hud setRemoveFromSuperViewOnHide:YES];
	[hud show:YES];
	
//	SZEntryVO* entry = (SZEntryVO*)[SZDataManager sharedInstance].currentEntry;
//	PFObject* serverObject = [PFQuery getObjectOfClass:[SZDataManager sharedInstance].currentEntryType == SZEntryTypeRequest ? @"Request" : @"Offer" objectId:entry.objectID];
//	serverObject = [SZEntryVO updatePFObject:serverObject withEntryVO:entry];
	
	[[SZDataManager sharedInstance].currentEntry saveEventually:^(BOOL succeeded, NSError *error) {
		if (succeeded) {
			
			[[SZDataManager sharedInstance] updateEntryCacheWithEntry:[SZDataManager sharedInstance].currentEntry type:[SZDataManager sharedInstance].currentEntryType];
			[hud hide:YES];
			[[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_ENTRY_UPDATED object:[SZDataManager sharedInstance].currentEntry userInfo:[NSDictionary dictionaryWithObject:[SZDataManager sharedInstance].currentEntry forKey:@"entry"]];
			[self.presentingViewController performSelector:@selector(dismiss:) withObject:self];
			[SZDataManager sharedInstance].currentEntry = nil;
			
		}
		else {
			if (error) {
				[hud hide:YES];
				NSLog(@"%@", error);
			}
		}
	}];
}

@end
