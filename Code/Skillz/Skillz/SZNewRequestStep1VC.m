//
//  SZNewRequestStep1VC.m
//  Skillz
//
//  Created by Julia Roggatz on 25.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <Parse/Parse.h>

#import "SZNewRequestStep1VC.h"
#import "SZNewRequestStep2VC.h"
#import "SZForm.h"

@interface SZNewRequestStep1VC ()

@property (nonatomic, strong) SZForm* categoryForm;
@property (nonatomic, strong) SZForm* subCategoryForm;

@end

@implementation SZNewRequestStep1VC

@synthesize categoryForm = _categoryForm;
@synthesize subCategoryForm = _subCategoryForm;

- (id)initWithRequest:(SZEntryVO*)request
{
	self = [super initWithStepNumber:1 totalSteps:5];
	if (self) {
		if (request) {
			[[SZDataManager sharedInstance] setCurrentObject:request];
			[[SZDataManager sharedInstance] setCurrentObjectIsNew:NO];
		}
		else {
			SZEntryVO* newRequest = [[SZEntryVO alloc] init];
			newRequest.user = [SZDataManager sharedInstance].currentUser;
			[[SZDataManager sharedInstance] setCurrentObject:newRequest];
			[[SZDataManager sharedInstance] setCurrentObjectIsNew:YES];
		}
	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.navigationItem setTitle:[SZDataManager sharedInstance].currentObjectIsNew ? @"Post a Request" : @"Edit Request"];
	
	[self.mainView addSubview:[self selectCategoryLabel]];
	[self.mainView addSubview:self.categoryForm];
	[self.mainView addSubview:[self selectSubCategoryLabel]];
	[self.mainView addSubview:self.subCategoryForm];
}

- (UILabel*)selectCategoryLabel {
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 90.0, 200.0, 30.0)];
	[label setBackgroundColor:[UIColor clearColor]];
	[label setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:16.0]];
	[label setTextColor:[SZGlobalConstants darkGray]];
	[label applyWhiteShadow];
	[label setText:@"Select a category:"];
	return label;
}

- (SZForm*)categoryForm {
	if (_categoryForm == nil) {
		_categoryForm = [[SZForm alloc] initWithWidth:290.0];
		// TODO get real categories
		NSArray* choices = [NSArray arrayWithObjects:@"Household", @"Childcare", @"Computer Help", @"Blablabla", nil];
		SZFormFieldVO* categoryField = [SZFormFieldVO formFieldValueObjectForPickerWithKey:@"category"
																		   placeHolderText:@"Category"
																			 pickerOptions:choices];
		[_categoryForm addItem:categoryField isLastItem:YES];
		[_categoryForm setCenter:CGPointMake(160.0, 150.0)];
		[_categoryForm configureKeyboard];
		[_categoryForm setScrollContainer:self.view];
		
		if (![SZDataManager sharedInstance].currentObjectIsNew) {
			SZEntryVO* request = (SZEntryVO*)[SZDataManager sharedInstance].currentObject;
			if (request.category) {
				[_categoryForm.userInputs setValue:request.category forKey:@"category"];
				[_categoryForm setText:request.category forFieldAtIndex:0];
				[_categoryForm updatePickerAtIndex:0];
			}
		}
	}
	return _categoryForm;
}

- (UILabel*)selectSubCategoryLabel {
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 200.0, 300.0, 30.0)];
	[label setBackgroundColor:[UIColor clearColor]];
	[label setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:16.0]];
	[label setTextColor:[SZGlobalConstants darkGray]];
	[label applyWhiteShadow];
	[label setText:@"Select a subcategory (optional):"];
	return label;
}

- (SZForm*)subCategoryForm {
	if (_subCategoryForm == nil) {
		_subCategoryForm = [[SZForm alloc] initWithWidth:290.0];
		NSArray* choices = [NSArray arrayWithObjects:@"Household", @"Childcare", @"Computer Help", @"Blablabla", nil]; // TODO get real categories
		SZFormFieldVO* subCategoryField = [SZFormFieldVO formFieldValueObjectForPickerWithKey:@"subcategory"
																		   placeHolderText:@"Subcategory"
																			 pickerOptions:choices];
		[_subCategoryForm addItem:subCategoryField isLastItem:YES];
		[_subCategoryForm setCenter:CGPointMake(160.0, 260.0)];
		[_subCategoryForm configureKeyboard];
		[_subCategoryForm setScrollContainer:self.view];
		
		if (![SZDataManager sharedInstance].currentObjectIsNew) {
			SZEntryVO* request = (SZEntryVO*)[SZDataManager sharedInstance].currentObject;
			if (request.subcategory) {
				[_subCategoryForm.userInputs setValue:request.subcategory forKey:@"subcategory"];
				[_subCategoryForm setText:request.subcategory forFieldAtIndex:0];
				[_subCategoryForm updatePickerAtIndex:0];
			}
		}
	}
	return _subCategoryForm;
}

- (void)continue:(id)sender {
	
#ifndef DEBUG
	if ([[self.categoryForm.userInputs valueForKey:@"category"] isEqualToString:@""]) {
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Category must be specified" message:nil delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: nil];
		[alertView show];
		return;
	}
#endif
	
	[self storeInputs];
	
	if ([[SZDataManager sharedInstance].viewControllerStack count] != 0)
		[self.navigationController pushViewController:[[SZDataManager sharedInstance].viewControllerStack pop] animated:YES];
	else
		[self.navigationController pushViewController:[[SZNewRequestStep2VC alloc] init] animated:YES];
}
		
- (void)storeInputs {
	// store the inputs
	((SZEntryVO*)[SZDataManager sharedInstance].currentObject).category = [self.categoryForm.userInputs valueForKey:@"category"];
	if (![[self.subCategoryForm.userInputs valueForKey:@"subcategory"] isEqualToString:@""]) {
		((SZEntryVO*)[SZDataManager sharedInstance].currentObject).subcategory = [self.subCategoryForm.userInputs valueForKey:@"subcategory"];
	}
	else {
		((SZEntryVO*)[SZDataManager sharedInstance].currentObject).subcategory = nil;
	}
}

@end
