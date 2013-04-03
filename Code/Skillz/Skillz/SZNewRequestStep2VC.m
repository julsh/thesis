//
//  SZNewRequestStep2VC.m
//  Skillz
//
//  Created by Julia Roggatz on 25.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZNewRequestStep2VC.h"
#import "SZNewRequestStep3VC.h"
#import "SZForm.h"
#import "UILabel+Shadow.h"

@interface SZNewRequestStep2VC ()

@property (nonatomic, strong) SZForm* titleForm;
@property (nonatomic, strong) SZForm* descriptionForm;

@end

@implementation SZNewRequestStep2VC

@synthesize titleForm = _titleForm;
@synthesize descriptionForm = _descriptionForm;

- (id)init
{
    return [super initWithStepNumber:2 totalSteps:5];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.navigationItem setTitle:[SZDataManager sharedInstance].currentObjectIsNew ? @"Post a Request" : @"Edit Request"];
	
	[self.mainView addSubview:[self addTitleLabel]];
	[self.mainView addSubview:self.titleForm];
	[self.mainView addSubview:[self addDescriptionLabel]];
	[self.mainView addSubview:self.descriptionForm];
}

- (void)viewDidAppear:(BOOL)animated {
	if (![((SZEntryVO*)[SZDataManager sharedInstance].currentObject).description isEqualToString:@""]) {
		[self.descriptionForm setText:((SZEntryVO*)[SZDataManager sharedInstance].currentObject).description forFieldAtIndex:0];
	}
}

- (UILabel*)addTitleLabel {
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 60.0, 300.0, 30.0)];
	[label setBackgroundColor:[UIColor clearColor]];
	[label setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:16.0]];
	[label setTextColor:[SZGlobalConstants darkGray]];
	[label applyWhiteShadow];
	[label setText:@"Add a title for your request:"];
	return label;
}

- (SZForm*)titleForm {
	if (_titleForm == nil) {
		_titleForm = [[SZForm alloc] initWithWidth:290.0];
		SZFormFieldVO* titleField = [SZFormFieldVO formFieldValueObjectForTextWithKey:@"title"
																	  placeHolderText:@"Request Title"
																		 keyboardType:UIKeyboardTypeDefault];
		[_titleForm addItem:titleField isLastItem:YES];
		[_titleForm setCenter:CGPointMake(160.0, 120.0)];
		[_titleForm configureKeyboard];
		[_titleForm setScrollContainer:self.view];
		
		if (![SZDataManager sharedInstance].currentObjectIsNew) {
			SZEntryVO* request = (SZEntryVO*)[SZDataManager sharedInstance].currentObject;
			if (request.title) {
				[_titleForm.userInputs setValue:request.title forKey:@"title"];
				[_titleForm setText:request.title forFieldAtIndex:0];
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
	[label setText:@"Describe your request:"];
	return label;
}

- (SZForm*)descriptionForm {
	if (_descriptionForm == nil) {
		SZFormFieldVO* descriptionField = [[SZFormFieldVO alloc] init];
		descriptionField.key = @"description";
		_descriptionForm = [[SZForm alloc] initForTextViewWithItem:descriptionField width:290.0 height:140.0];
		[_descriptionForm setCenter:CGPointMake(160.0, 270.0)];
		[_descriptionForm setScrollContainer:self.view];
		
		if (![SZDataManager sharedInstance].currentObjectIsNew) {
			SZEntryVO* request = (SZEntryVO*)[SZDataManager sharedInstance].currentObject;
			if (request.description) {
				[_descriptionForm.userInputs setValue:request.description forKey:@"description"];
				[_descriptionForm setText:request.description forFieldAtIndex:0];
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
		[self.navigationController pushViewController:[[SZNewRequestStep3VC alloc] init] animated:YES];
}

- (void)storeInputs {
	((SZEntryVO*)[SZDataManager sharedInstance].currentObject).title = [self.titleForm.userInputs valueForKey:@"title"];
	((SZEntryVO*)[SZDataManager sharedInstance].currentObject).description = [self.descriptionForm.userInputs valueForKey:@"description"];
}

@end
