//
//  SZRootViewController.m
//  Skillz
//
//  Created by Julia Roggatz on 21.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZNavigationController.h"
#import "SZCreateAccountVC.h"

@interface SZNavigationController ()

@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeRecognizer;

@end

@implementation SZNavigationController

@synthesize leftSwipeRecognizer = _leftSwipeRecognizer;
@synthesize rightSwipeRecognizer = _rightSwipeRecognizer;

- (id)init
{
    self = [super initWithRootViewController:[[SZCreateAccountVC alloc] init]];
    if (self) {
		[self.view addGestureRecognizer: self.leftSwipeRecognizer];
		[self.view addGestureRecognizer: self.rightSwipeRecognizer];
    }
    return self;
}

- (void)showMenu:(id)sender {
	NSLog(@"show menu");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.navigationBar setTintColor:[SZGlobalConstants darkGray]];
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
//	CGRect frame = self.view.bounds;
//	
//	frame.origin.x  = 0.0;
//	
//	[UIView animateWithDuration:0.3f animations: ^{
//		self.mainView.frame = frame;
//	} completion:^(BOOL finished) {
//		self.leftMenuViewController.view.userInteractionEnabled = YES;
//	}];
}

- (void)slideOutMainViewAnimated:(BOOL)animated {

	NSLog(@"slide out");
	//	CGRect frame = self.view.bounds;
//	
//	frame.origin.x  = frame.size.width - kMenuButtonWidth - kPaddingWidth;
//	
//	[UIView animateWithDuration:0.3f animations: ^{
//		self.mainView.frame = frame;
//	}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
