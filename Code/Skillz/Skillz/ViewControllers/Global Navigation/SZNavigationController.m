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
@property (nonatomic, assign) BOOL isModal;

@end

@implementation SZNavigationController

//@synthesize menu = _menu;
@synthesize mainViewController = _mainViewController;
@synthesize leftSwipeRecognizer = _leftSwipeRecognizer;
@synthesize rightSwipeRecognizer = _rightSwipeRecognizer;
@synthesize isMenuVisible = _isMenuVisible;

- (id)initWithRootViewController:(UIViewController *)rootViewController isModal:(BOOL)isModal {
	
	self = [super init];
    if (self) {
		self.isModal = isModal;
		
		self.mainViewController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
		self.mainViewController.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.mainViewController.view.bounds].CGPath;
		self.mainViewController.view.layer.shadowRadius = 5.0;
		self.mainViewController.view.layer.shadowOffset = CGSizeMake(0.0, 0.0);
		self.mainViewController.view.layer.shadowOpacity = 1.0;
		self.mainViewController.view.layer.shadowColor = [UIColor blackColor].CGColor;
		
//		self.menu = [SZMenuVC sharedInstance];
		
//		if (!isModal) {
			[[SZMenuVC sharedInstance] setDelegate:self];
//		}

		[self addChildViewController:self.mainViewController];
		[self.view addSubview:self.mainViewController.view];
		
		[self.view addGestureRecognizer: self.leftSwipeRecognizer];
		[self.view addGestureRecognizer: self.rightSwipeRecognizer];

    }
    return self;
}

- (void)showMenu:(id)sender {
	
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
	[self.mainViewController.navigationBar setTintColor:[SZGlobalConstants veryDarkPetrol]];
}

- (void)viewDidAppear:(BOOL)animated {
	
	[self addChildViewController:[SZMenuVC sharedInstance]];
	[self.view insertSubview:[SZMenuVC sharedInstance].view atIndex:0];
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
	
	CGRect frame = self.view.bounds;
	frame.origin.x  = 0.0;

	[UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		self.mainViewController.view.frame = frame;
	} completion:nil];
	
	self.isMenuVisible = NO;
	self.mainViewController.visibleViewController.view.userInteractionEnabled = YES;
}

- (void)slideOutMainViewAnimated:(BOOL)animated {
	
	CGRect frame = self.view.bounds;
	frame.origin.x  = frame.size.width - 100;
	
	[UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		self.mainViewController.view.frame = frame;
	} completion:nil];
	
	self.isMenuVisible = YES;
	self.mainViewController.visibleViewController.view.userInteractionEnabled = NO;
}

- (void)dismiss:(id)sender {
	
	NSLog(@"dismissing");
	[self.mainViewController dismissViewControllerAnimated:YES completion:nil];
	[[SZMenuVC sharedInstance] setDelegate:self];
}

- (void)menu:(SZMenuVC *)menu switchToViewControllerWithClassName:(NSString *)className {
	
	NSLog(@"presenting: %@", self.mainViewController.presentingViewController);
	NSLog(@"presented: %@", self.mainViewController.presentedViewController);
	
	UIViewController* vc = [[NSClassFromString(className) alloc] init];
	
	if (self.mainViewController.presentedViewController) {
		
		SZNavigationController* modalController = (SZNavigationController*)self.mainViewController.presentedViewController;
		[modalController.mainViewController setViewControllers:[NSArray arrayWithObject:vc]];
		[modalController slideInMainViewAnimated:YES];
	}
	else {
		[self.mainViewController setViewControllers:[NSArray arrayWithObject:vc]];
		[self slideInMainViewAnimated:YES];
	}
	
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
	NSLog(@"dismiss");
	[[SZMenuVC sharedInstance] setDelegate:self];
}

@end
