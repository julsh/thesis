//
//  SZFilterMenuVC.m
//  Skillz
//
//  Created by Julia Roggatz on 18.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SZFilterMenuVC.h"
#import "SZButton.h"
#import "NMRangeSlider.h"
#import "SZDataManager.h"

@interface SZFilterMenuVC ()

@property (nonatomic, strong) UISlider* userRatingSlider;
@property (nonatomic, strong) UILabel* userRatingLabel;

@property (nonatomic, strong) NMRangeSlider* priceSlider;
@property (nonatomic, strong) UILabel* priceLabel;

@property (nonatomic, strong) UISlider* radiusSlider;
@property (nonatomic, strong) UILabel* radiusLabel;
@property (nonatomic, strong) SZForm* locationForm;
@property (nonatomic, strong) UIButton* currentLocationButton;

@property (nonatomic, assign) NSInteger minimumUserRating;
@property (nonatomic, assign) NSInteger minimumPrice;
@property (nonatomic, assign) NSInteger maximumPrice;
@property (nonatomic, assign) NSInteger maximusRadius;
@property (nonatomic, strong) UIImageView* pointsIcon;

@property (nonatomic, strong) NSMutableDictionary* filterDict;

@end

@implementation SZFilterMenuVC

@synthesize filterDict = _filterDict;
@synthesize locationForm = _locationForm;
@synthesize currentLocationButton = _currentLocationButton;

- (void)viewDidLoad {
    [super viewDidLoad];
	[self setTitle:@"Filter Results"];
	
	[self.scrollView addSubview:[self ratingView]];
	[self.scrollView addSubview:[self priceView]];
	[self.scrollView addSubview:[self radiusView]];
	[self.scrollView addSubview:[self filterButton]];
	[self.scrollView addSubview:[self cancelButton]];
}

- (void)viewDidAppear:(BOOL)animated {
	if ([SZDataManager sharedInstance].searchLocationBase && [[SZDataManager sharedInstance].searchLocationBase valueForKey:@"textInput"]) {
		[self.locationForm setText:[[SZDataManager sharedInstance].searchLocationBase valueForKey:@"textInput"] forFieldAtIndex:0];
		[self.locationForm.userInputs setValue:[[SZDataManager sharedInstance].searchLocationBase valueForKey:@"textInput"] forKey:@"location"];
	}
}

- (NSMutableDictionary*)filterDict {
	if (_filterDict == nil) {
		_filterDict = [[NSMutableDictionary alloc] init];
		[_filterDict setValue:[NSNumber numberWithInt:0] forKey:@"minRating"];
		[_filterDict setValue:[NSNumber numberWithInt:0] forKey:@"minPrice"];
		[_filterDict setValue:[NSNumber numberWithInt:100] forKey:@"maxPrice"];
		
		if ([[SZDataManager sharedInstance].searchLocationBase valueForKey:@"radius"]) {
			[_filterDict setValue:[[SZDataManager sharedInstance].searchLocationBase valueForKey:@"radius"] forKey:@"radius"];
			NSLog(@"has radius");
		}
		else {
			[_filterDict setValue:[NSNumber numberWithInt:100] forKey:@"radius"];
			NSLog(@"no radius");
		}
		[_filterDict setValue:[[SZDataManager sharedInstance].searchLocationBase valueForKey:@"textInput"] forKey:@"sortLocation"];
	}
	return _filterDict;
}


- (UIView*)ratingView {
	
	self.minimumUserRating = 0;
	
	UIView* ratingView = [self backgroundViewWithRect:CGRectMake(10.0, 5.0, 215.0, 80.0)];
	
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 7.0, 180.0, 20.0)];
	[label setFont:[SZGlobalConstants fontWithFontType:SZFontBold size:14.0]];
	[label setTextColor:[SZGlobalConstants darkPetrol]];
	[label applyWhiteShadow];
	[label setText:@"Minimum User Rating:"];
	
	self.userRatingSlider = [[UISlider alloc] initWithFrame:CGRectMake(10.0, 30.0, 195.0, 20.0)];
	[self.userRatingSlider setMinimumTrackTintColor:[SZGlobalConstants darkPetrol]];
	[self.userRatingSlider addTarget:self action:@selector(userRatingValueChanged:) forControlEvents:UIControlEventValueChanged];
	[self.userRatingSlider setValue:self.minimumUserRating / 5.0];
	
	self.userRatingLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 55.0, 195.0, 20.0)];
	[self.userRatingLabel setTextAlignment:NSTextAlignmentRight];
	[self.userRatingLabel setFont:[SZGlobalConstants fontWithFontType:SZFontBold size:14.0]];
	[self.userRatingLabel setTextColor:[SZGlobalConstants darkPetrol]];
	[self.userRatingLabel applyWhiteShadow];
	[self.userRatingLabel setText:@"doesn't matter"];
	
	[ratingView addSubview:label];
	[ratingView addSubview:self.userRatingSlider];
	[ratingView addSubview:self.userRatingLabel];
	
	return ratingView;
}

- (UIView*)priceView {
	
	self.minimumPrice = 0;
	self.maximumPrice = 100;
	
	UIView* priceView = [self backgroundViewWithRect:CGRectMake(10.0, 90.0, 215.0, 80.0)];
	
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 7.0, 180.0, 20.0)];
	[label setFont:[SZGlobalConstants fontWithFontType:SZFontBold size:14.0]];
	[label setTextColor:[SZGlobalConstants darkPetrol]];
	[label applyWhiteShadow];
	[label setText:@"Price Range:"];
	
	self.priceSlider = [[NMRangeSlider alloc] initWithFrame:CGRectMake(10.0, 30.0, 195.0, 20.0)];
	[self.priceSlider addTarget:self action:@selector(priceRangeValueChanged:) forControlEvents:UIControlEventValueChanged];
	
	self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 55.0, 195.0, 20.0)];
	[self.priceLabel setTextAlignment:NSTextAlignmentRight];
	[self.priceLabel setFont:[SZGlobalConstants fontWithFontType:SZFontBold size:14.0]];
	[self.priceLabel setTextColor:[SZGlobalConstants darkPetrol]];
	[self.priceLabel applyWhiteShadow];
	[self.priceLabel setText:@"0 - 100+"];
	
	self.pointsIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"skillpoints_small"]];
	[self.pointsIcon setFrame:CGRectMake(128.0, 55.0, self.pointsIcon.frame.size.width, self.pointsIcon.frame.size.height)];
	
	[priceView addSubview:self.pointsIcon];
	[priceView addSubview:label];
	[priceView addSubview:self.priceSlider];
	[priceView addSubview:self.priceLabel];
	
	return priceView;
}

- (UIView*)radiusView {
	
	self.maximusRadius = [[self.filterDict valueForKey:@"radius"] integerValue];
	
	UIView* radiusView = [self backgroundViewWithRect:CGRectMake(10.0, 175.0, 215.0, 127.0)];
	
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 7.0, 180.0, 20.0)];
	[label setFont:[SZGlobalConstants fontWithFontType:SZFontBold size:14.0]];
	[label setTextColor:[SZGlobalConstants darkPetrol]];
	[label applyWhiteShadow];
	[label setText:@"Radius:"];

	self.radiusSlider = [[UISlider alloc] initWithFrame:CGRectMake(10.0, 30.0, 195.0, 20.0)];
	[self.radiusSlider setMinimumTrackTintColor:[SZGlobalConstants darkPetrol]];
	[self.radiusSlider addTarget:self action:@selector(radiusValueChanged:) forControlEvents:UIControlEventValueChanged];
	[_radiusSlider setValue:sqrtf((float)self.maximusRadius/100.0)];
	
	self.radiusLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 55.0, 195.0, 20.0)];
	[self.radiusLabel setTextAlignment:NSTextAlignmentRight];
	[self.radiusLabel setFont:[SZGlobalConstants fontWithFontType:SZFontBold size:14.0]];
	[self.radiusLabel setTextColor:[SZGlobalConstants darkPetrol]];
	[self.radiusLabel applyWhiteShadow];
	[self.radiusLabel setText:[NSString stringWithFormat:@"up to %i miles around:", self.maximusRadius]];
	
	[radiusView addSubview:label];
	[radiusView addSubview:self.radiusSlider];
	[radiusView addSubview:self.radiusLabel];
	[radiusView addSubview:self.locationForm];
	[radiusView addSubview:self.currentLocationButton];
	
	return radiusView;
}

- (SZForm*)locationForm {
	
	if (_locationForm == nil) {
		
		_locationForm = [[SZForm alloc] initWithWidth:205.0];
		
		SZFormFieldVO* formField = [SZFormFieldVO formFieldValueObjectForTextWithKey:@"location"
																	 placeHolderText:@"City, ZIP or address"
																		keyboardType:UIKeyboardTypeDefault];
		[_locationForm addItem:formField showsClearButton:YES isLastItem:YES];
		[_locationForm setDelegate:self];
		[_locationForm setTextFieldWidth:155.0 xInset:5.0 forFieldAtIndex:0];
		CGRect frame = _locationForm.frame;
		frame.origin.x = 5.0;
		frame.origin.y = 81.0;
		_locationForm.frame = frame;
		[_locationForm setScrollContainer:self.scrollView];
		
	}
	return _locationForm;
}

- (UIButton*)currentLocationButton {
	if (_currentLocationButton == nil) {
		
		_currentLocationButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[_currentLocationButton setFrame:CGRectMake(167.0, 82.0, 43.0, 40.0)];
		[_currentLocationButton setImage:[UIImage imageNamed:@"button_current_location"] forState:UIControlStateNormal];
		[_currentLocationButton setImage:[UIImage imageNamed:@"button_current_location_selected"] forState:UIControlStateHighlighted];
		[_currentLocationButton addTarget:self action:@selector(applyCurrentLocation:) forControlEvents:UIControlEventTouchUpInside];
	}
	return _currentLocationButton;
}

- (void)applyCurrentLocation:(id)sender {
	[self.locationForm setText:@"Current Location" forFieldAtIndex:0];
	[self.locationForm.userInputs setValue:@"Current Location" forKey:@"location"];
	[[SZDataManager sharedInstance].searchLocationBase setValue:@"Current Location" forKey:@"textInput"];
	[self scrollViewTapped:nil];
}

- (void)formDidBeginEditing:(SZForm *)form {
	if (form == self.locationForm && [[form.userInputs valueForKey:@"location"] isEqualToString:@"Current Location"]) {
		[self.locationForm setText:@"" forFieldAtIndex:0];
		[self.locationForm.userInputs setValue:@"" forKey:@"location"];
	}
}

- (void)userRatingValueChanged:(UISlider*)slider {
	NSInteger roundedValue = roundf(slider.value * 5.0);
	[slider setValue:roundedValue/5.0 animated:NO];
	self.minimumUserRating = roundedValue;
	[self.userRatingLabel setText:roundedValue > 0 ? [NSString stringWithFormat:@"%i Stars", self.minimumUserRating] : @"doesn't matter"];
	
	[self.filterDict setValue:[NSNumber numberWithInt:self.minimumUserRating] forKey:@"minRating"];
}

- (void)priceRangeValueChanged:(NMRangeSlider*)slider {
	NSInteger lowerValue = (slider.lowerValue * 100);
	NSInteger upperValue = (slider.upperValue * 100);
	if (upperValue >= 99) upperValue += 1; // doing this to let people set 100 as maximum but still have room to the right for the 100+ value
	if (lowerValue != self.minimumPrice || upperValue != self.maximumPrice) {
		self.minimumPrice = lowerValue;
		self.maximumPrice = upperValue;
		NSInteger upper = self.maximumPrice == 101 ? 100 : self.maximumPrice;
		[self.priceLabel setText:[NSString stringWithFormat:@"%i - %i%@", self.minimumPrice, upper, self.maximumPrice == 101 ? @"+" : @""]];
	}
	
	[self.filterDict setValue:[NSNumber numberWithInt:self.minimumPrice] forKey:@"minPrice"];
	if (self.maximumPrice < 101) {
		[self.filterDict setValue:[NSNumber numberWithInt:self.maximumPrice] forKey:@"maxPrice"];
	}
	
	[self.priceLabel sizeToFit];
	CGRect frame = self.priceLabel.frame;
	frame.origin.x = 230.0 - frame.size.width - 30.0;
	self.priceLabel.frame = frame;
	frame = self.pointsIcon.frame;
    frame.origin.x = self.priceLabel.frame.origin.x - 25.0;
	self.pointsIcon.frame = frame;
	
}

- (void)radiusValueChanged:(UISlider*)slider {
	NSInteger roundedValue = powf(slider.value, 2) * 100;
	if (roundedValue >= 99) roundedValue += 1;
	if (roundedValue != self.maximusRadius) {
		self.maximusRadius = roundedValue;
		if (self.maximusRadius == 0) {
			[self.radiusLabel setText:@"up to 0.5 miles around:"];
		}
		else if (self.maximusRadius == 1) {
			[self.radiusLabel setText:@"up to 1 mile around:"];
		}
		else if (self.maximusRadius == 101) {
			[self.radiusLabel setText:@"100+ miles around:"];
		}
		else {
			[self.radiusLabel setText:[NSString stringWithFormat:@"up to %i miles around:", self.maximusRadius]];
		}
		if (self.maximusRadius <= 100) {
			[[SZDataManager sharedInstance].searchLocationBase setValue:[NSNumber numberWithInt:self.maximusRadius] forKey:@"radius"];
		}
	}
}

- (void)formDidEndEditing:(SZForm *)form {
	[[SZDataManager sharedInstance].searchLocationBase setValue:[form textForFieldAtIndex:0] forKey:@"textInput"];
}

- (SZButton*)filterButton {
	SZButton* button = [SZButton buttonWithColor:SZButtonColorPetrol size:SZButtonSizeLarge width:205.0];
	[button setTitle:@"Filter Results" forState:UIControlStateNormal];
	CGRect frame = button.frame;
	frame.origin.x = 15.0;
	frame.origin.y = 316.0;
	button.frame = frame;
	[button addTarget:self action:@selector(filter:) forControlEvents:UIControlEventTouchUpInside];
	return button;
}

- (SZButton*)cancelButton {
	SZButton* button = [SZButton buttonWithColor:SZButtonColorOrange size:SZButtonSizeLarge width:205.0];
	[button setTitle:@"Cancel" forState:UIControlStateNormal];
	CGRect frame = button.frame;
	frame.origin.x = 15.0;
	frame.origin.y = 366.0;
	button.frame = frame;
	[button addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
	return button;
}

- (void)scrollViewTapped:(id)sender {
	if (self.locationForm.isActive) {
		[self.locationForm resign:nil completion:nil];
	}
}

- (void)filter:(SZButton*)sender {
	[[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_FILTER object:nil userInfo:self.filterDict];
	[self toggle];
}

- (void)cancel:(SZButton*)sender {
	[self toggle];
}

- (UIView*)backgroundViewWithRect:(CGRect)rect {
	UIView* view = [[UIView alloc] initWithFrame:rect];
	[view setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.4]];
	view.layer.cornerRadius = 13.0;
	return view;
}

@end
