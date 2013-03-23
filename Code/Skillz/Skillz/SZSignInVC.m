//
//  SZLoginVC.m
//  Skillz
//
//  Created by Julia Roggatz on 22.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <Parse/Parse.h>

#import "SZSignInVC.h"

#import "SZForm.h"
#import "SZButton.h"
#import "SZUtils.h"
#import "SZCreateAccountVC.h"
#import "SZNavigationController.h"

#import "MBProgressHUD.h"

#define FORM_YPOS 195.0
#define SIGN_IN_YPOS 270.0
#define FORGOT_PWORD_YPOS 310.0
#define LOWER_BUTTONS_YPOS 375.0

@interface SZSignInVC ()

@property (nonatomic, strong) SZForm* form;

@end

@implementation SZSignInVC

@synthesize form = _form;

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.navigationItem setTitle:@"Skillz"];
	
	[self.view addSubview:self.form];
	[self.view addSubview:[self signInButton]];
	[self.view addSubview:[self forgotPasswordButton]];
	[self.view addSubview:[self createAccountButton]];
	[self.view addSubview:[self learnMoreButton]];
}

#pragma mark - UI elements (properties)

- (SZForm*)form {
	
	if (_form == nil) {
		
		_form = [[SZForm alloc] init];
		[_form addItem:[NSDictionary dictionaryWithObjects:
						[NSArray arrayWithObjects:@"Email", [NSNumber numberWithInt:UIKeyboardTypeEmailAddress], nil] forKeys:
						[NSArray arrayWithObjects:FORM_PLACEHOLDER, FORM_INPUT_TYPE, nil]] isLastItem:NO];
		[_form addItem:[NSDictionary dictionaryWithObjects:
						[NSArray arrayWithObjects:@"Password", [NSNumber numberWithInt:INPUT_TYPE_PASSWORD], nil] forKeys:
						[NSArray arrayWithObjects:FORM_PLACEHOLDER, FORM_INPUT_TYPE, nil]] isLastItem:YES];
		[_form setCenter:CGPointMake(160.0, FORM_YPOS)];
		
		[_form configureKeyboard];
	}
	return _form;
}

#pragma mark - UI elements (non-properties)

- (SZButton*)signInButton {
	SZButton* signInButton = [[SZButton alloc] initWithColor:SZButtonColorPetrol size:SZButtonSizeLarge width:290.0];
	[signInButton setTitle:@"Sign In" forState:UIControlStateNormal];
	[signInButton setCenter:CGPointMake(160.0, SIGN_IN_YPOS)];
	[signInButton addTarget:self action:@selector(signIn:) forControlEvents:UIControlEventTouchUpInside];
	return signInButton;
}

- (UIButton*)forgotPasswordButton {
	UIButton* forgotPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[forgotPasswordButton setTitleColor:[SZGlobalConstants darkPetrol] forState:UIControlStateNormal];
	[forgotPasswordButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[forgotPasswordButton.titleLabel setFont:[SZGlobalConstants fontWithFontType:SZFontExtraBold size:14.0]];
	[forgotPasswordButton.titleLabel setShadowOffset:CGSizeMake(0.0, 1.0)];
	[forgotPasswordButton setTitle:@"Forgot Password?" forState:UIControlStateNormal];
	[forgotPasswordButton addTarget:self action:@selector(forgotPassword:) forControlEvents:UIControlEventTouchUpInside];
	[forgotPasswordButton setFrame:CGRectMake(0.0, 0.0, 160.0, 40.0)];
	[forgotPasswordButton setCenter:CGPointMake(235.0, FORGOT_PWORD_YPOS)];
	return forgotPasswordButton;
}

- (SZButton*)createAccountButton {
	SZButton* createAccountButton = [[SZButton alloc] initWithColor:SZButtonColorPetrol size:SZButtonSizeExtraLarge width:140.0];
	[createAccountButton setCenter:CGPointMake(85.0, LOWER_BUTTONS_YPOS)];
	[createAccountButton addTarget:self action:@selector(createAccount:) forControlEvents:UIControlEventTouchUpInside];
	[createAccountButton setMultilineTitle:@"Create\nAccount" font:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:16.0] lineSpacing:0.0];
	return createAccountButton;
}

- (SZButton*)learnMoreButton {
	SZButton* learnMoreButton = [[SZButton alloc] initWithColor:SZButtonColorOrange size:SZButtonSizeExtraLarge width:140.0];
	[learnMoreButton setCenter:CGPointMake(235.0, LOWER_BUTTONS_YPOS)];
	[learnMoreButton addTarget:self action:@selector(learnMore:) forControlEvents:UIControlEventTouchUpInside];
	[learnMoreButton setMultilineTitle:@"Learn\nMore" font:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:16.0] lineSpacing:0.0];
	return learnMoreButton;
}

- (void)signIn:(id)sender {
	
	// check if both fields have inputs
	if (!([[self.form.userInputs valueForKey:@"Email"] isEqualToString:@""] || [[self.form.userInputs valueForKey:@"Password"] isEqualToString:@""])) {
		MBProgressHUD* hud = [[MBProgressHUD alloc] initWithView:self.view];
		[self.view addSubview:hud];
		[hud setDimBackground:YES];
		[hud setRemoveFromSuperViewOnHide:YES];
		[hud show:YES];
		[PFUser logInWithUsernameInBackground:[[self.form.userInputs valueForKey:@"Email"] lowercaseString] password:[self.form.userInputs valueForKey:@"Password"] block:^(PFUser *user, NSError *error) {
			if (user) {
				[hud hide:YES];
				// TODO check if email verified!
				NSLog(@"success");
			} else {
				[hud hide:YES];
				NSString* errorTitle;
				NSString* errorMessage;
				if (error.code == 101) {
					errorTitle = @"Incorrect password or Email address.";
					errorMessage = @"If you forgot your password, you can request a new one through the \"Forgot Password?\" link below the \"Sign In\" button.";
				}
				else {
					errorTitle = @"An unknown error occured.";
					errorMessage = @"Please try again.";
				}
				UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:errorTitle message:errorMessage delegate:self cancelButtonTitle:@"Okay!" otherButtonTitles: nil];
				[alertView show];
			}
		}];
	}
	// if one or both fields are left empty, show error message
	else {
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Please provide your Email address and password in order to sign in." delegate:self cancelButtonTitle:@"Okay!" otherButtonTitles: nil];
		[alertView show];
	}
	
}

- (void)forgotPassword:(id)sender {
	NSLog(@"forgotPassword");
}

- (void)createAccount:(id)sender {
	SZNavigationController* navController = [[SZNavigationController alloc] initWithRootViewController:[[SZCreateAccountVC alloc] init]];
	[navController setModalPresentationStyle:UIModalPresentationFullScreen];
	[self presentViewController:navController animated:YES completion:nil];
}

- (void)learnMore:(id)sender {
	NSLog(@"learnMore");
}

@end
