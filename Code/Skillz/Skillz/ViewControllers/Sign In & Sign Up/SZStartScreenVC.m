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

@interface SZStartScreenVC ()

@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) MBProgressHUD* hud;

@end

@implementation SZStartScreenVC

@synthesize scrollView = _scrollView;
@synthesize hud = _hud;

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.navigationItem setTitle:@"Welcome!"];
	
	[self.view addSubview:self.scrollView];
	[self.scrollView addSubview:[self logo]];
	[self.hud show:YES];
	[[SZDataManager sharedInstance] updateMessageCacheWithCompletionBlock:^(BOOL finished) {
		NSLog(@"message check completed");
		[self.hud hide:YES];
		// TODO somehow indicate if there are new messages
	}];
	[[SZDataManager sharedInstance] updateOpenDealsCacheWithCompletionBlock:^(BOOL finished) {
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
	[logo setCenter:CGPointMake(160.0, 80.0)];
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


@end
