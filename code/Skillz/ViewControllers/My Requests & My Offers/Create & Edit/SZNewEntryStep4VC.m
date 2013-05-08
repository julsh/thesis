//
//  SZNewEntryStep4VC.m
//  Skillz
//
//  Created by Julia Roggatz on 25.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZNewEntryStep4VC.h"
#import "SZNewEntryStep5VC.h"
#import "SZSegmentedControlVertical.h"
#import "UITextView+Shadow.h"
#import "SZForm.h"
#import "SZUtils.h"

@interface SZNewEntryStep4VC ()

@property (nonatomic, strong) SZSegmentedControlVertical* segmentedControl;
@property (nonatomic, strong) UIView* option1detailView;
@property (nonatomic, strong) UIView* option2detailView;
@property (nonatomic, strong) UIView* option3detailView;
@property (nonatomic, strong) SZForm* hourPriceForm;
@property (nonatomic, strong) SZForm* jobPriceForm;

@end

@implementation SZNewEntryStep4VC

@synthesize segmentedControl = _segmentedControl;
@synthesize option1detailView = _option1detailView;
@synthesize option2detailView = _option2detailView;
@synthesize option3detailView = _option3detailView;

- (id)init {
    return [super initWithStepNumber:4 totalSteps:5];
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
	
	[self.mainView addSubview:[self specifyPriceLabel]];
	[self.mainView addSubview:self.segmentedControl];
	[self.mainView addSubview:self.detailViewContainer];
}

- (UILabel*)specifyPriceLabel {
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 60.0, 300.0, 30.0)];
	[label setBackgroundColor:[UIColor clearColor]];
	[label setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:16.0]];
	[label setTextColor:[SZGlobalConstants darkGray]];
	[label applyWhiteShadow];
	switch ([SZDataManager sharedInstance].currentEntryType) {
		case SZEntryTypeRequest:
			[label setText:@"How much are you willing to pay?"];
			break;
		case SZEntryTypeOffer:
			[label setText:@"How much do you want to be paid?"];
			break;
	}
	return label;
}

- (SZSegmentedControlVertical*)segmentedControl {
	if (_segmentedControl == nil) {
		_segmentedControl = [[SZSegmentedControlVertical alloc] initWithWidth:290.0];
		[_segmentedControl addItemWithText:@"That's negotiable." isLast:NO];
		[_segmentedControl addItemWithText:@"Fixed hourly rate" isLast:NO];
		[_segmentedControl addItemWithText:@"Fixed job-based rate" isLast:YES];
		[_segmentedControl setCenter:CGPointMake(160.0, 160.0)];
		[_segmentedControl setDelegate:self];
		
		if (![SZDataManager sharedInstance].currentEntryIsNew) {
			SZEntryObject* entry = (SZEntryObject*)[SZDataManager sharedInstance].currentEntry;
			_segmentedControl.selectedIndex = entry.priceType;
		}
	}
	return _segmentedControl;
}

- (UIView*)option1detailView {
	if (_option1detailView == nil) {
		_option1detailView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 290.0, 170.0)];
		
		UITextView* noticeText = [[UITextView alloc] initWithFrame:CGRectMake(0.0, 0.0, 290.0, 120.0)];
		[noticeText setTextAlignment:NSTextAlignmentJustified];
		[noticeText setBackgroundColor:[UIColor clearColor]];
		[noticeText setText:[NSString stringWithFormat:@"It might be helpful to give people a rough guidance in your %@ description on what you would consider a reasonable proposal.\nOf course, this is completely optional.", [SZDataManager sharedInstance].currentEntryType == SZEntryTypeRequest ? @"request" : @"offer"]];
		[noticeText setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:14.0]];
		[noticeText setTextColor:[SZGlobalConstants darkGray]];
		[noticeText applyWhiteShadow];
		[noticeText setScrollEnabled:NO];
		[noticeText setEditable:NO];
		
		SZButton* editButton = [SZButton buttonWithColor:SZButtonColorOrange size:SZButtonSizeLarge width:290.0];
		[editButton setTitle:@"Edit Description" forState:UIControlStateNormal];
		[editButton addTarget:self action:@selector(editDescription:) forControlEvents:UIControlEventTouchUpInside];
		[editButton setFrame:CGRectMake(0.0, 130.0, editButton.frame.size.width, editButton.frame.size.height)];
		
		[_option1detailView addSubview:noticeText];
		[_option1detailView addSubview:editButton];
	}
	return _option1detailView;
}

- (UIView*)option2detailView {
	if (_option2detailView == nil) {
		_option2detailView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 290.0, 83.0)];
		
		self.hourPriceForm = [[SZForm alloc] initWithWidth:60.0];
		[self.forms addObject:self.hourPriceForm];
		SZFormFieldVO* hourPriceField = [SZFormFieldVO formFieldValueObjectForTextWithKey:@"price" placeHolderText:@"15" keyboardType:UIKeyboardTypeDecimalPad];
		[self.hourPriceForm addItem:hourPriceField showsClearButton:NO isLastItem:YES];
		[self.hourPriceForm setScrollContainer:self.mainView];
		[self.hourPriceForm addKeyboardToolbar];
		[self.hourPriceForm setFrame:CGRectMake(16.0, 35.0, self.hourPriceForm.frame.size.width, self.hourPriceForm.frame.size.height)];
		
		UILabel* priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(86.0, 35.0, 220.0, 40.0)];
		[priceLabel setBackgroundColor:[UIColor clearColor]];
		[priceLabel setText:@"Skillpoints per hour"];
		[priceLabel setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:20.0]];
		[priceLabel setTextColor:[SZGlobalConstants darkGray]];
		[priceLabel applyWhiteShadow];
		
		[_option2detailView addSubview:self.hourPriceForm];
		[_option2detailView addSubview:priceLabel];
		
		if (![SZDataManager sharedInstance].currentEntryIsNew) {
			SZEntryObject* entry = (SZEntryObject*)[SZDataManager sharedInstance].currentEntry;
			if (entry.price) {
				[self.hourPriceForm.userInputs setValue:[NSString stringWithFormat:@"%i", [entry.price intValue]] forKey:@"price"];
				[self.hourPriceForm setText:[NSString stringWithFormat:@"%i", [entry.price intValue]] forFieldAtIndex:0];
			}
		}
		
	}
	return _option2detailView;
}

- (UIView*)option3detailView {
	if (_option3detailView == nil) {
		_option3detailView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 5.0, 290.0, 200.0)];
		
		self.jobPriceForm = [[SZForm alloc] initWithWidth:80.0];
		[self.forms addObject:self.jobPriceForm];
		SZFormFieldVO* jobPriceField = [SZFormFieldVO formFieldValueObjectForTextWithKey:@"price" placeHolderText:@"50" keyboardType:UIKeyboardTypeDecimalPad];
		[self.jobPriceForm addItem:jobPriceField showsClearButton:NO isLastItem:YES];
		[self.jobPriceForm setScrollContainer:self.mainView];
		[self.jobPriceForm addKeyboardToolbar];
		[self.jobPriceForm setFrame:CGRectMake(50.0, 0.0, self.jobPriceForm.frame.size.width, self.jobPriceForm.frame.size.height)];
		
		UILabel* priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(140.0, 0.0, 140.0, 40.0)];
		[priceLabel setBackgroundColor:[UIColor clearColor]];
		[priceLabel setText:@"Skillpoints"];
		[priceLabel setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:20.0]];
		[priceLabel setTextColor:[SZGlobalConstants darkGray]];
		[priceLabel applyWhiteShadow];
		
		UITextView* noticeText = [[UITextView alloc] initWithFrame:CGRectMake(0.0, 50.0, 290.0, 90.0)];
		[noticeText setTextAlignment:NSTextAlignmentJustified];
		[noticeText setBackgroundColor:[UIColor clearColor]];
		[noticeText setText:[NSString stringWithFormat:@"Please make sure your %@'s description contains sufficient infor-mation on what you expect from the deal.", [SZDataManager sharedInstance].currentEntryType == SZEntryTypeRequest ? @"request" : @"offer"]];
		[noticeText setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:14.0]];
		[noticeText setTextColor:[SZGlobalConstants darkGray]];
		[noticeText applyWhiteShadow];
		[noticeText setScrollEnabled:NO];
		[noticeText setEditable:NO];
		
		SZButton* editButton = [SZButton buttonWithColor:SZButtonColorOrange size:SZButtonSizeLarge width:290.0];
		[editButton setTitle:@"Edit Description" forState:UIControlStateNormal];
		[editButton addTarget:self action:@selector(editDescription:) forControlEvents:UIControlEventTouchUpInside];
		[editButton setFrame:CGRectMake(0.0, 155.0, editButton.frame.size.width, editButton.frame.size.height)];
		
		[_option3detailView addSubview:self.jobPriceForm];
		[_option3detailView addSubview:priceLabel];
		[_option3detailView addSubview:noticeText];
		[_option3detailView addSubview:editButton];
		
		if (![SZDataManager sharedInstance].currentEntryIsNew) {
			SZEntryObject* entry = (SZEntryObject*)[SZDataManager sharedInstance].currentEntry;
			if (entry.price) {
				[self.jobPriceForm.userInputs setValue:[NSString stringWithFormat:@"%i", [entry.price intValue]] forKey:@"price"];
				[self.jobPriceForm setText:[NSString stringWithFormat:@"%i", [entry.price intValue]] forFieldAtIndex:0];
			}
		}
		
		
	}
	return _option3detailView;
}

- (void)segmentedControlVertical:(SZSegmentedControlVertical *)control didSelectItemAtIndex:(NSInteger)index {
	
	SZForm* activeForm = nil;
	
	if (self.hourPriceForm.isActive) {
		activeForm = self.hourPriceForm;
	}
	else if (self.jobPriceForm.isActive) {
		activeForm = self.jobPriceForm;
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
			[self.detailViewContainer addSubview:self.option3detailView];
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
	
	NSLog(@"contentsize: %@", NSStringFromCGSize(self.mainView.contentSize));
}

- (void)continue:(id)sender {

#ifndef DEBUG
	if (self.segmentedControl.selectedIndex == -1) {
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Please select an option." message:nil delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
		[alertView show];
		return;
	}
	else if ((self.segmentedControl.selectedIndex == 1 && [[self.hourPriceForm.userInputs valueForKey:@"price"] isEqualToString:@""]) || (self.segmentedControl.selectedIndex == 2 && [[self.jobPriceForm.userInputs valueForKey:@"price"] isEqualToString:@""])) {
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Please set a price." message:nil delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
		[alertView show];
		return;
	}
#endif
	
	[self storeInputs];
	
	if ([[SZDataManager sharedInstance].viewControllerStack count] != 0)
		[self.navigationController pushViewController:[[SZDataManager sharedInstance].viewControllerStack pop] animated:YES];
	else
		[self.navigationController pushViewController:[[SZNewEntryStep5VC alloc] init] animated:YES];
}

- (void)storeInputs {
	
	[SZDataManager sharedInstance].currentEntry.priceType = self.segmentedControl.selectedIndex;
	if (self.segmentedControl.selectedIndex != SZEntryPriceNegotiable) {
		[SZDataManager sharedInstance].currentEntry.price = [SZUtils numberFromDecimalString:[self.hourPriceForm.userInputs valueForKey:@"price"]];
	}
}

@end
