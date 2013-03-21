//
//  SZTestVC.m
//  Skillz
//
//  Created by Julia Roggatz on 19.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>

#import "SZCreateAccountVC.h"
#import "SZCheckBox.h"
#import "SZForm.h"
#import "SZButton.h"
#import "SZUtils.h"

#define FORM_TOP_MARGIN 20.0

@interface SZCreateAccountVC ()

@property (nonatomic, strong) SZCheckBox* checkBox;
@property (nonatomic, strong) SZForm* form;

@end

@implementation SZCreateAccountVC

@synthesize checkBox = _checkBox;
@synthesize form = _form;


- (void)viewDidLoad
{
    [super viewDidLoad];
	
	UIBarButtonItem* menuButton = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleDone target:self.navigationController action:@selector(showMenu:)];
	[self.navigationItem setLeftBarButtonItem:menuButton];
	[self.navigationItem setTitle:@"Create Account"];
	
	[self.view setBackgroundColor:[UIColor lightGrayColor]];
	
	[self.view addSubview:self.form];
	[self.view addSubview:self.checkBox];
	[self.view addSubview:[self acceptLabel]];
	[self.view addSubview:[self termsButton]];
	[self.view addSubview:[self createButton]];
}

#pragma mark - UI elements (properties)

- (SZForm*)form {
	
	if (_form == nil) {
		
		_form = [[SZForm alloc] init];
		[_form addItem:[NSDictionary dictionaryWithObjects:
					   [NSArray arrayWithObjects:@"First Name", [NSNumber numberWithInt:UIKeyboardTypeDefault], nil] forKeys:
					   [NSArray arrayWithObjects:FORM_PLACEHOLDER, FORM_INPUT_TYPE, nil]] isLastItem:NO];
		[_form addItem:[NSDictionary dictionaryWithObjects:
					   [NSArray arrayWithObjects:@"Last Name", [NSNumber numberWithInt:UIKeyboardTypeDefault], nil] forKeys:
					   [NSArray arrayWithObjects:FORM_PLACEHOLDER, FORM_INPUT_TYPE, nil]] isLastItem:NO];
		[_form addItem:[NSDictionary dictionaryWithObjects:
					   [NSArray arrayWithObjects:@"ZIP code", [NSNumber numberWithInt:UIKeyboardTypeDecimalPad], nil] forKeys:
					   [NSArray arrayWithObjects:FORM_PLACEHOLDER, FORM_INPUT_TYPE, nil]] isLastItem:NO];
		[_form addItem:[NSDictionary dictionaryWithObjects:
					   [NSArray arrayWithObjects:@"State", [NSNumber numberWithInt:INPUT_TYPE_PICKER], [NSArray arrayWithObjects:@"California", @"Texas", @"Florida", @"Oregon", nil], nil] forKeys:
					   [NSArray arrayWithObjects:FORM_PLACEHOLDER, FORM_INPUT_TYPE, PICKER_OPTIONS, nil]] isLastItem:NO];
		[_form addItem:[NSDictionary dictionaryWithObjects:
					   [NSArray arrayWithObjects:@"Email", [NSNumber numberWithInt:UIKeyboardTypeEmailAddress], nil] forKeys:
					   [NSArray arrayWithObjects:FORM_PLACEHOLDER, FORM_INPUT_TYPE, nil]] isLastItem:NO];
		[_form addItem:[NSDictionary dictionaryWithObjects:
					   [NSArray arrayWithObjects:@"Password", [NSNumber numberWithInt:INPUT_TYPE_PASSWORD], nil] forKeys:
					   [NSArray arrayWithObjects:FORM_PLACEHOLDER, FORM_INPUT_TYPE, nil]] isLastItem:NO];
		[_form addItem:[NSDictionary dictionaryWithObjects:
					   [NSArray arrayWithObjects:@"Confirm Password", [NSNumber numberWithInt:INPUT_TYPE_PASSWORD], nil] forKeys:
					   [NSArray arrayWithObjects:FORM_PLACEHOLDER, FORM_INPUT_TYPE, nil]] isLastItem:YES];
		[_form setCenter:CGPointMake(160.0, _form.frame.size.height/2 + FORM_TOP_MARGIN)];
		
		[_form configureKeyboard];
	}
	return _form;
}

- (SZCheckBox*)checkBox {
	if (_checkBox == nil) {
		_checkBox = [[SZCheckBox alloc] init];
		[_checkBox setCenter:CGPointMake(42.0, 330.0)];
	}
	return _checkBox;
}

#pragma mark - UI elements (non-properties)

- (UILabel*)acceptLabel {
	UILabel* acceptLabel = [[UILabel alloc] init];
	[acceptLabel setFont:[SZUtils fontWithFontType:SZFontSemiBold size:14.0]];
	[acceptLabel setTextColor:[SZGlobalConstants darkGray]];
	[acceptLabel applyWhiteShadow];
	[acceptLabel setText:@"I accept the"];
	[acceptLabel sizeToFit];
	[acceptLabel setCenter:CGPointMake(102.0, 330.0)];
	return acceptLabel;
}

- (UIButton*)termsButton {
	UIButton* termsButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[termsButton setTitleColor:[SZGlobalConstants darkPetrol] forState:UIControlStateNormal];
	[termsButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[termsButton.titleLabel setFont:[SZUtils fontWithFontType:SZFontExtraBold size:14.0]];
	[termsButton.titleLabel setShadowOffset:CGSizeMake(0.0, 1.0)];
	[termsButton setTitle:@"Terms & Conditions" forState:UIControlStateNormal];
	[termsButton addTarget:self action:@selector(showTerms:) forControlEvents:UIControlEventTouchUpInside];
	[termsButton setFrame:CGRectMake(0.0, 0.0, 160.0, 40.0)];
	[termsButton setCenter:CGPointMake(216.0, 330.0)];
	return termsButton;
}

- (SZButton*)createButton {
	SZButton* createButton = [[SZButton alloc] initWithColor:SZButtonColorPetrol size:SZButtonSizeBig width:280.0];
	[createButton setTitle:@"Create Account" forState:UIControlStateNormal];
	[createButton setCenter:CGPointMake(160.0, 380.0)];
	return createButton;
}

#pragma mark - User actions

- (void)showTerms:(id)sender {
	NSLog(@"show terms!");
}

- (void)postThisShit:(id)sender {
//	PFObject *request = [PFObject objectWithClassName:@"Request"];
//	[request setObject:self.titleField.text forKey:@"title"];
//	[request setObject:self.descriptionField.text forKey:@"description"];
//	[request saveInBackground];
//	SZTestNC* navController = [[SZTestNC alloc] init];
//	[self presentViewController:navController animated:YES completion:nil];
	NSLog(@"checked? %i", self.checkBox.isChecked);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
