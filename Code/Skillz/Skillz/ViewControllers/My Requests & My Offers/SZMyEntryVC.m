//
//  SZMyRequestVC.m
//  Skillz
//
//  Created by Julia Roggatz on 02.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZMyEntryVC.h"
#import "SZEntryView.h"
#import "SZButton.h"
#import "MBProgressHUD.h"
#import "SZDataManager.h"
#import "SZNavigationController.h"
#import "SZNewEntryStep1VC.h"

@interface SZMyEntryVC ()

@property (nonatomic, strong) SZEntryObject* entry;
@property (nonatomic, strong) UIScrollView* mainView;
@property (nonatomic, strong) UIView* topView;
@property (nonatomic, strong) SZEntryView* entryView;
@property (nonatomic, assign) CGFloat contentHeight;

@end

@implementation SZMyEntryVC

@synthesize entry = _entry;
@synthesize topView = _topView;
@synthesize entryView = _entryView;
@synthesize mainView = _mainView;
@synthesize contentHeight = _contentHeight;

- (id)initWithEntry:(SZEntryObject*)entry {
	self = [super init];
	if (self) {
		self.entry = entry;
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	switch (self.entry.type) {
		case SZEntryTypeRequest:
			[self.navigationItem setTitle:@"My Requests"];
			break;
		case SZEntryTypeOffer:
			[self.navigationItem setTitle:@"My Offers"];
	}
	
	[self.mainView addSubview:self.topView];
	[self.mainView addSubview:self.entryView];
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
		_topView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 105.0)];
		
		SZButton* editButton = [SZButton buttonWithColor:SZButtonColorPetrol size:SZButtonSizeLarge width:290.0];
		[editButton addTarget:self action:@selector(editEntry:) forControlEvents:UIControlEventTouchUpInside];
		[editButton setCenter:CGPointMake(160.0, 35.0)];
		
		SZButton* deleteButton = [SZButton buttonWithColor:SZButtonColorOrange size:SZButtonSizeLarge width:290.0];
		[deleteButton addTarget:self action:@selector(deleteEntry:) forControlEvents:UIControlEventTouchUpInside];
		[deleteButton setCenter:CGPointMake(160.0, 85.0)];
		
		switch (self.entry.type) {
			case SZEntryTypeRequest:
				[editButton setTitle:@"Edit Request" forState:UIControlStateNormal];
				[deleteButton setTitle:@"Delete Request" forState:UIControlStateNormal];
				break;
			case SZEntryTypeOffer:
				[editButton setTitle:@"Edit Offer" forState:UIControlStateNormal];
				[deleteButton setTitle:@"Delete Offer" forState:UIControlStateNormal];
				break;
		}
		
		[_topView addSubview:editButton];
		[_topView addSubview:deleteButton];
		
		self.contentHeight += _topView.frame.size.height;
	}
	return _topView;
}

- (SZEntryView*)entryView {
	if (_entryView == nil) {
		_entryView = [[SZEntryView alloc] initWithEntry:self.entry];
		[_entryView setFrame:CGRectMake(15.0, self.contentHeight + 15.0, _entryView.frame.size.width, _entryView.frame.size.height + 30.0)];
		
		self.contentHeight += _entryView.frame.size.height;
		
	}
	return _entryView;
}

- (void)editEntry:(id)sender {
	[SZDataManager sharedInstance].currentEntryType = self.entry.type;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateEntry:) name:NOTIF_ENTRY_UPDATED object:nil];
	SZNavigationController* navController = [[SZNavigationController alloc] initWithRootViewController:[[SZNewEntryStep1VC alloc] initWithEntry:self.entry]];
	[navController setModalPresentationStyle:UIModalPresentationFullScreen];
	[self presentViewController:navController animated:YES completion:nil];
}

- (void)deleteEntry:(id)sender {
	
	NSString* title;
	switch (self.entry.type) {
		case SZEntryTypeRequest:
			title = @"Do you really want to delete this request?";
			break;
		case SZEntryTypeOffer:
			title = @"Do you really want to delete this offer?";
			break;
	}
	
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:@"This cannot be undone." delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
	[alertView setDelegate:self];
	[alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		
		PFObject* serverObject = [PFQuery getObjectOfClass:@"Entry" objectId:self.entry.objectId];
		[serverObject deleteInBackground];
		[SZDataManager removeEntryFromCache:self.entry];
		[self.navigationController popViewControllerAnimated:YES];
	}
}

- (void)updateEntry:(NSNotification*)notif {
	SZEntryObject* entry = [notif.userInfo valueForKey:@"entry"];
	self.entry = entry;
	self.contentHeight = 0.0;
	for (UIView* view in [self.view subviews]) {
		[view removeFromSuperview];
	}
	self.mainView = nil;
	self.topView = nil;
	self.entryView = nil;
	[self viewDidLoad];
}

@end