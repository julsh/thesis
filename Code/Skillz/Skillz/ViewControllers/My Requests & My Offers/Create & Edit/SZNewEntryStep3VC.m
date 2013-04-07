//
//  SZNewEntryStep3VC.m
//  Skillz
//
//  Created by Julia Roggatz on 25.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZNewEntryStep3VC.h"
#import "SZNewEntryStep4VC.h"
#import "SZRadioButtonControl.h"
#import "SZUtils.h"
#import "SZForm.h"
#import "UITextView+Shadow.h"

@interface SZNewEntryStep3VC ()

@property (nonatomic, strong) SZSegmentedControlVertical* segmentedControl;
@property (nonatomic, strong) SZRadioButtonControl* option1detailView;
@property (nonatomic, strong) UIView* option2detailView;
@property (nonatomic, strong) SZForm* distanceForm;
@property (nonatomic, strong) SZForm* option1AddressForm;
@property (nonatomic, strong) SZForm* option2AddressForm;

@end

@implementation SZNewEntryStep3VC

@synthesize segmentedControl = _segmentedControl;
@synthesize option1detailView = _option1detailView;
@synthesize option2detailView = _option2detailView;
@synthesize distanceForm = _distanceForm;
@synthesize option1AddressForm = _option1AddressForm;
@synthesize option2AddressForm = _option2AddressForm;

- (id)init
{
    return [super initWithStepNumber:3 totalSteps:5];
}

- (void)viewDidLoad
{
	self.editTaskFirstDisplay = YES;
    [super viewDidLoad];
	switch ([SZDataManager sharedInstance].currentEntryType) {
		case SZEntryTypeRequest:
			[self.navigationItem setTitle:[SZDataManager sharedInstance].currentEntryIsNew ? @"Post a Request" : @"Edit Request"];
			break;
		case SZEntryTypeOffer:
			[self.navigationItem setTitle:[SZDataManager sharedInstance].currentEntryIsNew ? @"Post an Offer" : @"Edit Offer"];
			break;
	}
	
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
		
		if (![SZDataManager sharedInstance].currentEntryIsNew) {
			SZEntryVO* entry = (SZEntryVO*)[SZDataManager sharedInstance].currentEntry;
			if (entry.locationWillGoSomewhere) {
				[_segmentedControl selectItemWithIndex:0];
			}
			else if (entry.locationIsRemote) {
				[_segmentedControl selectItemWithIndex:2];
			}
			else {
				[_segmentedControl selectItemWithIndex:1];
			}
		}

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
		
		self.distanceForm = [[SZForm alloc] initWithWidth:80.0];
		SZFormFieldVO* distanceField = [SZFormFieldVO formFieldValueObjectForTextWithKey:@"distance"
																		 placeHolderText:@"5"
																			keyboardType:UIKeyboardTypeDecimalPad];
		[self.distanceForm addItem:distanceField isLastItem:YES];
		[self.distanceForm setDelegate:self];
		[self.distanceForm setScrollContainer:self.view];
		[self.distanceForm configureKeyboard];
		[self.distanceForm setFrame:CGRectMake(50.0, 1.0, self.distanceForm.frame.size.width, self.distanceForm.frame.size.height)];
		
		self.option1AddressForm = [SZForm addressFormWithWidth:233.0];
		[self.option1AddressForm setDelegate:self];
		[self.option1AddressForm setScrollContainer:self.view];
		[self.option1AddressForm  setFrame:CGRectMake(0.0, 50.0, self.option1AddressForm .frame.size.width, self.option1AddressForm .frame.size.height)];
		
		[distanceView addSubview:distanceLabel];
		[distanceView addSubview:self.distanceForm];
		[distanceView addSubview:self.option1AddressForm];
		
		UILabel* negotiableLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 240.0, 44.0)];
		[negotiableLabel setBackgroundColor:[UIColor clearColor]];
		[negotiableLabel setText:@"That's negotiable"];
		[negotiableLabel setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:14.0]];
		[negotiableLabel setTextColor:[SZGlobalConstants darkGray]];
		[negotiableLabel applyWhiteShadow];
		
		[_option1detailView addItemWithView:inZipCodeLabel];
		[_option1detailView addItemWithView:distanceView];
		[_option1detailView addItemWithView:negotiableLabel];
	
		[_option1detailView setSelectedIndex:0];
		
		if (![SZDataManager sharedInstance].currentEntryIsNew) {
			SZEntryVO* entry = (SZEntryVO*)[SZDataManager sharedInstance].currentEntry;
			if (entry.withinZipCode) {
				[_option1detailView setSelectedIndex:0];
			}
			else if (entry.withinSpecifiedArea) {
				[_option1detailView setSelectedIndex:1];
				if (entry.distance) {
					[self.distanceForm.userInputs setValue:[NSString stringWithFormat:@"%i", [entry.distance intValue]] forKey:@"distance"];
					[self.distanceForm setText:[NSString stringWithFormat:@"%i", [entry.distance intValue]] forFieldAtIndex:0];
				}
				if (entry.address) {
					[self.option1AddressForm.userInputs setValue:[entry.address valueForKey:@"streetAddress"] forKey:@"streetAddress"];
					[self.option1AddressForm.userInputs setValue:[entry.address valueForKey:@"city"] forKey:@"city"];
					[self.option1AddressForm.userInputs setValue:[entry.address valueForKey:@"zipCode"] forKey:@"zipCode"];
					[self.option1AddressForm.userInputs setValue:[entry.address valueForKey:@"state"] forKey:@"state"];
					[self.option1AddressForm setText:[entry.address valueForKey:@"streetAddress"] forFieldAtIndex:0];
					[self.option1AddressForm setText:[entry.address valueForKey:@"city"] forFieldAtIndex:1];
					[self.option1AddressForm setText:[entry.address valueForKey:@"zipCode"] forFieldAtIndex:2];
					[self.option1AddressForm setText:[entry.address valueForKey:@"state"] forFieldAtIndex:3];
					[self.option1AddressForm updatePickerAtIndex:3];
				}
			}
			else if (entry.withinNegotiableArea) {
				[_option1detailView setSelectedIndex:2];
			}
		}
		
	}
	return _option1detailView;
}

- (UIView*)option2detailView {
	if (_option2detailView == nil) {
		_option2detailView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 290.0, 305.0)];
		
		UILabel* specifyAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 240.0, 44.0)];
		[specifyAddressLabel setBackgroundColor:[UIColor clearColor]];
		[specifyAddressLabel setText:@"Where do you live?"];
		[specifyAddressLabel setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:14.0]];
		[specifyAddressLabel setTextColor:[SZGlobalConstants darkGray]];
		[specifyAddressLabel applyWhiteShadow];
		
		self.option2AddressForm = [SZForm addressFormWithWidth:270.0];
		[self.option2AddressForm setScrollContainer:self.view];
		[self.option2AddressForm setFrame:CGRectMake(0.0, 45.0, self.option2AddressForm.frame.size.width, self.option2AddressForm.frame.size.height)];
		
		UITextView* noticeText = [[UITextView alloc] initWithFrame:CGRectMake(0.0, self.option2AddressForm.frame.size.height + 50.0, 270.0, 100.0)];
		[noticeText setTextAlignment:NSTextAlignmentJustified];
		[noticeText setBackgroundColor:[UIColor clearColor]];
		[noticeText setText:[NSString stringWithFormat:@"Note that your address will be used to display the %@’s approximate location on a map. We will not  reveal your full address to anyone until you have agreed to engange in a deal with them.", [SZDataManager sharedInstance].currentEntryType == SZEntryTypeRequest ? @"request" : @"offer"]];
		[noticeText setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:11.0]];
		[noticeText setTextColor:[SZGlobalConstants darkGray]];
		[noticeText applyWhiteShadow];
		[noticeText setEditable:NO];
		
		[_option2detailView addSubview:specifyAddressLabel];
		[_option2detailView addSubview:self.option2AddressForm];
		[_option2detailView addSubview:noticeText];
		
		if (![SZDataManager sharedInstance].currentEntryIsNew) {
			SZEntryVO* entry = (SZEntryVO*)[SZDataManager sharedInstance].currentEntry;
			
			if (entry.address) {
					[self.option2AddressForm.userInputs setValue:[entry.address valueForKey:@"streetAddress"] forKey:@"streetAddress"];
					[self.option2AddressForm.userInputs setValue:[entry.address valueForKey:@"city"] forKey:@"city"];
					[self.option2AddressForm.userInputs setValue:[entry.address valueForKey:@"zipCode"] forKey:@"zipCode"];
					[self.option2AddressForm.userInputs setValue:[entry.address valueForKey:@"state"] forKey:@"state"];
					[self.option2AddressForm setText:[entry.address valueForKey:@"streetAddress"] forFieldAtIndex:0];
					[self.option2AddressForm setText:[entry.address valueForKey:@"city"] forFieldAtIndex:1];
					[self.option2AddressForm setText:[entry.address valueForKey:@"zipCode"] forFieldAtIndex:2];
					[self.option2AddressForm setText:[entry.address valueForKey:@"state"] forFieldAtIndex:3];
					[self.option2AddressForm updatePickerAtIndex:3];
			}
		}
		
	}
	return _option2detailView;
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
	
	if ([SZDataManager sharedInstance].currentEntryIsNew || !self.editTaskFirstDisplay) {
		[super newDetailViewAddedAnimated:YES];
	}
	else {
		[super newDetailViewAddedAnimated:NO];
		[self.mainView setContentOffset:CGPointMake(0.0, 0.0)];
		self.editTaskFirstDisplay = NO;
	}
}

- (void)formDidBeginEditing:(SZForm *)form {
	[self.option1detailView setSelectedIndex:1];
}


- (void)continue:(id)sender {

#ifndef DEBUG
	if (self.segmentedControl.selectedIndex == -1) {
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Please select an option." message:nil delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
		[alertView show];
		return;
	}
#endif
	
	[self storeInputs];
	
	if ([[SZDataManager sharedInstance].viewControllerStack count] != 0)
		[self.navigationController pushViewController:[[SZDataManager sharedInstance].viewControllerStack pop] animated:YES];
	else
		[self.navigationController pushViewController:[[SZNewEntryStep4VC alloc] init] animated:YES];
}

- (void)storeInputs {
	
	switch (self.segmentedControl.selectedIndex) {
		case SZEntryLocationWillGoSomewhereElse:
			((SZEntryVO*)[SZDataManager sharedInstance].currentEntry).locationWillGoSomewhere = YES;
			((SZEntryVO*)[SZDataManager sharedInstance].currentEntry).locationIsRemote = NO;
			break;
		case SZEntryLocationWillStayAtHome:
			((SZEntryVO*)[SZDataManager sharedInstance].currentEntry).locationWillGoSomewhere = NO;
			((SZEntryVO*)[SZDataManager sharedInstance].currentEntry).locationIsRemote = NO;
			break;
		case SZEntryLocationRemote:
			((SZEntryVO*)[SZDataManager sharedInstance].currentEntry).locationWillGoSomewhere = NO;
			((SZEntryVO*)[SZDataManager sharedInstance].currentEntry).locationIsRemote = YES;
			break;
		default:
			break;
	}
	
	if (self.segmentedControl.selectedIndex == SZEntryLocationWillGoSomewhereElse) {
		
		if (self.option1detailView.selectedIndex == 0) {
			((SZEntryVO*)[SZDataManager sharedInstance].currentEntry).withinZipCode = YES;
			((SZEntryVO*)[SZDataManager sharedInstance].currentEntry).withinSpecifiedArea = NO;
			((SZEntryVO*)[SZDataManager sharedInstance].currentEntry).withinNegotiableArea = NO;
			((SZEntryVO*)[SZDataManager sharedInstance].currentEntry).distance = nil;
			((SZEntryVO*)[SZDataManager sharedInstance].currentEntry).address = nil;
		}
		else if (self.option1detailView.selectedIndex == 1) {
			((SZEntryVO*)[SZDataManager sharedInstance].currentEntry).withinZipCode = NO;
			((SZEntryVO*)[SZDataManager sharedInstance].currentEntry).withinSpecifiedArea = YES;
			((SZEntryVO*)[SZDataManager sharedInstance].currentEntry).withinNegotiableArea = NO;
			
			NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
			[formatter setNumberStyle:NSNumberFormatterDecimalStyle];
			NSNumber* distance = [formatter numberFromString:[self.distanceForm.userInputs valueForKey:@"distance"]];
			((SZEntryVO*)[SZDataManager sharedInstance].currentEntry).distance = distance;
			
			((SZEntryVO*)[SZDataManager sharedInstance].currentEntry).address = [SZForm addressDictfromAddressForm:self.option1AddressForm];
		}
		else if (self.option1detailView.selectedIndex == 2) {
			((SZEntryVO*)[SZDataManager sharedInstance].currentEntry).withinZipCode = NO;
			((SZEntryVO*)[SZDataManager sharedInstance].currentEntry).withinSpecifiedArea = NO;
			((SZEntryVO*)[SZDataManager sharedInstance].currentEntry).withinNegotiableArea = YES;
			((SZEntryVO*)[SZDataManager sharedInstance].currentEntry).distance = nil;
			((SZEntryVO*)[SZDataManager sharedInstance].currentEntry).address = nil;
		}
	}
	else if (self.segmentedControl.selectedIndex == SZEntryLocationWillStayAtHome) {
		((SZEntryVO*)[SZDataManager sharedInstance].currentEntry).withinZipCode = NO;
		((SZEntryVO*)[SZDataManager sharedInstance].currentEntry).withinSpecifiedArea = NO;
		((SZEntryVO*)[SZDataManager sharedInstance].currentEntry).withinNegotiableArea = NO;
		((SZEntryVO*)[SZDataManager sharedInstance].currentEntry).distance = nil;
		((SZEntryVO*)[SZDataManager sharedInstance].currentEntry).address = [SZForm addressDictfromAddressForm:self.option2AddressForm];
	}
	
}


@end
