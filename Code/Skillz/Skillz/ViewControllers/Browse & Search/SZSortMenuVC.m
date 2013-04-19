//
//  SZSortMenuVC.m
//  Skillz
//
//  Created by Julia Roggatz on 18.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZSortMenuVC.h"
#import "SZButton.h"

@interface SZSortMenuVC ()

@property (nonatomic, strong) SZSegmentedControlVertical* sortControl;
@property (nonatomic, strong) UISegmentedControl* arrangeControl;
@property (nonatomic, strong) SZForm* locationForm;
@property (nonatomic, strong) UIButton* currentLocationButton;

@end

@implementation SZSortMenuVC

@synthesize sortControl = _sortControl;
@synthesize arrangeControl = _arrangeControl;
@synthesize locationForm = _locationForm;
@synthesize currentLocationButton = _currentLocationButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setTitle:@"Sort Results"];
	
	[self.scrollView addSubview:[self sortLabel]];
	[self.scrollView addSubview:self.sortControl];
	[self.scrollView addSubview:[self arrangeLabel]];
	[self.scrollView addSubview:self.arrangeControl];
	[self.scrollView addSubview:[self locationLabel]];
	[self.scrollView addSubview:self.locationForm];
	[self.scrollView addSubview:self.currentLocationButton];
	[self.scrollView addSubview:[self sortButton]];
	[self.scrollView addSubview:[self cancelButton]];
}

- (UILabel*)sortLabel {
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 5.0, 180.0, 20.0)];
	[label setFont:[SZGlobalConstants fontWithFontType:SZFontBold size:14.0]];
	[label setTextColor:[SZGlobalConstants darkPetrol]];
	[label applyWhiteShadow];
	[label setText:@"Sort By:"];
	return label;
}

- (SZSegmentedControlVertical*)sortControl {
	if (_sortControl == nil) {
		_sortControl = [[SZSegmentedControlVertical alloc] initWithWidth:205.0];
		[_sortControl addItemWithText:@"User Rating" isLast:NO];
		[_sortControl addItemWithText:@"Price" isLast:NO];
		[_sortControl addItemWithText:@"Distance" isLast:YES];
		[_sortControl setDelegate:self];
		[_sortControl selectItemWithIndex:0];
		CGRect frame = _sortControl.frame;
		frame.origin.x = 15.0;
		frame.origin.y = 30.0;
		_sortControl.frame = frame;
	}
	return _sortControl;
}

- (UILabel*)arrangeLabel {
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 156.0, 150.0, 20.0)];
	[label setFont:[SZGlobalConstants fontWithFontType:SZFontBold size:14.0]];
	[label setTextColor:[SZGlobalConstants darkPetrol]];
	[label applyWhiteShadow];
	[label setText:@"Arrange By:"];
	return label;
}

- (UISegmentedControl*)arrangeControl {
	if (_arrangeControl == nil) {
		
		_arrangeControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(15.0, 181.0, 205.0, 40.0)];
		[_arrangeControl insertSegmentWithTitle:@"Low To High" atIndex:0 animated:NO];
		[_arrangeControl insertSegmentWithTitle:@"High To Low" atIndex:1 animated:NO];
		
		[_arrangeControl setBackgroundImage:[[UIImage imageNamed:@"segmented_control_deselected"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 25.0, 0.0, 25.0)]
									  forState:UIControlStateNormal
									barMetrics:UIBarMetricsDefault];
		
		[_arrangeControl setBackgroundImage:[[UIImage imageNamed:@"segmented_control_selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 25.0, 0.0, 25.0)]
									  forState:UIControlStateSelected
									barMetrics:UIBarMetricsDefault];
		
		[_arrangeControl setDividerImage:[UIImage imageNamed:@"segmented_control_left_selected"]
						forLeftSegmentState:UIControlStateSelected
						  rightSegmentState:UIControlStateNormal
								 barMetrics:UIBarMetricsDefault];
		[_arrangeControl setDividerImage:[UIImage imageNamed:@"segmented_control_right_selected"]
						forLeftSegmentState:UIControlStateNormal
						  rightSegmentState:UIControlStateSelected
								 barMetrics:UIBarMetricsDefault];
		
		[_arrangeControl setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:													[UIColor grayColor], UITextAttributeTextColor,
													[UIColor whiteColor], UITextAttributeTextShadowColor,
													[NSValue valueWithUIOffset:UIOffsetMake(0.0, 1.0)], UITextAttributeTextShadowOffset,
													[SZGlobalConstants fontWithFontType:SZFontBold size:12.0], UITextAttributeFont, nil]
										  forState:UIControlStateNormal];
		
		[_arrangeControl setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
													[UIColor whiteColor], UITextAttributeTextColor,
													[UIColor blackColor], UITextAttributeTextShadowColor,
													[NSValue valueWithUIOffset:UIOffsetMake(0.0, -1.0)], UITextAttributeTextShadowOffset,
													[SZGlobalConstants fontWithFontType:SZFontBold size:12.0], UITextAttributeFont, nil]
										  forState:UIControlStateSelected];
		
		
		[_arrangeControl setSelectedSegmentIndex:0];
		
		
	}
	return _arrangeControl;
}

- (UILabel*)locationLabel {
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 231.0, 180.0, 20.0)];
	[label setFont:[SZGlobalConstants fontWithFontType:SZFontBold size:14.0]];
	[label setTextColor:[SZGlobalConstants darkPetrol]];
	[label applyWhiteShadow];
	[label setText:@"If Sorting By Distance:"];
	return label;
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
		frame.origin.x = 15.0;
		frame.origin.y = 256.0;
		_locationForm.frame = frame;
		[_locationForm setScrollContainer:self.scrollView];
	}
	return _locationForm;
}

- (UIButton*)currentLocationButton {
	if (_currentLocationButton == nil) {
		
		_currentLocationButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[_currentLocationButton setFrame:CGRectMake(177.0, 257.0, 43.0, 40.0)];
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

- (SZButton*)sortButton {
	SZButton* button = [[SZButton alloc] initWithColor:SZButtonColorPetrol size:SZButtonSizeLarge width:205.0];
	[button setTitle:@"Sort Results" forState:UIControlStateNormal];
	CGRect frame = button.frame;
	frame.origin.x = 15.0;
	frame.origin.y = 316.0;
	button.frame = frame;
	[button addTarget:self action:@selector(sort:) forControlEvents:UIControlEventTouchUpInside];
	return button;
}

- (SZButton*)cancelButton {
	SZButton* button = [[SZButton alloc] initWithColor:SZButtonColorOrange size:SZButtonSizeLarge width:205.0];
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

- (void)segmentedControlVertical:(SZSegmentedControlVertical *)control didSelectItemAtIndex:(NSInteger)index {
	NSLog(@"selected %i", control.selectedIndex);
}

- (void)sort:(SZButton*)sender {
	NSLog(@"sort");
}

- (void)cancel:(SZButton*)sender {
	NSLog(@"cancel");
}

@end
