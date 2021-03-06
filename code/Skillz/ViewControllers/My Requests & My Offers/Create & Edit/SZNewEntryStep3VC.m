//
//  SZNewEntryStep3VC.m
//  Skillz
//
//  Created by Julia Roggatz on 25.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "SZNewEntryStep3VC.h"
#import "SZNewEntryStep4VC.h"
#import "SZRadioButtonControl.h"
#import "SZUtils.h"
#import "SZForm.h"
#import "UITextView+Shadow.h"
#import "SZDataManager.h"

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

- (id)init {
    return [super initWithStepNumber:3 totalSteps:5];
}

- (void)viewDidLoad {
	self.firstDisplay = YES;
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
			SZEntryObject* entry = (SZEntryObject*)[SZDataManager sharedInstance].currentEntry;
			_segmentedControl.selectedIndex = entry.locationType;
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
		[self.forms addObject:self.distanceForm];
		SZFormFieldVO* distanceField = [SZFormFieldVO formFieldValueObjectForTextWithKey:@"distance"
																		 placeHolderText:@"5"
																			keyboardType:UIKeyboardTypeDecimalPad];
		[self.distanceForm addItem:distanceField showsClearButton:NO isLastItem:YES];
		[self.distanceForm setDelegate:self];
		[self.distanceForm setScrollContainer:self.mainView];
		[self.distanceForm addKeyboardToolbar];
		[self.distanceForm setFrame:CGRectMake(50.0, 1.0, self.distanceForm.frame.size.width, self.distanceForm.frame.size.height)];
		
		self.option1AddressForm = [SZForm addressFormWithWidth:233.0];
		[self.forms addObject:self.option1AddressForm];
		[self.option1AddressForm setDelegate:self];
		[self.option1AddressForm setScrollContainer:self.mainView];
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
			SZEntryObject* entry = (SZEntryObject*)[SZDataManager sharedInstance].currentEntry;
			[_option1detailView setSelectedIndex:entry.areaType];
			if (entry.areaType == SZEntryAreaWithinSpecifiedArea) {
				if (entry.distance) {
					[self.distanceForm.userInputs setValue:[NSString stringWithFormat:@"%i", [entry.distance intValue]] forKey:@"distance"];
					[self.distanceForm setText:[NSString stringWithFormat:@"%i", [entry.distance intValue]] forFieldAtIndex:0];
				}
				if (entry.address) {
					[self.option1AddressForm setAddress:entry.address];
					[self.option1AddressForm updatePickerAtIndex:3];
				}
			}
		}
		else {
			if ([SZDataManager lastEnteredAddress]) {
				[self.option1AddressForm setAddress:[SZDataManager lastEnteredAddress]];
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
		[self.forms addObject:self.option2AddressForm];
		[self.option2AddressForm setScrollContainer:self.mainView];
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
			SZEntryObject* entry = (SZEntryObject*)[SZDataManager sharedInstance].currentEntry;
			
			if (entry.address) {
					[self.option2AddressForm setAddress:entry.address];
					[self.option2AddressForm updatePickerAtIndex:3];
			}
		}
		else if ([SZDataManager lastEnteredAddress]) {
			[self.option2AddressForm setAddress:[SZDataManager lastEnteredAddress]];
		}
		
	}
	return _option2detailView;
}

- (void)segmentedControlVertical:(SZSegmentedControlVertical *)control didSelectItemAtIndex:(NSInteger)index {
	
	SZForm* activeForm = nil;
	
	if (self.distanceForm.isActive) {
		activeForm = self.distanceForm;
	}
	else if (self.option1AddressForm.isActive) {
		activeForm = self.option1AddressForm;
	}
	else if (self.option2AddressForm.isActive) {
		activeForm = self.option2AddressForm;
	}
	
	// if a form is still in edit mode (showing keyboard or picker), hide the input view before animating the rest.
	// otherwise the animations will overlap and the layout will be completely screwed up.
	if (activeForm) {
		[activeForm resign:nil completion:^(BOOL finished) {
			[super segmentedControlVertical:control didSelectItemAtIndex:index];
		}];
	}
	else {
		[super segmentedControlVertical:control didSelectItemAtIndex:index];
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
	
	if ([SZDataManager sharedInstance].currentEntryIsNew || !self.firstDisplay) {
		[super newDetailViewAddedAnimated:YES];
	}
	else {
		[super newDetailViewAddedAnimated:NO];
		[self.mainView setContentOffset:CGPointMake(0.0, 0.0)];
		self.firstDisplay = NO;
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
	
	SZEntryObject* entry = (SZEntryObject*)[SZDataManager sharedInstance].currentEntry;
	
	entry.locationType = self.segmentedControl.selectedIndex;
	
	if (entry.locationType == SZEntryLocationWillGoSomewhereElse) {
		
		entry.areaType = self.option1detailView.selectedIndex;
		
		if (entry.areaType == SZEntryAreaWithinSpecifiedArea) {
			
			NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
			[formatter setNumberStyle:NSNumberFormatterDecimalStyle];
			NSNumber* distance = [formatter numberFromString:[self.distanceForm.userInputs valueForKey:@"distance"]];
			entry.distance = distance;
			
			entry.address = [SZForm addressDictFromAddressForm:self.option1AddressForm];
			[SZDataManager saveLastEnderedAddress:[SZForm addressDictFromAddressForm:self.option1AddressForm]];
			
		}
	}
	else if (entry.locationType == SZEntryLocationWillStayAtHome) {
		
		entry.address = [SZForm addressDictFromAddressForm:self.option2AddressForm];
		[SZDataManager saveLastEnderedAddress:[SZForm addressDictFromAddressForm:self.option2AddressForm]];
	}
	
	
	// Geocoding the address or zip code area to a PFGeoPoint object to enable queries bases on location
	NSString* locationString;
	if (entry.address) locationString = [NSString stringWithFormat:@"%@, %@, %@ %@, USA",
											 [entry.address valueForKey:@"streetAddress"],
											 [entry.address valueForKey:@"city"],
											 [entry.address valueForKey:@"state"],
											 [entry.address valueForKey:@"zipCode"]];
	else if (entry.areaType == SZEntryAreaWithinZipCode) locationString = [NSString stringWithFormat:@"%@ %@, USA",
																		   [entry.user valueForKey:@"zipCode"],
																		   [entry.user valueForKey:@"state"]];
	
	if (locationString) {
		CLGeocoder* geoCoder = [[CLGeocoder alloc] init];
		[geoCoder geocodeAddressString:locationString completionHandler:^(NSArray *placemarks, NSError *error) {
			if (placemarks && [placemarks count] > 0) {
				CLPlacemark* placemark = [placemarks objectAtIndex:0];
				CLLocation* location = [placemark location];
				PFGeoPoint* geoPoint = [PFGeoPoint geoPointWithLocation:location];
				[entry setObject:geoPoint forKey:@"geoPoint"];
				[SZDataManager sharedInstance].currentEntry = entry;
			}
		}];
	}
}


@end
