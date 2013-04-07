//
//  SZEntryDetailVC.m
//  Skillz
//
//  Created by Julia Roggatz on 07.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZEntryDetailVC.h"
#import "SZEntryView.h"
#import "SZDataManager.h"
#import "SZButton.h"

@interface SZEntryDetailVC ()

@property (nonatomic, strong) SZEntryVO* entry;
@property (nonatomic, assign) SZEntryType entryType;
@property (nonatomic, strong) UIScrollView* mainView;
@property (nonatomic, strong) SZEntryView* entryView;
@property (nonatomic, strong) UIView* bottomView;
@property (nonatomic, assign) CGFloat contentHeight;

@end

@implementation SZEntryDetailVC

@synthesize entry = _entry;
@synthesize entryType = _entryType;
@synthesize entryView = _entryView;
@synthesize bottomView = _bottomView;
@synthesize mainView = _mainView;
@synthesize contentHeight = _contentHeight;

- (id)initWithEntry:(SZEntryVO*)entry type:(SZEntryType)type {
	self = [super init];
	if (self) {
		self.entry = entry;
		self.entryType = type;
	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	switch ([SZDataManager sharedInstance].currentEntryType) {
		case SZEntryTypeRequest:
			[self.navigationItem setTitle:@"Request Details"];
			break;
		case SZEntryTypeOffer:
			[self.navigationItem setTitle:@"Offer Details"];
			break;
	}
	
	[self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil]];
	[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_pattern"]]];
	
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


- (SZEntryView*)entryView {
	if (_entryView == nil) {
		_entryView = [[SZEntryView alloc] initWithEntry:self.entry];
		[_entryView setFrame:CGRectMake(15.0, self.contentHeight + 15.0, _entryView.frame.size.width, _entryView.frame.size.height + 30.0)];
		
		self.contentHeight += _entryView.frame.size.height;
		
	}
	return _entryView;
}

- (UIView*)bottomView {
	if (_bottomView == nil) {
		
		_bottomView = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.contentHeight, 320.0, 60.0)];
		
		SZButton* contactButton = [[SZButton alloc] initWithColor:SZButtonColorOrange size:SZButtonSizeLarge width:290.0];
		[contactButton setTag:0];
		[contactButton setTitle:[NSString stringWithFormat:@"Contact %@", [self.entry.user valueForKey:@"firstName"]] forState:UIControlStateNormal];
		[contactButton addTarget:self action:@selector(contact:) forControlEvents:UIControlEventTouchUpInside];
		[contactButton setCenter:CGPointMake(160.0, 20.0)];
		
		[_bottomView addSubview:contactButton];
		
		self.contentHeight += _bottomView.frame.size.height;
	}
	return _bottomView;
}

- (void)contact:(SZButton*)sender {
	
	NSLog(@"contact");
	// TODO next big milestone.. contacting people
}

@end