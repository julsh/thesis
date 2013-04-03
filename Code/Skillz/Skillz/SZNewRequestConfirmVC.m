//
//  SZNewRequestConfirmVC.m
//  Skillz
//
//  Created by Julia Roggatz on 31.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "SZNewRequestConfirmVC.h"
#import "SZRequestView.h"
#import "SZDataManager.h"
#import "SZButton.h"
#import "UITextView+Shadow.h"
#import "MBProgressHUD.h"

@interface SZNewRequestConfirmVC ()

@property (nonatomic, strong) UIView* topView;
@property (nonatomic, strong) SZRequestView* requestView;
@property (nonatomic, strong) UIView* bottomView;
@property (nonatomic, assign) CGFloat contentHeight;

@end

@implementation SZNewRequestConfirmVC

@synthesize topView = _topView;
@synthesize requestView = _requestView;
@synthesize bottomView = _bottomView;
@synthesize mainView = _mainView;
@synthesize contentHeight = _contentHeight;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self.navigationItem setTitle:@"Review Request"];
	
	UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self.navigationController.parentViewController action:@selector(cancel:)];
	[self.navigationItem setRightBarButtonItem:cancelButton];
	[self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil]];
	[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_pattern"]]];
	
	[self.mainView addSubview:self.topView];
	[self.mainView addSubview:self.requestView];
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
		[textView setText:@"This is how your request will be displayed to other users. Please make sure that everything is correct. If you want to make changes, simply go back and edit your request. If you're happy with everything, you can post the request or save it and activate it later."];
		[_topView addSubview:textView];
		
		self.contentHeight += _topView.frame.size.height;
	}
	return _topView;
}

- (SZRequestView*)requestView {
	if (_requestView == nil) {
		_requestView = [[SZRequestView alloc] initWithRequest:(SZEntryVO*)[SZDataManager sharedInstance].currentObject];
		[_requestView setFrame:CGRectMake(15.0, self.contentHeight + 15.0, _requestView.frame.size.width, _requestView.frame.size.height + 30.0)];
		
		self.contentHeight += _requestView.frame.size.height;
		
	}
	return _requestView;
}

- (UIView*)bottomView {
	if (_bottomView == nil) {
		
		if ([SZDataManager sharedInstance].currentObjectIsNew) {
			_bottomView = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.contentHeight, 320.0, 120.0)];
			
			SZButton* postButton = [[SZButton alloc] initWithColor:SZButtonColorOrange size:SZButtonSizeLarge width:290.0];
			[postButton setTag:0];
			[postButton setTitle:@"Post Request Now" forState:UIControlStateNormal];
			[postButton addTarget:self action:@selector(postRequest:) forControlEvents:UIControlEventTouchUpInside];
			[postButton setCenter:CGPointMake(160.0, 35.0)];
			
			SZButton* saveButton = [[SZButton alloc] initWithColor:SZButtonColorPetrol size:SZButtonSizeLarge width:290.0];
			[saveButton setTag:1];
			[saveButton setTitle:@"Save & Activate Later" forState:UIControlStateNormal];
			[saveButton addTarget:self action:@selector(postRequest:) forControlEvents:UIControlEventTouchUpInside];
			[saveButton setCenter:CGPointMake(160.0, 85.0)];
			
			[_bottomView addSubview:postButton];
			[_bottomView addSubview:saveButton];
		}
		else {
			_bottomView = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.contentHeight, 320.0, 70.0)];
			
			SZButton* saveButton = [[SZButton alloc] initWithColor:SZButtonColorOrange size:SZButtonSizeLarge width:290.0];
			[saveButton setTag:0];
			[saveButton setTitle:@"Save Changes" forState:UIControlStateNormal];
			[saveButton addTarget:self action:@selector(saveChanges:) forControlEvents:UIControlEventTouchUpInside];
			[saveButton setCenter:CGPointMake(160.0, 35.0)];
			
			[_bottomView addSubview:saveButton];
		}
		
		self.contentHeight += _bottomView.frame.size.height;
	}
	return _bottomView;
}

- (void)postRequest:(SZButton*)sender {
	
	MBProgressHUD* hud = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:hud];
	[hud setDimBackground:YES];
	[hud setRemoveFromSuperViewOnHide:YES];
	[hud show:YES];
	
	SZEntryVO* request = (SZEntryVO*)[SZDataManager sharedInstance].currentObject;
	
	if (sender.tag == 0) {
		request.isActive = YES;
	}
	else if (sender.tag == 1) {
		request.isActive = NO;
	}
	
	// post to server
	PFObject* serverObject = [SZEntryVO serverObjectFromEntryVO:request className:@"Request"];
	[serverObject saveEventually:^(BOOL succeeded, NSError *error) {
		if (succeeded) {
			// cache the request to be used offline
			request.objectID = serverObject.objectId;
			[[SZDataManager sharedInstance] addRequestToUserCache:request];
			[SZDataManager sharedInstance].currentObject = nil;
			[hud hide:YES];
			[self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
	
	SZEntryVO* request = (SZEntryVO*)[SZDataManager sharedInstance].currentObject;
	PFObject* serverObject = [PFQuery getObjectOfClass:@"Request" objectId:request.objectID];
	serverObject = [SZEntryVO updatePFObject:serverObject withEntryVO:request];
	
	[serverObject saveEventually:^(BOOL succeeded, NSError *error) {
		if (succeeded) {
			
			[[SZDataManager sharedInstance] updateRequestCacheWithRequest:request];
			[SZDataManager sharedInstance].currentObject = nil;
			[hud hide:YES];
			[self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
