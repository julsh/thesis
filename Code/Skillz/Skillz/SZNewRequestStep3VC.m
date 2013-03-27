//
//  SZNewRequestStep3VC.m
//  Skillz
//
//  Created by Julia Roggatz on 25.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZNewRequestStep3VC.h"
#import "SZNewRequestStep4VC.h"
#import "SZRadioButtonControl.h"
#import "SZUtils.h"
#import "SZForm.h"
#import "UITextView+Shadow.h"

@interface SZNewRequestStep3VC ()

@property (nonatomic, strong) SZSegmentedControlVertical* segmentedControl;
@property (nonatomic, strong) SZRadioButtonControl* option1detailView;
@property (nonatomic, strong) UIView* option2detailView;

@end

@implementation SZNewRequestStep3VC

@synthesize segmentedControl = _segmentedControl;
@synthesize option1detailView = _option1detailView;
@synthesize option2detailView = _option2detailView;

- (id)init
{
    return [super initWithStepNumber:3 totalSteps:5];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.navigationItem setTitle:@"Post a Request"];
	
	[self.mainView addSubview:[self specifyLocationLabel]];
	[self.mainView addSubview:self.segmentedControl];
	[self.mainView addSubview:self.detailViewContainer];
}

- (UILabel*)specifyLocationLabel {
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 60.0, 300.0, 30.0)];
	[label setBackgroundColor:[UIColor clearColor]];
	[label setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:16.0]];
	[label setTextColor:[SZGlobalConstants darkGray]];
	[label applyWhiteShadow];
	[label setText:@"Specify the location:"];
	return label;
}

- (SZSegmentedControlVertical*)segmentedControl {
	if (_segmentedControl == nil) {
		_segmentedControl = [[SZSegmentedControlVertical alloc] initWithWidth:290.0];
		[_segmentedControl addItemWithText:@"I'm willing to go somewhere else." isLast:NO];
		[_segmentedControl addItemWithText:@"People have to come to me." isLast:NO];
		[_segmentedControl addItemWithText:@"This can be done remotely." isLast:YES];
		[_segmentedControl setCenter:CGPointMake(160.0, 160.0)];
		[_segmentedControl setDelegate:self];
	}
	return _segmentedControl;
}

- (SZRadioButtonControl*)option1detailView {
	if (_option1detailView == nil) {
		
		_option1detailView = [[SZRadioButtonControl alloc] init];
		
		UILabel* inZipCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 240.0, 44.0)];
		[inZipCodeLabel setBackgroundColor:[UIColor clearColor]];
		[inZipCodeLabel setText:@"Only within my ZIP code area"];
		[inZipCodeLabel setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:14.0]];
		[inZipCodeLabel setTextColor:[SZGlobalConstants darkGray]];
		[inZipCodeLabel applyWhiteShadow];
		
		UIView* distanceView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 240.0, 210.0)];
		UILabel* distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 240.0, 44.0)];
		[distanceLabel setBackgroundColor:[UIColor clearColor]];
		[distanceLabel setText:@"Up to                             miles from"];
		[distanceLabel setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:14.0]];
		[distanceLabel setTextColor:[SZGlobalConstants darkGray]];
		[distanceLabel applyWhiteShadow];
		SZForm* distanceForm = [[SZForm alloc] initWithWidth:80.0];
		[distanceForm addItem:[NSDictionary dictionaryWithObjects:
							   [NSArray arrayWithObjects:@"3", [NSNumber numberWithInt:UIKeyboardTypeDecimalPad], nil] forKeys:
							   [NSArray arrayWithObjects:FORM_PLACEHOLDER, FORM_INPUT_TYPE, nil]] isLastItem:YES];
		[distanceForm setScrollContainer:self.view];
		[distanceForm configureKeyboard];
		[distanceForm setFrame:CGRectMake(50.0, 1.0, distanceForm.frame.size.width, distanceForm.frame.size.height)];
		SZForm* distanceAddressForm = [[SZForm alloc] initWithWidth:233.0];
		[distanceAddressForm addItem:[NSDictionary dictionaryWithObjects:
						[NSArray arrayWithObjects:@"Street Address", [NSNumber numberWithInt:UIKeyboardTypeDefault], nil] forKeys:
						[NSArray arrayWithObjects:FORM_PLACEHOLDER, FORM_INPUT_TYPE, nil]] isLastItem:NO];
		[distanceAddressForm addItem:[NSDictionary dictionaryWithObjects:
						[NSArray arrayWithObjects:@"City", [NSNumber numberWithInt:UIKeyboardTypeDefault], nil] forKeys:
						[NSArray arrayWithObjects:FORM_PLACEHOLDER, FORM_INPUT_TYPE, nil]] isLastItem:NO];
		[distanceAddressForm addItem:[NSDictionary dictionaryWithObjects:
						[NSArray arrayWithObjects:@"ZIP code", [NSNumber numberWithInt:UIKeyboardTypeNumbersAndPunctuation], nil] forKeys:
						[NSArray arrayWithObjects:FORM_PLACEHOLDER, FORM_INPUT_TYPE, nil]] isLastItem:NO];
		[distanceAddressForm addItem:[NSDictionary dictionaryWithObjects:
						[NSArray arrayWithObjects:@"State", [NSNumber numberWithInt:INPUT_TYPE_PICKER], [NSArray arrayWithObjects:@"California", @"Texas", @"Florida", @"Oregon", nil], nil] forKeys:
						[NSArray arrayWithObjects:FORM_PLACEHOLDER, FORM_INPUT_TYPE, PICKER_OPTIONS, nil]] isLastItem:YES];
		[distanceAddressForm setFrame:CGRectMake(0.0, 50.0, distanceAddressForm.frame.size.width, distanceAddressForm.frame.size.height)];
		[distanceAddressForm setScrollContainer:self.view];
		[distanceAddressForm configureKeyboard];
		[distanceView addSubview:distanceLabel];
		[distanceView addSubview:distanceForm];
		[distanceView addSubview:distanceAddressForm];
		
		UILabel* negotiableLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 240.0, 44.0)];
		[negotiableLabel setBackgroundColor:[UIColor clearColor]];
		[negotiableLabel setText:@"That's negotiable"];
		[negotiableLabel setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:14.0]];
		[negotiableLabel setTextColor:[SZGlobalConstants darkGray]];
		[negotiableLabel applyWhiteShadow];
		
		[_option1detailView addItemWithView:inZipCodeLabel];
		[_option1detailView addItemWithView:distanceView];
		[_option1detailView addItemWithView:negotiableLabel];
		
	}
	return _option1detailView;
}

- (UIView*)option2detailView {
	if (_option2detailView == nil) {
		_option2detailView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 290.0, 305.0)];
		
		UILabel* specifyAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 240.0, 44.0)];
		[specifyAddressLabel setBackgroundColor:[UIColor clearColor]];
		[specifyAddressLabel setText:@"Where would that be?"];
		[specifyAddressLabel setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:14.0]];
		[specifyAddressLabel setTextColor:[SZGlobalConstants darkGray]];
		[specifyAddressLabel applyWhiteShadow];
		
		SZForm* addressForm = [[SZForm alloc] initWithWidth:270.0];
		[addressForm addItem:[NSDictionary dictionaryWithObjects:
									  [NSArray arrayWithObjects:@"Street Address", [NSNumber numberWithInt:UIKeyboardTypeDefault], nil] forKeys:
									  [NSArray arrayWithObjects:FORM_PLACEHOLDER, FORM_INPUT_TYPE, nil]] isLastItem:NO];
		[addressForm addItem:[NSDictionary dictionaryWithObjects:
									  [NSArray arrayWithObjects:@"City", [NSNumber numberWithInt:UIKeyboardTypeDefault], nil] forKeys:
									  [NSArray arrayWithObjects:FORM_PLACEHOLDER, FORM_INPUT_TYPE, nil]] isLastItem:NO];
		[addressForm addItem:[NSDictionary dictionaryWithObjects:
									  [NSArray arrayWithObjects:@"ZIP code", [NSNumber numberWithInt:UIKeyboardTypeNumbersAndPunctuation], nil] forKeys:
									  [NSArray arrayWithObjects:FORM_PLACEHOLDER, FORM_INPUT_TYPE, nil]] isLastItem:NO];
		[addressForm addItem:[NSDictionary dictionaryWithObjects:
									  [NSArray arrayWithObjects:@"State", [NSNumber numberWithInt:INPUT_TYPE_PICKER], [NSArray arrayWithObjects:@"California", @"Texas", @"Florida", @"Oregon", nil], nil] forKeys:
									  [NSArray arrayWithObjects:FORM_PLACEHOLDER, FORM_INPUT_TYPE, PICKER_OPTIONS, nil]] isLastItem:YES];
		[addressForm setFrame:CGRectMake(0.0, 45.0, addressForm.frame.size.width, addressForm.frame.size.height)];
		[addressForm setScrollContainer:self.view];
		[addressForm configureKeyboard];
		
		UITextView* noticeText = [[UITextView alloc] initWithFrame:CGRectMake(0.0, addressForm.frame.size.height + 50.0, 270.0, 100.0)];
		[noticeText setTextAlignment:NSTextAlignmentJustified];
		[noticeText setBackgroundColor:[UIColor clearColor]];
		[noticeText setText:@"Note that your address will be used to display the request’s approximate location on a map. We will not  reveal your full address to anyone until you have agreed to engange in a deal with them."];
		[noticeText setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:11.0]];
		[noticeText setTextColor:[SZGlobalConstants darkGray]];
		[noticeText applyWhiteShadow];
		[noticeText setEditable:NO];
		
		[_option2detailView addSubview:specifyAddressLabel];
		[_option2detailView addSubview:addressForm];
		[_option2detailView addSubview:noticeText];
		
	}
	return _option2detailView;
}

- (void)segmentedControlVertical:(SZSegmentedControlVertical *)control didSelectItemAtIndex:(NSInteger)index {
	
	if ([[self.detailViewContainer subviews] count] > 0) {
		[UIView animateWithDuration:0.2 animations:^{
			[self.detailViewContainer setFrame:CGRectMake(330.0,
														  self.detailViewContainer.frame.origin.y,
														  self.detailViewContainer.frame.size.width,
														  self.detailViewContainer.frame.size.height)];
		} completion:^(BOOL finished) {
			UIView* currentDetailView = [[self.detailViewContainer subviews] objectAtIndex:0];
			[currentDetailView removeFromSuperview];
			[self addNewDetailView:index];
		}];
	}
	else {
		[self addNewDetailView:index];
	}
}

- (void)addNewDetailView:(NSInteger)index {
	
	switch (index) {
		case 0:
			[self.detailViewContainer addSubview:self.option1detailView];
			break;
		case 1:
			[self.detailViewContainer addSubview:self.option2detailView];
			break;
		case 2:
			break;
		default:
			break;
	}

	[super newDetailViewAdded];
}


- (void)continue:(id)sender {
	SZNewRequestStep4VC* step4 = [[SZNewRequestStep4VC alloc] init];
	[self.navigationController pushViewController:step4 animated:YES];
}

@end
