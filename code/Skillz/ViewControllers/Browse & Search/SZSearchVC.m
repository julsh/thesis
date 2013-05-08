//
//  SZSearchVC.m
//  Skillz
//
//  Created by Julia Roggatz on 17.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>
#import "SZSearchVC.h"
#import "SZUtils.h"
#import "SZButton.h"
#import "SZSearchResultsVC.h"
#import "SZSegmentedControlHorizontal.h"
#import "SZDataManager.h"

@interface SZSearchVC ()

@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) SZSegmentedControlHorizontal* entryTypeSelector;
@property (nonatomic, strong) SZForm* keywordsForm;
@property (nonatomic, strong) SZForm* categoryForm;
@property (nonatomic, strong) SZForm* locationForm;
@property (nonatomic, strong) UIButton* currentLocationButton;
@property (nonatomic, strong) UILabel* milesLabel;
@property (nonatomic, strong) UISlider* radiusSlider;

@property (nonatomic, assign) CGFloat radius;

@end

@implementation SZSearchVC

- (void)viewDidLoad {
	
	[super viewDidLoad];
	[self addMenuButton];
	[self.navigationItem setTitle:@"Search"];
	
	self.radius = 4;
	
	[self.view addSubview:self.scrollView];
	[self.scrollView addSubview:self.entryTypeSelector];
	[self.scrollView addSubview:[self searchingForLabel]];
	[self.scrollView addSubview:[self keywordsForm]];
	[self.scrollView addSubview:[self categoryLabel]];
	[self.scrollView addSubview:self.categoryForm];
	[self.scrollView addSubview:[self locationLabel]];
	[self.scrollView addSubview:self.locationForm];
	[self.scrollView addSubview:self.currentLocationButton];
	[self.scrollView addSubview:[self radiusLabel]];
	[self.scrollView addSubview:self.milesLabel];
	[self.scrollView addSubview:self.radiusSlider];
	[self.scrollView addSubview:[self searchButton]];
	
}

- (UIScrollView*)scrollView {
	if (_scrollView == nil) {
		_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 416.0)];
		[_scrollView setBackgroundColor:[UIColor clearColor]];
		[_scrollView setClipsToBounds:NO];
		[_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height)];
		
		UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTapped:)];
		[tapRecognizer setNumberOfTapsRequired:1];
		[_scrollView addGestureRecognizer:tapRecognizer];
	}
	return _scrollView;
}


- (void)scrollViewTapped:(id)sender {
	if (self.keywordsForm.isActive) {
		[self.keywordsForm resign:nil completion:nil];
	}
	else if (self.categoryForm.isActive) {
		[self.categoryForm resign:nil completion:nil];
	}
	else if (self.locationForm.isActive) {
		[self.locationForm resign:nil completion:nil];
	}
}


- (SZSegmentedControlHorizontal*)entryTypeSelector {
	if (_entryTypeSelector == nil) {
		
		_entryTypeSelector = [[SZSegmentedControlHorizontal alloc] initWithFrame:CGRectMake(15.0, 15.0, 290.0, 40.0)];
		[_entryTypeSelector insertSegmentWithTitle:@"Offers" atIndex:0 animated:NO];
		[_entryTypeSelector insertSegmentWithTitle:@"Requets" atIndex:1 animated:NO];
		[_entryTypeSelector setSelectedSegmentIndex:0];
	}
	return _entryTypeSelector;
}

- (UILabel*)searchingForLabel {
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 65.0, 280.0, 20.0)];
	[label setFont:[SZGlobalConstants fontWithFontType:SZFontBold size:14.0]];
	[label setTextColor:[SZGlobalConstants darkPetrol]];
	[label applyWhiteShadow];
	[label setText:@"What are you looking for?"];
	return label;
}

- (SZForm*)keywordsForm {
	
	if (_keywordsForm == nil) {
		
		_keywordsForm = [[SZForm alloc] initWithWidth:290.0];
		
		SZFormFieldVO* formField = [SZFormFieldVO formFieldValueObjectForTextWithKey:@"keywords"
																	  placeHolderText:@"Enter Keyword(s)"
																		 keyboardType:UIKeyboardTypeDefault];
		[_keywordsForm addItem:formField showsClearButton:YES isLastItem:YES];
		[_keywordsForm setCenter:CGPointMake(160.0, 110.0)];
		[_keywordsForm setScrollContainer:self.scrollView];
	}
	return _keywordsForm;
}

- (UILabel*)categoryLabel {
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 145.0, 280.0, 20.0)];
	[label setFont:[SZGlobalConstants fontWithFontType:SZFontBold size:14.0]];
	[label setTextColor:[SZGlobalConstants darkPetrol]];
	[label applyWhiteShadow];
	[label setText:@"Search in a specific category?"];
	return label;
}

- (SZForm*)categoryForm {
	if (_categoryForm == nil) {
		_categoryForm = [[SZForm alloc] initWithWidth:290.0];
		[_categoryForm setDelegate:self];
		
		SZFormFieldVO* categoryField = [SZFormFieldVO formFieldValueObjectForPickerWithKey:@"category"
																		   placeHolderText:@"Category"
																			 pickerOptions:[SZDataManager sortedCategories]];
		
		[_categoryForm addItem:categoryField showsClearButton:YES isLastItem:YES];
		[_categoryForm setCenter:CGPointMake(160.0, 190.0)];
		[_categoryForm addKeyboardToolbar];
		[_categoryForm setScrollContainer:self.scrollView];
		
	}
	return _categoryForm;
}

- (UILabel*)locationLabel {
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 225.0, 280.0, 20.0)];
	[label setFont:[SZGlobalConstants fontWithFontType:SZFontBold size:14.0]];
	[label setTextColor:[SZGlobalConstants darkPetrol]];
	[label applyWhiteShadow];
	[label setText:@"Where are you looking?"];
	return label;
}

- (SZForm*)locationForm {
	
	if (_locationForm == nil) {
		
		_locationForm = [[SZForm alloc] initWithWidth:290.0];
		
		SZFormFieldVO* formField = [SZFormFieldVO formFieldValueObjectForTextWithKey:@"location"
																	  placeHolderText:@"City, ZIP or full address"
																		 keyboardType:UIKeyboardTypeDefault];
		[_locationForm addItem:formField showsClearButton:YES isLastItem:YES];
		[_locationForm setDelegate:self];
		[_locationForm setTextFieldWidth:230.0 xInset:0.0 forFieldAtIndex:0];
		[_locationForm setCenter:CGPointMake(160.0, 270.0)];
		[_locationForm setScrollContainer:self.scrollView];
	}
	return _locationForm;
}

- (UIButton*)currentLocationButton {
	if (_currentLocationButton == nil) {
		
		_currentLocationButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[_currentLocationButton setFrame:CGRectMake(261.0, 250.0, 43.0, 40.0)];
		[_currentLocationButton setImage:[UIImage imageNamed:@"button_current_location"] forState:UIControlStateNormal];
		[_currentLocationButton setImage:[UIImage imageNamed:@"button_current_location_selected"] forState:UIControlStateHighlighted];
		[_currentLocationButton addTarget:self action:@selector(applyCurrentLocation:) forControlEvents:UIControlEventTouchUpInside];
	}
	return _currentLocationButton;
}

- (void)applyCurrentLocation:(id)sender {
	[self.locationForm setText:@"Current Location" forFieldAtIndex:0];
	[self.locationForm.userInputs setValue:@"Current Location" forKey:@"location"];
	[self scrollViewTapped:nil];
}

- (void)formDidBeginEditing:(SZForm *)form {
	if (form == self.locationForm && [[form.userInputs valueForKey:@"location"] isEqualToString:@"Current Location"]) {
		[self.locationForm setText:@"" forFieldAtIndex:0];
		[self.locationForm.userInputs setValue:@"" forKey:@"location"];
	}
}

- (UILabel*)radiusLabel {
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 315.0, 280.0, 20.0)];
	[label setFont:[SZGlobalConstants fontWithFontType:SZFontBold size:14.0]];
	[label setTextColor:[SZGlobalConstants darkPetrol]];
	[label applyWhiteShadow];
	[label setText:@"Radius:"];
	return label;
}

- (UILabel*)milesLabel {
	if (_milesLabel == nil) {
		_milesLabel = [[UILabel alloc] initWithFrame:CGRectMake(220.0, 315.0, 80.0, 20.0)];
		[_milesLabel setFont:[SZGlobalConstants fontWithFontType:SZFontExtraBold size:14.0]];
		[_milesLabel setTextColor:[SZGlobalConstants darkPetrol]];
		[_milesLabel applyWhiteShadow];
		[_milesLabel setTextAlignment:NSTextAlignmentRight];
		[_milesLabel setText:[NSString stringWithFormat:@"%i mi", (NSInteger)self.radius]];
	}
	return _milesLabel;
}

- (UISlider*)radiusSlider {
	if (_radiusSlider == nil) {
		_radiusSlider = [[UISlider alloc] initWithFrame:CGRectMake(85.0, 314.0, 160.0, 20.0)];
		[_radiusSlider setMinimumTrackTintColor:[SZGlobalConstants darkPetrol]];
		[_radiusSlider addTarget:self action:@selector(radiusChanged:) forControlEvents:UIControlEventValueChanged];
		[_radiusSlider setValue:sqrtf((float)self.radius/100.0)];
	}
	return _radiusSlider;
}

- (void)radiusChanged:(UISlider*)slider {
	NSInteger roundedValue = powf(slider.value, 2) * 100;
	if (roundedValue >= 99) roundedValue += 1;
	if (roundedValue != self.radius) {
		self.radius = roundedValue;
		NSLog(@"radius: %f", self.radius);
		if (self.radius == 0) {
			self.radius = 0.5;
			[self.milesLabel setText:@"0.5 mi"];
		}
		else if (self.radius == 101) {
			[self.milesLabel setText:@"100+ mi"];
		}
		else {
			[self.milesLabel setText:[NSString stringWithFormat:@"%i mi", (NSInteger)self.radius]];
		}
	}
}

- (SZButton*)searchButton {
	SZButton* button = [SZButton buttonWithColor:SZButtonColorPetrol size:SZButtonSizeLarge width:290.0];
	[button setTitle:@"Search!" forState:UIControlStateNormal];
	[button setCenter:CGPointMake(160.0, 380.0)];
	[button addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
	return button;
}

- (void)search:(id)sender {
	
	NSString* entryType = self.entryTypeSelector.selectedSegmentIndex == 0 ? @"offer" : @"request";
	// we're creating two queries that will be OR-connected
	PFQuery* titleQuery = [PFQuery queryWithClassName:@"Entry"];			// one to parse the titles
	PFQuery* descriptionQuery = [PFQuery queryWithClassName:@"Entry"];		// one to parse the descriptions
	NSString* keywordsInput = [self.keywordsForm.userInputs valueForKey:@"keywords"];
	if (![keywordsInput isEqualToString:@""]) {
		// here we're taking apart the keywords string, splitting it into single words
		NSArray* keywords = [keywordsInput componentsSeparatedByString:@" "];
		for (NSString* keyword in keywords) {
			// and each word will be added to the two queries. keywords will be AND-connected, meaning they all have to be contained
			[titleQuery whereKey:@"title" containsString:keyword];
			[descriptionQuery whereKey:@"description" containsString:keyword];
		}
	}
	
	PFQuery* orQuery = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:titleQuery, descriptionQuery, nil]];
	[orQuery whereKey:@"entryType" equalTo:entryType];
	
	NSString* categoryInput = [self.categoryForm.userInputs valueForKey:@"category"];
	if (![categoryInput isEqualToString:@""]) {
		[orQuery whereKey:@"category" equalTo:categoryInput];	// if the user specified a category, this will be another constraint
	}
	
	NSString* locationInput = [self.locationForm.userInputs valueForKey:@"location"];
	
	if (locationInput && ![locationInput isEqualToString:@""] && ![locationInput isEqualToString:@"Current Location"] && self.radius <= 100) {
		
		// search base will be some kind of address entered by the user
		CLGeocoder* geoCoder = [[CLGeocoder alloc] init];
		[geoCoder geocodeAddressString:locationInput completionHandler:^(NSArray *placemarks, NSError *error) {
			if (placemarks && [placemarks count] > 0) {
				CLPlacemark* placemark = [placemarks objectAtIndex:0];
				CGFloat radiusExtension = MetersToMiles(placemark.region.radius) + self.radius;
				PFGeoPoint* geoPoint = [PFGeoPoint geoPointWithLocation:placemark.location];
				[orQuery whereKey:@"geoPoint" nearGeoPoint:geoPoint withinMiles:radiusExtension];
				
				NSMutableDictionary* locationDict = [[NSMutableDictionary alloc] init];
				[locationDict setValue:[PFGeoPoint geoPointWithLocation:placemark.location] forKey:@"geoPoint"];
				[locationDict setValue:locationInput forKey:@"textInput"];
				[locationDict setValue:[NSNumber numberWithFloat:self.radius] forKey:@"radius"];
				[SZDataManager sharedInstance].searchLocationBase = locationDict;
				
				SZSearchResultsVC* searchResultsVC = [[SZSearchResultsVC alloc] initWithQuery:orQuery];
				[self.navigationController pushViewController:searchResultsVC animated:YES];
			}
			else {
				UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Location not found" message:@"We're sorry, but the location information you provided didn't turn up any results. Please try to be more specific." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
				[alert show];
				return;
			}
		}];
	}
	
	else {
		
		// if no address provided, we'll determine the current user position and use that as the seach base
		[PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
			if (geoPoint) {
				NSMutableDictionary* locationDict = [[NSMutableDictionary alloc] init];
				[locationDict setValue:geoPoint forKey:@"geoPoint"];
			
				if ([locationInput isEqualToString:@"Current Location"] && self.radius <= 100) {
					// if the user specifically searches with a certain radius around current location,
					// this will be added as a constraint to the query
					[orQuery whereKey:@"geoPoint" nearGeoPoint:geoPoint withinMiles:self.radius];
					[locationDict setValue:[NSNumber numberWithFloat:self.radius] forKey:@"radius"];
				}
				[locationDict setValue:@"Current Location" forKey:@"textInput"];
				[SZDataManager sharedInstance].searchLocationBase = locationDict;
				SZSearchResultsVC* searchResultsVC = [[SZSearchResultsVC alloc] initWithQuery:orQuery];
				[self.navigationController pushViewController:searchResultsVC animated:YES];
			}
			else {
				UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Couldn't determine your location" message:@"Please make sure location services are turned on and your device is connected to the network." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
				[alert show];
				return;
			}
		}];
	}
	
}

@end
