//
//  SZNewEntryStep1VC.m
//  Skillz
//
//  Created by Julia Roggatz on 25.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <Parse/Parse.h>

#import "SZNewEntryStep1VC.h"
#import "SZNewEntryStep2VC.h"

@interface SZNewEntryStep1VC ()

@property (nonatomic, strong) SZForm* categoryForm;
@property (nonatomic, strong) SZForm* subCategoryForm;

@end

@implementation SZNewEntryStep1VC

@synthesize categoryForm = _categoryForm;
@synthesize subCategoryForm = _subCategoryForm;

- (id)initWithEntry:(SZEntryVO*)entry
{
	self = [super initWithStepNumber:1 totalSteps:5];
	if (self) {
		if (entry) {
			[[SZDataManager sharedInstance] setCurrentEntry:entry];
			[[SZDataManager sharedInstance] setCurrentEntryIsNew:NO];
		}
		else {
			SZEntryVO* newEntry = [[SZEntryVO alloc] init];
			newEntry.user = [SZDataManager sharedInstance].currentUser;
			[[SZDataManager sharedInstance] setCurrentEntry:newEntry];
			[[SZDataManager sharedInstance] setCurrentEntryIsNew:YES];
		}
	}
	return self;
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
		[_categoryForm setDelegate:self];
		
		NSMutableArray* choices = [[NSMutableArray alloc] init];
		NSArray* categoriesArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"categories"];
		for (NSDictionary* categoryDict in categoriesArray) {
			[choices addObject:[categoryDict objectForKey:@"categoryName"]];
		}
		NSMutableArray* sortedChoices = [NSMutableArray arrayWithArray:[choices sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
		[sortedChoices removeObject:@"Miscellaneous"]; // remove the "misc" category from somewhere in the middle of the array
		[sortedChoices addObject:@"Miscellaneous"];    // and put it back at the end. "misc" should not be in alphabetical order.
		SZFormFieldVO* categoryField = [SZFormFieldVO formFieldValueObjectForPickerWithKey:@"category"
																		   placeHolderText:@"Category"
																			 pickerOptions:sortedChoices];
		[_categoryForm addItem:categoryField isLastItem:YES];
		[_categoryForm setCenter:CGPointMake(160.0, 150.0)];
		[_categoryForm configureKeyboard];
		[_categoryForm setScrollContainer:self.view];
		
		if (![SZDataManager sharedInstance].currentEntryIsNew) {
			SZEntryVO* entry = (SZEntryVO*)[SZDataManager sharedInstance].currentEntry;
			if (entry.category) {
				[_categoryForm.userInputs setValue:entry.category forKey:@"category"];
				[_categoryForm setText:entry.category forFieldAtIndex:0];
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
		
		SZFormFieldVO* subCategoryField = [SZFormFieldVO formFieldValueObjectForPickerWithKey:@"subcategory"
																		   placeHolderText:@"Subcategory"
																			 pickerOptions:nil];
		[_subCategoryForm addItem:subCategoryField isLastItem:YES];
		[_subCategoryForm setCenter:CGPointMake(160.0, 260.0)];
		[_subCategoryForm configureKeyboard];
		[_subCategoryForm setScrollContainer:self.view];
		
		if (![SZDataManager sharedInstance].currentEntryIsNew) {
			SZEntryVO* entry = (SZEntryVO*)[SZDataManager sharedInstance].currentEntry;
			NSMutableArray* choices = [NSMutableArray arrayWithObject:@"(no subcategory)"];
			NSArray* categoriesArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"categories"];
			for (NSDictionary* categoryDict in categoriesArray) {
				if ([[categoryDict valueForKey:@"categoryName"] isEqualToString:entry.category]) {
					[choices addObjectsFromArray:[[categoryDict valueForKey:@"subcategories"] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
					break;
				}
			}
			[self.subCategoryForm updatePickerOptions:choices forPickerAtIndex:0];
			if (entry.subcategory) {
				[self.subCategoryForm setText:entry.subcategory forFieldAtIndex:0];
				[self.subCategoryForm updatePickerAtIndex:0];
			}
		}
		else {
			[_subCategoryForm setUserInteractionEnabled:NO];
		}
	}
	return _subCategoryForm;
}

- (void)form:(SZForm *)form didConfirmPicker:(UIPickerView *)picker {
	
	NSMutableArray* choices = [NSMutableArray arrayWithObject:@"(no subcategory)"];
	NSArray* categoriesArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"categories"];
	for (NSDictionary* categoryDict in categoriesArray) {
		if ([[categoryDict valueForKey:@"categoryName"] isEqualToString:[form.userInputs valueForKey:@"category"]]) {
			[choices addObjectsFromArray:[[categoryDict valueForKey:@"subcategories"] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
			break;
		}
	}
	[self.subCategoryForm updatePickerOptions:choices forPickerAtIndex:0];
	[self.subCategoryForm setUserInteractionEnabled:YES];
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
		[self.navigationController pushViewController:[[SZNewEntryStep2VC alloc] init] animated:YES];
}
		
- (void)storeInputs {
	// store the inputs
	((SZEntryVO*)[SZDataManager sharedInstance].currentEntry).category = [self.categoryForm.userInputs valueForKey:@"category"];
	if (![[self.subCategoryForm.userInputs valueForKey:@"subcategory"] isEqualToString:@""]) {
		((SZEntryVO*)[SZDataManager sharedInstance].currentEntry).subcategory = [self.subCategoryForm.userInputs valueForKey:@"subcategory"];
	}
	else {
		((SZEntryVO*)[SZDataManager sharedInstance].currentEntry).subcategory = nil;
	}
}

@end
