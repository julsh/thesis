//
//  SZNewRequestStep5VC.m
//  Skillz
//
//  Created by Julia Roggatz on 25.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZNewRequestStep5VC.h"
#import "SZNewRequestConfirmVC.h"
#import "SZUtils.h"

@interface SZNewRequestStep5VC ()

@property (nonatomic, strong) SZSegmentedControlVertical* segmentedControl;
@property (nonatomic, strong) SZForm* option1detailView;

@end

@implementation SZNewRequestStep5VC

@synthesize segmentedControl = _segmentedControl;
@synthesize option1detailView = _option1detailView;

- (id)init
{
    return [super initWithStepNumber:5 totalSteps:5];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.navigationItem setTitle:[SZDataManager sharedInstance].currentObjectIsNew ? @"Post a Request" : @"Edit Request"];
	
	[self.mainView addSubview:[self specifyTimeFrameLabel]];
	[self.mainView addSubview:self.segmentedControl];
	[self.mainView addSubview:self.detailViewContainer];
}

- (UILabel*)specifyTimeFrameLabel {
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 60.0, 300.0, 60.0)];
	[label setNumberOfLines:0];
	[label setLineBreakMode:NSLineBreakByWordWrapping];
	[label setBackgroundColor:[UIColor clearColor]];
	[label setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:16.0]];
	[label setTextColor:[SZGlobalConstants darkGray]];
	[label applyWhiteShadow];
	[label setText:@"Do you want to set a specific time frame for your request?"];
	return label;
}

- (SZSegmentedControlVertical*)segmentedControl {
	if (_segmentedControl == nil) {
		_segmentedControl = [[SZSegmentedControlVertical alloc] initWithWidth:290.0];
		[_segmentedControl addItemWithText:@"Yes." isLast:NO];
		[_segmentedControl addItemWithText:@"No, the timing is flexible." isLast:YES];
		[_segmentedControl setCenter:CGPointMake(160.0, 165.0)];
		[_segmentedControl setDelegate:self];
		
		if (![SZDataManager sharedInstance].currentObjectIsNew) {
			SZEntryVO* request = (SZEntryVO*)[SZDataManager sharedInstance].currentObject;
			
			if (request.hasTimeFrame) {
				[_segmentedControl selectItemWithIndex:0];
				[_segmentedControl.delegate segmentedControlVertical:_segmentedControl didSelectItemAtIndex:0];
			}
			else {
				[_segmentedControl selectItemWithIndex:1];
				[_segmentedControl.delegate segmentedControlVertical:_segmentedControl didSelectItemAtIndex:1];
			}
		}
	}
	return _segmentedControl;
}

- (SZForm*)option1detailView {
	if (_option1detailView == nil) {
		_option1detailView = [[SZForm alloc] initWithWidth:290.0];
		[_option1detailView setDelegate:self];
		
		SZFormFieldVO* fromField = [SZFormFieldVO formFieldValueObjectForDatePickerWithKey:@"fromDate" placeHolderText:@"From" datePickerMode:UIDatePickerModeDateAndTime];
		SZFormFieldVO* toField = [SZFormFieldVO formFieldValueObjectForDatePickerWithKey:@"toDate" placeHolderText:@"To" datePickerMode:UIDatePickerModeDateAndTime];
		
		[_option1detailView addItem:fromField isLastItem:NO];
		[_option1detailView addItem:toField isLastItem:YES];
		[_option1detailView setScrollContainer:self.view];
		[_option1detailView configureKeyboard];
		
		[_option1detailView setFrame:CGRectMake(0.0, 10.0, _option1detailView.frame.size.width, _option1detailView.frame.size.height)];
		
		if (![SZDataManager sharedInstance].currentObjectIsNew) {
			SZEntryVO* request = (SZEntryVO*)[SZDataManager sharedInstance].currentObject;
			if (request.startTime) {
				[_option1detailView.userInputs setValue:request.startTime forKey:@"fromDate"];
				[_option1detailView updateDatePickerAtIndex:0 withDate:request.startTime];
			}
			if (request.endTime) {
				[_option1detailView.userInputs setValue:request.endTime forKey:@"toDate"];
				[_option1detailView updateDatePickerAtIndex:1 withDate:request.endTime];
			}
		}
		
	}
	return _option1detailView;
}

- (void)addNewDetailView:(NSInteger)index {
	
	switch (index) {
		case 0:
			[self.detailViewContainer addSubview:self.option1detailView];
			break;
		default:
			break;
	}
	
	if ([SZDataManager sharedInstance].currentObjectIsNew) {
		[super newDetailViewAddedAnimated:YES];
	}
	else {
		[super newDetailViewAddedAnimated:NO];
		[self.mainView setContentOffset:CGPointMake(0.0, 0.0)];
	}
}

- (BOOL)form:(SZForm*)form didConfirmDatePicker:(UIDatePicker*)datePicker {
	if ([[datePicker date] compare:[NSDate date]] == NSOrderedAscending) {
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Invalid Date" message:@"The time you selected is in the past." delegate:nil cancelButtonTitle:@"Oops!" otherButtonTitles:nil];
		[alertView show];
		return false;
	}
	else if ((datePicker.tag == 1 && [[datePicker date] compare:[self.option1detailView.userInputs valueForKey:@"fromDate"]] == NSOrderedAscending) || (datePicker.tag == 0 && [[datePicker date] compare:[self.option1detailView.userInputs valueForKey:@"toDate"]] == NSOrderedDescending)) {
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Invalid Date" message:@"The time you selected as the end time must be after the time you selected as the start time." delegate:nil cancelButtonTitle:@"Oops!" otherButtonTitles:nil];
		[alertView show];
		return false;
	}
	else if ((datePicker.tag == 1 && [[datePicker date] compare:[self.option1detailView.userInputs valueForKey:@"fromDate"]] == NSOrderedSame) || (datePicker.tag == 0 && [[datePicker date] compare:[self.option1detailView.userInputs valueForKey:@"toDate"]] == NSOrderedSame)) {
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Invalid Date" message:@"The times you selected as the start and end times are exactly the same. That's a pretty tight time frame :-)" delegate:nil cancelButtonTitle:@"Oops!" otherButtonTitles:nil];
		[alertView show];
		return false;
	}
	
	return true;
}

- (void)continue:(id)sender {
	
#ifndef DEBUG
	if (self.segmentedControl.selectedIndex == -1) {
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Please select an option." message:nil delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
		[alertView show];
		return;
	}
	else if (self.segmentedControl.selectedIndex == 0 && ([self.option1detailView.userInputs valueForKey:@"fromDate"] == [NSNull null] || [self.option1detailView.userInputs valueForKey:@"toDate"] == [NSNull null])) {
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"You have chosen to specify a time frame." message:@"Please specify the start and end times. If you don't want a time frame for your request, simply select the \"No, the timing is flexible\" option." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
		[alertView show];
		return;
	}
#endif
	
	
	[self storeInputs];
	
	[self.navigationController pushViewController:[[SZNewRequestConfirmVC alloc] init] animated:YES];
	
}

- (void)storeInputs {
	if (self.segmentedControl.selectedIndex == 0) {
		((SZEntryVO*)[SZDataManager sharedInstance].currentObject).hasTimeFrame = YES;
		((SZEntryVO*)[SZDataManager sharedInstance].currentObject).startTime = [self.option1detailView.userInputs valueForKey:@"fromDate"];
		((SZEntryVO*)[SZDataManager sharedInstance].currentObject).endTime = [self.option1detailView.userInputs valueForKey:@"fromDate"];
	}
	else {
		((SZEntryVO*)[SZDataManager sharedInstance].currentObject).hasTimeFrame = NO;
		((SZEntryVO*)[SZDataManager sharedInstance].currentObject).startTime = nil;
		((SZEntryVO*)[SZDataManager sharedInstance].currentObject).endTime = nil;
	}
}

@end
