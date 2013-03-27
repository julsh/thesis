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
	[self.navigationItem setTitle:@"Post a Request"];
	
	[self.mainView addSubview:[self addTitleLabel]];
	[self.mainView addSubview:self.titleForm];
	[self.mainView addSubview:[self addDescriptionLabel]];
	[self.mainView addSubview:self.descriptionForm];
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
		[_titleForm addItem:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"Request Title", [NSNumber numberWithInt:UIKeyboardTypeDefault], nil] forKeys:
								[NSArray arrayWithObjects:FORM_PLACEHOLDER, FORM_INPUT_TYPE, nil]] isLastItem:YES];
		[_titleForm setCenter:CGPointMake(160.0, 120.0)];
		[_titleForm configureKeyboard];
		[_titleForm setScrollContainer:self.view];
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
		_descriptionForm = [[SZForm alloc] initForTextViewWithWidth:290.0 height:140.0];
		[_descriptionForm setCenter:CGPointMake(160.0, 270.0)];
		[_descriptionForm setScrollContainer:self.view];
	}
	return _descriptionForm;
}

- (void)continue:(id)sender {
	SZNewRequestStep3VC* step3 = [[SZNewRequestStep3VC alloc] init];
	[self.navigationController pushViewController:step3 animated:YES];
}

@end
