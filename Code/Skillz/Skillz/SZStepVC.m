//
//  SZStepVC.m
//  Skillz
//
//  Created by Julia Roggatz on 25.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZStepVC.h"
#import "SZUtils.h"
#import "SZButton.h"
#import "UILabel+Shadow.h"


#define BUTTON_AREA_HEIGHT 70.0


@interface SZStepVC ()

@property (nonatomic, assign) NSInteger stepNumber;
@property (nonatomic, assign) NSInteger totalSteps;

@end

@implementation SZStepVC

@synthesize stepNumber = _stepNumber;
@synthesize totalSteps = _totalSteps;
@synthesize mainView = _mainView;
@synthesize detailViewContainer = _detailViewContainer;
@synthesize continueButton = _continueButton;

- (id)initWithStepNumber:(NSInteger)stepNumber totalSteps:(NSInteger)totalSteps {
	self = [super init];
	if (self) {
		self.stepNumber = stepNumber;
		self.totalSteps = totalSteps;
	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self.navigationController.parentViewController action:@selector(cancel:)];
	[self.navigationItem setRightBarButtonItem:cancelButton];
	[self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil]];
	[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_pattern"]]];
	
	[self.view addSubview:self.mainView];
	[self.mainView addSubview:[self stepLabel]];
	[self.mainView addSubview:self.continueButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIScrollView*)mainView {
	if (_mainView == nil) {
		_mainView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 420.0)];
		[_mainView setContentSize:_mainView.frame.size];
	}
	return _mainView;
}

- (UIView*)detailViewContainer {
	if (_detailViewContainer == nil) {
		_detailViewContainer = [[UIView alloc] initWithFrame:CGRectMake(15.0, 230.0, 0.0, 0.0)];
	}
	return _detailViewContainer;
}

- (UILabel*)stepLabel {
	UILabel* stepLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 20.0, 320.0, 30.0)];
	[stepLabel setFont:[SZGlobalConstants fontWithFontType:SZFontBold size:20.0]];
	[stepLabel setTextAlignment:NSTextAlignmentCenter];
	[stepLabel setTextColor:[SZGlobalConstants darkPetrol]];
	[stepLabel applyWhiteShadow];
	[stepLabel setText:[NSString stringWithFormat:@"Step %i of %i", self.stepNumber, self.totalSteps]];
	return stepLabel;
}

- (SZButton*)continueButton {
	if (_continueButton == nil) {
		_continueButton = [[SZButton alloc] initWithColor:SZButtonColorPetrol size:SZButtonSizeLarge width:290.0];
		[_continueButton setTitle:@"Continue" forState:UIControlStateNormal];
		[_continueButton addTarget:self action:@selector(continue:) forControlEvents:UIControlEventTouchUpInside];
		[_continueButton setCenter:CGPointMake(160.0, 380.0)];
	}
	return _continueButton;
}

- (void)updateBounds {
	
	if ([[self.detailViewContainer subviews] count] > 0) {
		
		UIView* currentDetailView = [[self.detailViewContainer subviews] objectAtIndex:0];
		CGPoint detailOrigin = [currentDetailView convertPoint:currentDetailView.frame.origin toView:self.mainView];
		CGFloat totalHeight = detailOrigin.y + currentDetailView.frame.size.height + BUTTON_AREA_HEIGHT;
		CGFloat newHeight = MAX(420.0, totalHeight);
		
		[UIView animateWithDuration:0.3 animations:^{
			[self setScrollViewHeight:newHeight];
		} completion:^(BOOL finished) {
			[self slideInDetailView];
		}];
	}
	else {
		[UIView animateWithDuration:0.3 animations:^{
			[self setScrollViewHeight:420.0];
		}];
	}
}

- (void)setScrollViewHeight:(CGFloat)newHeight {
	[self.mainView setContentSize:CGSizeMake(self.mainView.contentSize.width, newHeight)];
	[self.mainView setContentOffset:CGPointMake(0, self.mainView.contentSize.height - self.mainView.bounds.size.height)];
	CGRect buttonFrame = self.continueButton.frame;
	buttonFrame.origin.y = self.mainView.contentSize.height - buttonFrame.size.height - 20.0;
	self.continueButton.frame = buttonFrame;
}

- (void)slideInDetailView {
	if ([[self.detailViewContainer subviews] count] > 0) {
		UIView* currentDetailView = [[self.detailViewContainer subviews] objectAtIndex:0];
		self.detailViewContainer.hidden = NO;
		CGRect frame = self.detailViewContainer.frame;
		frame.size.width = currentDetailView.frame.size.width;
		frame.size.height = currentDetailView.frame.size.height;
		self.detailViewContainer.frame = frame;
		[UIView animateWithDuration:0.2 animations:^{
			[self.detailViewContainer setFrame:CGRectMake(15.0,
														  self.detailViewContainer.frame.origin.y,
														  self.detailViewContainer.frame.size.width,
														  self.detailViewContainer.frame.size.height)];
		}];
	}
}

- (void)newDetailViewAdded {
	[self.detailViewContainer setHidden:YES];
	[self.detailViewContainer setFrame:CGRectMake(330.0,
												  self.detailViewContainer.frame.origin.y,
												  self.detailViewContainer.frame.size.width,
												  self.detailViewContainer.frame.size.height)];
	[self updateBounds];
}

@end
