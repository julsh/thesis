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
#import "SZUtils.h"

@interface SZNewEntryStep1VC ()

@property (nonatomic, strong) SZForm* categoryForm;
@property (nonatomic, strong) UIView* subCategoryView;
@property (nonatomic, strong) SZForm* subCategoryForm;
@property (nonatomic, strong) NSString* currentyCategory;


@end

@implementation SZNewEntryStep1VC

@synthesize categoryForm = _categoryForm;
@synthesize subCategoryForm = _subCategoryForm;

- (id)initWithEntry:(SZEntryObject*)entry
{
	self = [super initWithStepNumber:1 totalSteps:5];
	if (self) {
		if (entry) {
			[[SZDataManager sharedInstance] setCurrentEntry:entry];
			[[SZDataManager sharedInstance] setCurrentEntryIsNew:NO];
			self.currentyCategory = entry.category;
		}
		else {
			SZEntryObject* newEntry = [SZEntryObject object];
			newEntry.type = [SZDataManager sharedInstance].currentEntryType;
			newEntry.user = [PFUser currentUser];
			[[SZDataManager sharedInstance] setCurrentEntry:newEntry];
			[[SZDataManager sharedInstance] setCurrentEntryIsNew:YES];
			self.currentyCategory = @"";
		}
	}
	return self;
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
	
	
	[self.mainView addSubview:[self selectCategoryLabel]];
	[self.mainView addSubview:self.categoryForm];
	[self.mainView addSubview:self.detailViewContainer];
	[self.detailViewContainer setFrame:CGRectMake(0.0, 150.0, 0.0, 0.0)];
	
	if (![SZDataManager sharedInstance].currentEntryIsNew && [[SZDataManager sortedSubcategoriesForCategory:self.currentyCategory] count] > 0) {
		[self addNewDetailView:1];
	}
	if ([SZDataManager sharedInstance].currentEntryIsNew) {
		[self.mainView addSubview:[self suggestCategoryView]];
	}
}

- (UILabel*)selectCategoryLabel {
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 70.0, 200.0, 30.0)];
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
		[self.forms addObject:_categoryForm];
		[_categoryForm setDelegate:self];
	
		SZFormFieldVO* categoryField = [SZFormFieldVO formFieldValueObjectForPickerWithKey:@"category"
																		   placeHolderText:@"Category"
																			 pickerOptions:[SZDataManager sortedCategories]];
		[_categoryForm addItem:categoryField showsClearButton:YES isLastItem:YES];
		[_categoryForm setCenter:CGPointMake(160.0, 130.0)];
		[_categoryForm addKeyboardToolbar];
		[_categoryForm setScrollContainer:self.mainView];
		
		if (![SZDataManager sharedInstance].currentEntryIsNew) {
			SZEntryObject* entry = (SZEntryObject*)[SZDataManager sharedInstance].currentEntry;
			if (entry.category) {
				[_categoryForm.userInputs setValue:entry.category forKey:@"category"];
				[_categoryForm setText:entry.category forFieldAtIndex:0];
				[_categoryForm updatePickerAtIndex:0];
			}
		}
	}
	return _categoryForm;
}


- (UIView*)subCategoryView {
	if (_subCategoryView == nil) {
		_subCategoryView = [[UIView alloc] initWithFrame:CGRectMake(5.0, 0.0, 320.0, 100.0)];
		[_subCategoryView addSubview:[self selectSubCategoryLabel]];
		[_subCategoryView addSubview:self.subCategoryForm];
	}
	return _subCategoryView;
}

- (UILabel*)selectSubCategoryLabel {
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 15.0, 300.0, 30.0)];
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
		[self.forms addObject:_subCategoryForm];
		
		SZFormFieldVO* subCategoryField = [SZFormFieldVO formFieldValueObjectForPickerWithKey:@"subcategory"
																		   placeHolderText:@"No Subcategory"
																			 pickerOptions:nil];
		[_subCategoryForm addItem:subCategoryField showsClearButton:YES isLastItem:YES];
		[_subCategoryForm setCenter:CGPointMake(140.0, 75.0)];
		[_subCategoryForm addKeyboardToolbar];
		[_subCategoryForm setScrollContainer:self.mainView];
		
		if (![SZDataManager sharedInstance].currentEntryIsNew) {
			SZEntryObject* entry = (SZEntryObject*)[SZDataManager sharedInstance].currentEntry;
			[self.subCategoryForm updatePickerOptions:[SZDataManager sortedSubcategoriesForCategory:entry.category] forPickerAtIndex:0];
			if (entry.subcategory) {
				[self.subCategoryForm setText:entry.subcategory forFieldAtIndex:0];
				[self.subCategoryForm updatePickerAtIndex:0];
			}
		}
	}
	return _subCategoryForm;
}

- (UIView*)suggestCategoryView {
	UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 265.0, 320.0, 60.0)];
	
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 30.0)];
	[label setBackgroundColor:[UIColor clearColor]];
	[label setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:16.0]];
	[label setTextColor:[SZGlobalConstants darkGray]];
	[label applyWhiteShadow];
	[label setTextAlignment:NSTextAlignmentCenter];
	[label setText:@"Didn't find a fitting category?"];
	[view addSubview:label];
	
	SZButton* button = [SZButton buttonWithColor:SZButtonColorPetrol size:SZButtonSizeMedium width:220.0];
	[button setTitle:@"Suggest New Category" forState:UIControlStateNormal];
	[button setCenter:CGPointMake(160.0, 50.0)];
	[button addTarget:self action:@selector(suggestCategory:) forControlEvents:UIControlEventTouchUpInside];
	[view addSubview:button];
	
	return view;
}


- (void)formDidResignFirstResponder:(SZForm *)form {
	
	if ([form.userInputs valueForKey:@"category"] && ![[form.userInputs valueForKey:@"category"] isEqualToString:self.currentyCategory]) {
		self.currentyCategory = [form.userInputs valueForKey:@"category"];
		NSArray* subCategories = [SZDataManager sortedSubcategoriesForCategory:self.currentyCategory];
		if ([subCategories count] > 0) {
			if ([[self.detailViewContainer subviews] count] == 0) {
				[self slideOutDetailViewAndAddNewViewWithIndex:1];
			}
			[self.subCategoryForm updatePickerOptions:subCategories forPickerAtIndex:0];
		}
		else if ([subCategories count] == 0) {
			if ([[self.detailViewContainer subviews] count] > 0) {
				[self slideOutDetailViewAndAddNewViewWithIndex:0];
				[self.subCategoryForm.userInputs setValue:@"" forKey:@"subcategory"];
			}
		}
	}
}

- (void)addNewDetailView:(NSInteger)index {
	
	if (index == 1) {
		[self.detailViewContainer addSubview:self.subCategoryView];
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

- (void)suggestCategory:(id)sender {

	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Suggest a new category" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Send", nil];
	[alertView setTag:0];
	[alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
	[alertView show];
	
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (alertView.tag == 0 && buttonIndex == 1) {
		
		UIAlertView* newAlertView;
		if ([alertView textFieldAtIndex:0].text && ![[alertView textFieldAtIndex:0].text isEqualToString:@""]) {
			newAlertView = [[UIAlertView alloc] initWithTitle:@"Thanks!" message:@"Your suggestion will be considered. If there are several people suggesting the same category, we will add it to the category list." delegate:nil cancelButtonTitle:@"Nice!" otherButtonTitles:nil];
		}
		else {
			newAlertView = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Seems like you forgot to\nput in some text." delegate:self cancelButtonTitle:@"Oh, you're totally right!" otherButtonTitles:nil];
		}
		
		[newAlertView setTag:1];
		[newAlertView show];
	}
	else if (alertView.tag == 1) {
		[self suggestCategory:nil];
	}
	else if (alertView.tag == 99) {
		[super alertView:alertView clickedButtonAtIndex:buttonIndex];
	}
}

- (void)continue:(id)sender {
	
#ifndef DEBUG
	if ([[self.categoryForm.userInputs valueForKey:@"category"] isEqualToString:@""]) {
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Category must be specified" message:nil delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
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
	((SZEntryObject*)[SZDataManager sharedInstance].currentEntry).category = [self.categoryForm.userInputs valueForKey:@"category"];
	if (![[self.subCategoryForm.userInputs valueForKey:@"subcategory"] isEqualToString:@""]) {
		((SZEntryObject*)[SZDataManager sharedInstance].currentEntry).subcategory = [self.subCategoryForm.userInputs valueForKey:@"subcategory"];
	}
	else {
		((SZEntryObject*)[SZDataManager sharedInstance].currentEntry).subcategory = nil;
	}
}

@end
