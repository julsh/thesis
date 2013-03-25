//
//  SZRootViewController.m
//  Skillz
//
//  Created by Julia Roggatz on 21.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZNavigationController.h"
#import "SZSignInVC.h"
#import "SZCreateAccountVC.h"
#import "SZMenuVC.h"

@interface SZNavigationController ()

@property (nonatomic, strong) SZMenuVC* menu;
@property (nonatomic, strong) UINavigationController* mainViewController;
@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeRecognizer;
@property (nonatomic, assign) BOOL isMenuVisible;

@end

@implementation SZNavigationController

@synthesize menu = _menu;
@synthesize mainViewController = _mainViewController;
@synthesize leftSwipeRecognizer = _leftSwipeRecognizer;
@synthesize rightSwipeRecognizer = _rightSwipeRecognizer;
@synthesize isMenuVisible = _isMenuVisible;

- (id)initWithRootViewController:(UIViewController *)rootViewController {
	self = [super init];
    if (self) {
		self.mainViewController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
		
		self.menu = [SZMenuVC sharedInstance];
		[self.menu setDelegate:self];

		[self addChildViewController:self.mainViewController];
		[self.view addSubview:self.mainViewController.view];
		
		[self.view addGestureRecognizer: self.leftSwipeRecognizer];
		[self.view addGestureRecognizer: self.rightSwipeRecognizer];

    }
    return self;
}

- (void)showMenu:(id)sender {
	NSLog(@"show menu");
	if (self.isMenuVisible) {
		[self slideInMainViewAnimated:YES];
	}
	else {
		[self slideOutMainViewAnimated:YES];
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.mainViewController.navigationBar setTintColor:[SZGlobalConstants darkGray]];
}

- (void)viewDidAppear:(BOOL)animated {
	[self addChildViewController:self.menu];
	[self.view insertSubview:self.menu.view atIndex:0];
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
		[self slideInMainViewAnimated:YES];
	} else if (recognizer == self.rightSwipeRecognizer) {
		[self slideOutMainViewAnimated:YES];
	}
}

- (void)slideInMainViewAnimated:(BOOL)animated {
	
	NSLog(@"slide in");
	CGRect frame = self.view.bounds;
	
	frame.origin.x  = 0.0;
	
	[UIView animateWithDuration:0.3f animations: ^{
		self.mainViewController.view.frame = frame;
	} completion:^(BOOL finished) {
//		self.leftMenuViewController.view.userInteractionEnabled = YES;
	}];
	self.isMenuVisible = NO;
	self.mainViewController.view.userInteractionEnabled = YES;
}

- (void)slideOutMainViewAnimated:(BOOL)animated {

	
	CGRect frame = self.view.bounds;
	frame.origin.x  = frame.size.width - 100;
	[UIView animateWithDuration:0.3f animations: ^{
		self.mainViewController.view.frame = frame;
	}];
	self.isMenuVisible = YES;
	self.mainViewController.view.userInteractionEnabled = NO;
}

- (void)dismiss:(id)sender {
	NSLog(@"dismiss");
	[self.mainViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)menu:(SZMenuVC *)menu switchToViewControllerWithClassName:(NSString *)className {
	NSLog(@"switch");
	UIViewController* vc = [[NSClassFromString(className) alloc] init];
	[self.mainViewController setViewControllers:[NSArray arrayWithObject:vc]];
	[self slideInMainViewAnimated:YES];
}

@end
