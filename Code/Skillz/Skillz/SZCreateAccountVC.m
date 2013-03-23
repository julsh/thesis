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
	
	UIBarButtonItem* menuButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self.navigationController action:@selector(dismiss:)];
	[self.navigationItem setLeftBarButtonItem:menuButton];
	[self.navigationItem setTitle:@"Create Account"];
	
	[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_pattern"]]];

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
					   [NSArray arrayWithObjects:@"ZIP code", [NSNumber numberWithInt:UIKeyboardTypeNumbersAndPunctuation], nil] forKeys:
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
	[acceptLabel setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:14.0]];
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
	[termsButton.titleLabel setFont:[SZGlobalConstants fontWithFontType:SZFontExtraBold size:14.0]];
	[termsButton.titleLabel setShadowOffset:CGSizeMake(0.0, 1.0)];
	[termsButton setTitle:@"Terms & Conditions" forState:UIControlStateNormal];
	[termsButton addTarget:self action:@selector(showTerms:) forControlEvents:UIControlEventTouchUpInside];
	[termsButton setFrame:CGRectMake(0.0, 0.0, 160.0, 40.0)];
	[termsButton setCenter:CGPointMake(216.0, 330.0)];
	return termsButton;
}

- (SZButton*)createButton {
	SZButton* createButton = [[SZButton alloc] initWithColor:SZButtonColorPetrol size:SZButtonSizeLarge width:290.0];
	[createButton setTitle:@"Create Account" forState:UIControlStateNormal];
	[createButton setCenter:CGPointMake(160.0, 380.0)];
	[createButton addTarget:self action:@selector(checkInputs:) forControlEvents:UIControlEventTouchUpInside];
	return createButton;
}

#pragma mark - User actions

- (void)showTerms:(id)sender {
	NSLog(@"show terms!");
}

- (void)checkInputs:(id)sender {

	NSString* errorMessage = @"";
	
	if (!self.checkBox.isChecked) {
		errorMessage = [errorMessage stringByAppendingString:@"You have to accept the terms & conditions.\n\n"];
	}
	
	for (NSString* key in [self.form.userInputs allKeys]) {
		if ([[self.form.userInputs valueForKey:key] isEqualToString:@""]) {
			errorMessage = [errorMessage stringByAppendingString:@"All fields have to be filled.\n\n"];
			break;
		}
	}
	
	NSString* inputToEvaluate, *regEx;
	NSPredicate *testPredicate;
	
	inputToEvaluate = [self.form.userInputs valueForKey:@"ZIP code"];
	regEx = @"[0-9]{5}(-[0-9]{4})?";
	testPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regEx];
	if (![testPredicate evaluateWithObject:inputToEvaluate]) {
		errorMessage = [errorMessage stringByAppendingString:@"ZIP code must have one of the following formats:\n12344\n123456789\n12345-6789\n\n"];
	}
	
	inputToEvaluate = [self.form.userInputs valueForKey:@"Email"];
	regEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
	testPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regEx];
	if (![testPredicate evaluateWithObject:inputToEvaluate]) {
		errorMessage = [errorMessage stringByAppendingString:@"The Email address you provided is not valid.\n\n"];
	}
	
	inputToEvaluate = [self.form.userInputs valueForKey:@"Password"];
	regEx = @"[a-z0-9._!\\?@-]{6,18}$";
	testPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regEx];
	if (![testPredicate evaluateWithObject:inputToEvaluate]) {
		errorMessage = [errorMessage stringByAppendingString:@"The password must contain 6 to 18 characters. Valid characters are letters, digits and any of the following special characters:\n _ - . ! ? @\n\n"];
	}
	
	if (![inputToEvaluate isEqualToString:[self.form.userInputs valueForKey:@"Confirm Password"]]) {
		errorMessage = [errorMessage stringByAppendingString:@"The passwords must match.\n\n"];
	}
	
	if ([errorMessage isEqualToString:@""]) {
		[self createAccount];
	}
	else {
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Please resolve the following issues: " message:[errorMessage substringToIndex:[errorMessage length] - 2] delegate:self cancelButtonTitle:@"Okay!" otherButtonTitles: nil];
		[alertView show];
	}
}

- (void)createAccount {
	PFUser *user = [PFUser user];
    user.username = [[self.form.userInputs valueForKey:@"Email"] lowercaseString];
    user.email = [[self.form.userInputs valueForKey:@"Email"] lowercaseString];
    user.password = [self.form.userInputs valueForKey:@"Password"];
	
	[user setObject:[self.form.userInputs valueForKey:@"First Name"] forKey:@"first_name"];
	[user setObject:[self.form.userInputs valueForKey:@"Last Name"] forKey:@"last_name"];
	[user setObject:[self.form.userInputs valueForKey:@"ZIP code"] forKey:@"zip_code"];
	[user setObject:[self.form.userInputs valueForKey:@"State"] forKey:@"state"];
	
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
		if (!error) {
			NSLog(@"signup success!");
		} else {
			NSString *errorString = [[error userInfo] objectForKey:@"error"];
			NSLog(@"error: %@", errorString);
		}
    }];
}


@end
