//
//  SZRootViewController.m
//  Skillz
//
//  Created by Julia Roggatz on 21.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SZNavigationController.h"
#import "SZSignInVC.h"
#import "SZCreateAccountVC.h"
#import "SZMenuVC.h"

@interface SZNavigationController ()

//@property (nonatomic, strong) SZMenuVC* menu;
@property (nonatomic, strong) UINavigationController* mainViewController;
@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeRecognizer;
@property (nonatomic, assign) BOOL isMenuVisible;
@property (nonatomic, assign) BOOL isSortOrFilterMenuVisible;

@end

@implementation SZNavigationController

//@synthesize menu = _menu;
@synthesize mainViewController = _mainViewController;
@synthesize leftSwipeRecognizer = _leftSwipeRecognizer;
@synthesize rightSwipeRecognizer = _rightSwipeRecognizer;
@synthesize isMenuVisible = _isMenuVisible;

- (id)initWithRootViewController:(UIViewController *)rootViewController {
	
	self = [super init];
    if (self) {
		
		self.mainViewController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
		self.mainViewController.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.mainViewController.view.bounds].CGPath;
		self.mainViewController.view.layer.shadowRadius = 5.0;
		self.mainViewController.view.layer.shadowOffset = CGSizeMake(0.0, 0.0);
		self.mainViewController.view.layer.shadowOpacity = 1.0;
		self.mainViewController.view.layer.shadowColor = [UIColor blackColor].CGColor;

		[[SZMenuVC sharedInstance] setDelegate:self];

		[self addChildViewController:self.mainViewController];
		[self.view addSubview:self.mainViewController.view];
		
		[self.view addGestureRecognizer: self.leftSwipeRecognizer];
		[self.view addGestureRecognizer: self.rightSwipeRecognizer];

    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.mainViewController.navigationBar setTintColor:[SZGlobalConstants veryDarkPetrol]];
}

- (void)viewDidAppear:(BOOL)animated {
	
	[self addChildViewController:[SZMenuVC sharedInstance]];
	[self.view insertSubview:[SZMenuVC sharedInstance].view atIndex:0];
}

- (void)toggleMenu:(id)sender {
	
	if (self.isMenuVisible) {
		[self slideInMainViewAnimated:YES navigationType:SZNavigationMenu];
	}
	else {
		[self slideOutMainViewAnimated:YES navigationType:SZNavigationMenu];
	}
}

- (void)toggleSortOrFilterMenu {
	
	if (self.isSortOrFilterMenuVisible) {
		[self slideInMainViewAnimated:YES navigationType:SZNavigationSortOrFiler];
	}
	else {
		[self slideOutMainViewAnimated:YES navigationType:SZNavigationSortOrFiler];
	}
}

- (UISwipeGestureRecognizer *)leftSwipeRecognizer {
	
	if (_leftSwipeRecognizer == nil) {
		_leftSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
		_leftSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
	}
	
	return _leftSwipeRecognizer;
}

- (UISwipeGestureRecognizer *)rightSwipeRecognizer {
	
	if (_rightSwipeRecognizer == nil) {
		_rightSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
		_rightSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
	}
	
	return _rightSwipeRecognizer;
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer {
	
	if (recognizer == self.leftSwipeRecognizer) {
		if (!self.isSortOrFilterMenuVisible) {
			[self slideInMainViewAnimated:YES navigationType:SZNavigationMenu];
		}
	} else if (recognizer == self.rightSwipeRecognizer) {
		if (self.isSortOrFilterMenuVisible) {
			[self slideInMainViewAnimated:YES navigationType:SZNavigationSortOrFiler];
		}
		else {
			[self slideOutMainViewAnimated:YES navigationType:SZNavigationMenu];
		}
	}
}
 
- (void)slideInMainViewAnimated:(BOOL)animated navigationType:(SZNavigationType)navigationType {
	
	CGRect frame = self.view.bounds;
	frame.origin.x  = 0.0;

	[UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		self.mainViewController.view.frame = frame;
	} completion:^(BOOL finished) {
		
		switch (navigationType) {
			case SZNavigationMenu:
				self.isMenuVisible = NO;
				break;
			case SZNavigationSortOrFiler:
				self.isSortOrFilterMenuVisible = NO;
				[[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_FILTER_OR_SORT_MENU_HIDDEN object:nil];
				[[SZMenuVC sharedInstance] hideHiddenMenu];
				break;
		}
		
	}];
	
	self.mainViewController.visibleViewController.view.userInteractionEnabled = YES;
}

- (void)slideOutMainViewAnimated:(BOOL)animated navigationType:(SZNavigationType)navigationType {
	
	CGRect frame = self.view.bounds;
	switch (navigationType) {
		case SZNavigationMenu:
			frame.origin.x  = frame.size.width - 100;
			self.isMenuVisible = YES;
			break;
		case SZNavigationSortOrFiler:
			self.isSortOrFilterMenuVisible = YES;
			[[SZMenuVC sharedInstance] showHiddenMenu];
			frame.origin.x  = -frame.size.width + 90;
			break;
	}
	
	[UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		self.mainViewController.view.frame = frame;
	} completion:^(BOOL finished) {
		
	}];
	 
	
	self.mainViewController.visibleViewController.view.userInteractionEnabled = NO;
}

- (void)dismiss:(id)sender {
	
	[self.mainViewController dismissViewControllerAnimated:YES completion:nil];
	[[SZMenuVC sharedInstance] setDelegate:self];
}

- (void)menu:(SZMenuVC *)menu switchToViewControllerWithClassName:(NSString *)className {
	
	UIViewController* vc = [[NSClassFromString(className) alloc] init];
	
	if (self.mainViewController.presentedViewController) {
		SZNavigationController* modalController = (SZNavigationController*)self.mainViewController.presentedViewController;
		[modalController.mainViewController setViewControllers:[NSArray arrayWithObject:vc]];
		[modalController slideInMainViewAnimated:YES navigationType:SZNavigationMenu];
	}
	else {
		[self.mainViewController setViewControllers:[NSArray arrayWithObject:vc]];
		[self slideInMainViewAnimated:YES navigationType:SZNavigationMenu];
	}
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
	[[SZMenuVC sharedInstance] setDelegate:self];
}

@end
