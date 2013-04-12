//
//  SZNewEntryStep2VC.m
//  Skillz
//
//  Created by Julia Roggatz on 25.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZNewEntryStep2VC.h"
#import "SZNewEntryStep3VC.h"
#import "SZForm.h"
#import "UILabel+Shadow.h"

@interface SZNewEntryStep2VC ()

@property (nonatomic, strong) SZForm* titleForm;
@property (nonatomic, strong) SZForm* descriptionForm;

@end

@implementation SZNewEntryStep2VC

@synthesize titleForm = _titleForm;
@synthesize descriptionForm = _descriptionForm;

- (id)init
{
    return [super initWithStepNumber:2 totalSteps:5];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	switch ([SZDataManager sharedInstance].currentEntryType) {
		case SZEntryTypeRequest:
			[self.navigationItem setTitle:[SZDataManager sharedInstance].currentEntryIsNew ? @"Post a Request" : @"Edit Request"];
			break;
		case SZEntryTypeOffer:
			[self.navigationItem setTitle:[SZDataManager sharedInstance].currentEntryIsNew ? @"Post an Offer" : @"Edit Offer"];
			break;
	}
	
	[self.mainView addSubview:[self addTitleLabel]];
	[self.mainView addSubview:self.titleForm];
	[self.mainView addSubview:[self addDescriptionLabel]];
	[self.mainView addSubview:self.descriptionForm];
}

- (void)viewDidAppear:(BOOL)animated {
	if (![((SZEntryVO*)[SZDataManager sharedInstance].currentEntry).description isEqualToString:@""]) {
		[self.descriptionForm setText:((SZEntryVO*)[SZDataManager sharedInstance].currentEntry).description forFieldAtIndex:0];
	}
}

- (UILabel*)addTitleLabel {
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 60.0, 300.0, 30.0)];
	[label setBackgroundColor:[UIColor clearColor]];
	[label setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:16.0]];
	[label setTextColor:[SZGlobalConstants darkGray]];
	[label applyWhiteShadow];
	
	switch ([SZDataManager sharedInstance].currentEntryType) {
		case SZEntryTypeRequest:
			[label setText:@"Add a title for your request:"];
			break;
		case SZEntryTypeOffer:
			[label setText:@"Add a title for your offer:"];
			break;
	}
	
	return label;
}

- (SZForm*)titleForm {
	if (_titleForm == nil) {
		_titleForm = [[SZForm alloc] initWithWidth:290.0];
		[self.forms addObject:_titleForm];
		
		NSString* placeHolderText;
		switch ([SZDataManager sharedInstance].currentEntryType) {
			case SZEntryTypeRequest:
				placeHolderText = @"Request Title";
				break;
			case SZEntryTypeOffer:
				placeHolderText = @"Offer Title";
				break;
		}
		
		SZFormFieldVO* titleField = [SZFormFieldVO formFieldValueObjectForTextWithKey:@"title"
																	  placeHolderText:placeHolderText
																		 keyboardType:UIKeyboardTypeDefault];
		[_titleForm addItem:titleField showsClearButton:YES isLastItem:YES];
		[_titleForm setCenter:CGPointMake(160.0, 120.0)];
		[_titleForm configureKeyboard];
		[_titleForm setScrollContainer:self.mainView];
		
		if (![SZDataManager sharedInstance].currentEntryIsNew) {
			SZEntryVO* entry = (SZEntryVO*)[SZDataManager sharedInstance].currentEntry;
			if (entry.title) {
				[_titleForm.userInputs setValue:entry.title forKey:@"title"];
				[_titleForm setText:entry.title forFieldAtIndex:0];
			}
		}
	}
	return _titleForm;
}

- (UILabel*)addDescriptionLabel {
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 160.0, 300.0, 30.0)];
	[label setBackgroundColor:[UIColor clearColor]];
	[label setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:16.0]];
	[label setTextColor:[SZGlobalConstants darkGray]];
	[label applyWhiteShadow];
	switch ([SZDataManager sharedInstance].currentEntryType) {
		case SZEntryTypeRequest:
			[label setText:@"Describe your request:"];
			break;
		case SZEntryTypeOffer:
			[label setText:@"Describe your offer:"];
			break;
	}
	return label;
}

- (SZForm*)descriptionForm {
	if (_descriptionForm == nil) {
		SZFormFieldVO* descriptionField = [[SZFormFieldVO alloc] init];
		descriptionField.key = @"description";
		_descriptionForm = [[SZForm alloc] initForTextViewWithItem:descriptionField width:290.0 height:140.0];
		[self.forms addObject:_descriptionForm];
		[_descriptionForm setCenter:CGPointMake(160.0, 270.0)];
		[_descriptionForm setScrollContainer:self.mainView];
		
		if (![SZDataManager sharedInstance].currentEntryIsNew) {
			SZEntryVO* entry = (SZEntryVO*)[SZDataManager sharedInstance].currentEntry;
			if (entry.description) {
				[_descriptionForm.userInputs setValue:entry.description forKey:@"description"];
				[_descriptionForm setText:entry.description forFieldAtIndex:0];
			}
		}
	}
	return _descriptionForm;
}

- (void)continue:(id)sender {

#ifndef DEBUG
	if ([[self.titleForm.userInputs valueForKey:@"title"] isEqualToString:@""]) {
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Title must be specified" message:nil delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
		[alertView show];
		return;
	}
	if ([[self.descriptionForm.userInputs valueForKey:@"description"] isEqualToString:@""]) {
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Description must be specified" message:nil delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
		[alertView show];
		return;
	}
#endif
	
	[self storeInputs];
	
	if ([[SZDataManager sharedInstance].viewControllerStack count] != 0)
		[self.navigationController pushViewController:[[SZDataManager sharedInstance].viewControllerStack pop] animated:YES];
	else
		[self.navigationController pushViewController:[[SZNewEntryStep3VC alloc] init] animated:YES];
}

- (void)storeInputs {
	((SZEntryVO*)[SZDataManager sharedInstance].currentEntry).title = [self.titleForm.userInputs valueForKey:@"title"];
	((SZEntryVO*)[SZDataManager sharedInstance].currentEntry).description = [self.descriptionForm.userInputs valueForKey:@"description"];
}

@end
