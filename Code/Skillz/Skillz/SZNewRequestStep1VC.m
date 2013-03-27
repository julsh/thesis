//
//  SZNewRequestStep1VC.m
//  Skillz
//
//  Created by Julia Roggatz on 25.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

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

- (id)init
{
    return [super initWithStepNumber:1 totalSteps:5];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.navigationItem setTitle:@"Post a Request"];
	
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
		[_categoryForm addItem:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"Category", [NSNumber numberWithInt:INPUT_TYPE_PICKER], choices, nil] forKeys:
		 [NSArray arrayWithObjects:FORM_PLACEHOLDER, FORM_INPUT_TYPE, PICKER_OPTIONS, nil]] isLastItem:YES];
		[_categoryForm setCenter:CGPointMake(160.0, 150.0)];
		[_categoryForm configureKeyboard];
		[_categoryForm setScrollContainer:self.view];
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
		NSArray* choices = [NSArray arrayWithObjects:@"Household", @"Childcare", @"Computer Help", @"Blablabla", nil];
		[_subCategoryForm addItem:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"Subcategory", [NSNumber numberWithInt:INPUT_TYPE_PICKER], choices, nil] forKeys:
								[NSArray arrayWithObjects:FORM_PLACEHOLDER, FORM_INPUT_TYPE, PICKER_OPTIONS, nil]] isLastItem:YES];
		[_subCategoryForm setCenter:CGPointMake(160.0, 260.0)];
		[_subCategoryForm configureKeyboard];
		[_categoryForm setScrollContainer:self.view];
	}
	return _subCategoryForm;
}

- (void)continue:(id)sender {
	SZNewRequestStep2VC* step2 = [[SZNewRequestStep2VC alloc] init];
	[self.navigationController pushViewController:step2 animated:YES];
}

@end
