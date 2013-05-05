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

#import "MBProgressHUD.h"

#define FORM_TOP_MARGIN 20.0

@interface SZCreateAccountVC ()

@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) SZCheckBox* checkBox;
@property (nonatomic, strong) SZForm* form;

@end

@implementation SZCreateAccountVC

@synthesize scrollView = _scrollView;
@synthesize checkBox = _checkBox;
@synthesize form = _form;


- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIBarButtonItem* cancelButtton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self.presentingViewController action:@selector(dismiss:)];
	[self.navigationItem setLeftBarButtonItem:cancelButtton];
	[self.navigationItem setTitle:@"Create Account"];
	[self.navigationItem.leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [SZGlobalConstants fontWithFontType:SZFontBold size:12.0], UITextAttributeFont,nil] forState:UIControlStateNormal];

	[self.view addSubview:self.scrollView];
	
	[self.scrollView addSubview:self.form];
	[self.scrollView addSubview:self.checkBox];
	[self.scrollView addSubview:[self acceptLabel]];
	[self.scrollView addSubview:[self termsButton]];
	[self.scrollView addSubview:[self createButton]];
}

- (UIScrollView*)scrollView {
	if (_scrollView == nil) {
		_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 416.0)];
		[_scrollView setBackgroundColor:[UIColor clearColor]];
		[_scrollView setClipsToBounds:NO];
		[_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, _scrollView.frame.size.height)];
		
		UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTapped:)];
		[tapRecognizer setNumberOfTapsRequired:1];
		[_scrollView addGestureRecognizer:tapRecognizer];
	}
	return _scrollView;
}

- (void)scrollViewTapped:(id)sender {
	if (self.form.isActive) {
		[self.form resign:nil completion:nil];
	}
}

#pragma mark - UI elements (properties)

- (SZForm*)form {
	
	if (_form == nil) {
		
		_form = [[SZForm alloc] initWithWidth:290.0];
		
		SZFormFieldVO* firstNameField = [SZFormFieldVO formFieldValueObjectForTextWithKey:@"firstName"
																		  placeHolderText:@"First Name"
																			 keyboardType:UIKeyboardTypeDefault];
		SZFormFieldVO* lastNameField = [SZFormFieldVO formFieldValueObjectForTextWithKey:@"lastName"
																		 placeHolderText:@"Last Name"
																			keyboardType:UIKeyboardTypeDefault];
		SZFormFieldVO* zipCodeField = [SZFormFieldVO formFieldValueObjectForTextWithKey:@"zipCode"
																		placeHolderText:@"ZIP code"
																		   keyboardType:UIKeyboardTypeNumbersAndPunctuation];
		SZFormFieldVO* stateField = [SZFormFieldVO formFieldValueObjectForPickerWithKey:@"state"
																		placeHolderText:@"State"
																		  pickerOptions:[SZGlobalConstants statesArray]];
		SZFormFieldVO* emailField = [SZFormFieldVO formFieldValueObjectForTextWithKey:@"email"
																	  placeHolderText:@"Email"
																		 keyboardType:UIKeyboardTypeEmailAddress];
		SZFormFieldVO* passwordField = [SZFormFieldVO formFieldValueObjectForTextWithKey:@"password"
																		 placeHolderText:@"Password"
																			keyboardType:UIKeyboardTypeDefault];
		passwordField.isPassword = YES;
		SZFormFieldVO* confirmPasswordField = [SZFormFieldVO formFieldValueObjectForTextWithKey:@"confirmPassword"
																				placeHolderText:@"Confirm Password"
																				   keyboardType:UIKeyboardTypeDefault];
		confirmPasswordField.isPassword = YES;
		
		[_form addItem:firstNameField showsClearButton:YES isLastItem:NO];
		[_form addItem:lastNameField showsClearButton:YES isLastItem:NO];
		[_form addItem:zipCodeField showsClearButton:YES isLastItem:NO];
		[_form addItem:stateField showsClearButton:YES isLastItem:NO];
		[_form addItem:emailField showsClearButton:YES isLastItem:NO];
		[_form addItem:passwordField showsClearButton:YES isLastItem:NO];
		[_form addItem:confirmPasswordField showsClearButton:YES isLastItem:YES];
		
		[_form setCenter:CGPointMake(160.0, _form.frame.size.height/2 + FORM_TOP_MARGIN)];
		
		[_form setScrollContainer:self.scrollView];
		[_form addKeyboardToolbar];
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
	[termsButton addTarget:self action:@selector(showTermsTapped:) forControlEvents:UIControlEventTouchUpInside];
	[termsButton setFrame:CGRectMake(0.0, 0.0, 160.0, 40.0)];
	[termsButton setCenter:CGPointMake(216.0, 330.0)];
	return termsButton;
}

- (SZButton*)createButton {
	SZButton* createButton = [SZButton buttonWithColor:SZButtonColorPetrol size:SZButtonSizeLarge width:290.0];
	[createButton setTitle:@"Create Account" forState:UIControlStateNormal];
	[createButton setCenter:CGPointMake(160.0, 380.0)];
	[createButton addTarget:self action:@selector(createAccountTapped:) forControlEvents:UIControlEventTouchUpInside];
	return createButton;
}

#pragma mark - User actions

- (void)showTermsTapped:(id)sender {
	NSLog(@"show terms!");
	// TODO show terms
}

- (void)createAccountTapped:(id)sender {
	[self checkInputs];
}

#pragma mark - Internal operations

- (void)checkInputs {

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
	
	inputToEvaluate = [self.form.userInputs valueForKey:@"zipCode"];
	regEx = @"[0-9]{5}(-[0-9]{4})?";
	testPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regEx];
	if (![testPredicate evaluateWithObject:inputToEvaluate]) {
		errorMessage = [errorMessage stringByAppendingString:@"ZIP code must have one of the following formats:\n12344\n123456789\n12345-6789\n\n"];
	}
	
	inputToEvaluate = [self.form.userInputs valueForKey:@"email"];
	regEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	testPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regEx];
	if (![testPredicate evaluateWithObject:inputToEvaluate]) {
		errorMessage = [errorMessage stringByAppendingString:@"The Email address you provided is not valid.\n\n"];
	}
	
	inputToEvaluate = [self.form.userInputs valueForKey:@"password"];
	regEx = @"[A-Za-z0-9._!\\?@-]{6,18}$";
	testPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regEx];
	if (![testPredicate evaluateWithObject:inputToEvaluate]) {
		errorMessage = [errorMessage stringByAppendingString:@"The password must contain 6 to 18 characters. Valid characters are letters, digits and any of the following special characters:\n _ - . ! ? @\n\n"];
	}
	
	if (![inputToEvaluate isEqualToString:[self.form.userInputs valueForKey:@"confirmPassword"]]) {
		errorMessage = [errorMessage stringByAppendingString:@"The passwords must match.\n\n"];
	}
	
	if ([errorMessage isEqualToString:@""]) {
		[self createAccount];
	}
	else {
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Please resolve the following issues: " message:[errorMessage substringToIndex:[errorMessage length] - 2] delegate:nil cancelButtonTitle:@"Okay!" otherButtonTitles: nil];
		[alertView show];
	}
}

- (void)createAccount {
	PFUser *user = [PFUser user];
    user.username = [[self.form.userInputs valueForKey:@"email"] lowercaseString];
    user.email = [[self.form.userInputs valueForKey:@"email"] lowercaseString];
    user.password = [self.form.userInputs valueForKey:@"password"];
	
	[user setObject:[self.form.userInputs valueForKey:@"firstName"] forKey:@"firstName"];
	[user setObject:[self.form.userInputs valueForKey:@"lastName"] forKey:@"lastName"];
	[user setObject:[self.form.userInputs valueForKey:@"zipCode"] forKey:@"zipCode"];
	[user setObject:[self.form.userInputs valueForKey:@"state"] forKey:@"state"];
	
	MBProgressHUD* hud = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:hud];
	[hud setDimBackground:YES];
	[hud setRemoveFromSuperViewOnHide:YES];
	[hud show:YES];
	
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
		if (!error) {
			[hud hide:YES];
			[[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_SIGN_UP_SUCCESS object:user];
			[self.presentingViewController performSelector:@selector(dismiss:) withObject:self];
		} else {
			[hud hide:YES];
			UIAlertView* alertView = [SZUtils alertViewForError:error delegate:self];
			[alertView setTag:2];
			[alertView addButtonWithTitle:@"Sign In"];
			[alertView addButtonWithTitle:@"Request new password"];
			[alertView addButtonWithTitle:@"Use another Email address"];
			[alertView show];
		}
    }];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	switch (buttonIndex) {
		case 0: // sign in
			[self.presentingViewController performSelector:@selector(dismiss:) withObject:self];
			break;
		case 1: // forgot password
			[[NSNotificationCenter defaultCenter] postNotificationName:NOTIF_REQUEST_PASSWORD object:nil];
			[self.presentingViewController performSelector:@selector(dismiss:) withObject:self];
			break;
		default:
			break;
	}
}


//- (void)formDidBeginEditing:(SZForm *)form {
//	[UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//		[self.scrollView setFrame:CGRectMake(0.0, 0.0, 320.0, 160.0)];
//	} completion:nil];
//}

//- (void)formDidEndEditing:(SZForm *)form {
//	
//	[UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//		[self.scrollView setContentOffset:CGPointMake(0.0, 0.0)];
//	} completion:^(BOOL finished) {
//		[self.scrollView setFrame:CGRectMake(0.0, 0.0, 320.0, 416.0)];
//	}];
//}


@end
