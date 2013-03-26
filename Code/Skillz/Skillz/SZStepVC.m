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

@interface SZStepVC ()

@property (nonatomic, assign) NSInteger stepNumber;
@property (nonatomic, assign) NSInteger totalSteps;

@end

@implementation SZStepVC

@synthesize stepNumber = _stepNumber;
@synthesize totalSteps = _totalSteps;
@synthesize mainView = _mainView;
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

@end
