//
//  SZMyRequestVC.m
//  Skillz
//
//  Created by Julia Roggatz on 02.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZMyRequestVC.h"
#import "SZRequestView.h"
#import "SZButton.h"
#import "MBProgressHUD.h"
#import "SZDataManager.h"
#import "SZNavigationController.h"
#import "SZNewRequestStep1VC.h"

@interface SZMyRequestVC ()

@property (nonatomic, strong) SZEntryVO* request;
@property (nonatomic, strong) UIScrollView* mainView;
@property (nonatomic, strong) UIView* topView;
@property (nonatomic, strong) SZRequestView* requestView;
@property (nonatomic, strong) UIView* bottomView;
@property (nonatomic, assign) CGFloat contentHeight;

@end

@implementation SZMyRequestVC

@synthesize request = _request;
@synthesize topView = _topView;
@synthesize requestView = _requestView;
@synthesize bottomView = _bottomView;
@synthesize mainView = _mainView;
@synthesize contentHeight = _contentHeight;

- (id)initWithRequest:(SZEntryVO*)request {
	self = [super init];
	if (self) {
		self.request = request;
	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self.navigationItem setTitle:@"My Requests"];
	[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_pattern"]]];
	
	[self.mainView addSubview:self.topView];
	[self.mainView addSubview:self.requestView];
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
		
		SZButton* editButton = [[SZButton alloc] initWithColor:SZButtonColorPetrol size:SZButtonSizeLarge width:290.0];
		[editButton setTitle:@"Edit Request" forState:UIControlStateNormal];
		[editButton addTarget:self action:@selector(editRequest:) forControlEvents:UIControlEventTouchUpInside];
		[editButton setCenter:CGPointMake(160.0, 35.0)];
		
		SZButton* deleteButton = [[SZButton alloc] initWithColor:SZButtonColorOrange size:SZButtonSizeLarge width:290.0];
		[deleteButton setTitle:@"Delete Request" forState:UIControlStateNormal];
		[deleteButton addTarget:self action:@selector(deleteRequest:) forControlEvents:UIControlEventTouchUpInside];
		[deleteButton setCenter:CGPointMake(160.0, 85.0)];
		
		[_topView addSubview:editButton];
		[_topView addSubview:deleteButton];
		
		self.contentHeight += _topView.frame.size.height;
	}
	return _topView;
}

- (SZRequestView*)requestView {
	if (_requestView == nil) {
		_requestView = [[SZRequestView alloc] initWithRequest:self.request];
		[_requestView setFrame:CGRectMake(15.0, self.contentHeight + 15.0, _requestView.frame.size.width, _requestView.frame.size.height + 30.0)];
		
		self.contentHeight += _requestView.frame.size.height;
		
	}
	return _requestView;
}

- (void)editRequest:(id)sender {
	SZNavigationController* navController = [[SZNavigationController alloc] initWithRootViewController:[[SZNewRequestStep1VC alloc] initWithRequest:self.request]];
	[navController setModalPresentationStyle:UIModalPresentationFullScreen];
	[self presentViewController:navController animated:YES completion:nil];
}

- (void)deleteRequest:(id)sender {
	
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Do you really want to delete this request?" message:@"This cannot be undone." delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
	[alertView setDelegate:self];
	[alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		
		PFObject* serverObject = [PFQuery getObjectOfClass:@"Request" objectId:self.request.objectID];
		[serverObject deleteInBackground];
		[[SZDataManager sharedInstance] removeRequestFromCache:self.request];
		[self.navigationController popViewControllerAnimated:YES];
	}
}

@end