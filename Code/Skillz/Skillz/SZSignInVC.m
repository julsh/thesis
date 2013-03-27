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
#import "SZCreateAccountSuccessVC.h"
#import "SZForgotPasswordVC.h"

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
	[self.navigationItem setTitle:@"Sign In"];
	[self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil]];
	
	[self.view addSubview:self.form];
	[self.view addSubview:[self logo]];
	[self.view addSubview:[self signInButton]];
	[self.view addSubview:[self forgotPasswordButton]];
	[self.view addSubview:[self createAccountButton]];
	[self.view addSubview:[self learnMoreButton]];
}

#pragma mark - UI elements (properties)

- (SZForm*)form {
	
	if (_form == nil) {
		
		_form = [[SZForm alloc] initWithWidth:290.0];
		[_form addItem:[NSDictionary dictionaryWithObjects:
						[NSArray arrayWithObjects:@"Email", [NSNumber numberWithInt:UIKeyboardTypeEmailAddress], nil] forKeys:
						[NSArray arrayWithObjects:FORM_PLACEHOLDER, FORM_INPUT_TYPE, nil]] isLastItem:NO];
		[_form addItem:[NSDictionary dictionaryWithObjects:
						[NSArray arrayWithObjects:@"Password", [NSNumber numberWithInt:INPUT_TYPE_PASSWORD], nil] forKeys:
						[NSArray arrayWithObjects:FORM_PLACEHOLDER, FORM_INPUT_TYPE, nil]] isLastItem:YES];
		[_form setCenter:CGPointMake(160.0, FORM_YPOS)];
		
		[_form setScrollContainer:self.view];
		[_form configureKeyboard];
	}
	return _form;
}

#pragma mark - UI elements (non-properties)

- (UIImageView*)logo {
	UIImageView* logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_transparent"]];
	[logo setCenter:CGPointMake(160.0, 80.0)];
	return logo;
}

- (SZButton*)signInButton {
	SZButton* signInButton = [[SZButton alloc] initWithColor:SZButtonColorPetrol size:SZButtonSizeLarge width:290.0];
	[signInButton setTitle:@"Sign In" forState:UIControlStateNormal];
	[signInButton setCenter:CGPointMake(160.0, SIGN_IN_YPOS)];
	[signInButton addTarget:self action:@selector(signInTapped:) forControlEvents:UIControlEventTouchUpInside];
	return signInButton;
}

- (UIButton*)forgotPasswordButton {
	UIButton* forgotPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[forgotPasswordButton setTitleColor:[SZGlobalConstants darkPetrol] forState:UIControlStateNormal];
	[forgotPasswordButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[forgotPasswordButton.titleLabel setFont:[SZGlobalConstants fontWithFontType:SZFontExtraBold size:14.0]];
	[forgotPasswordButton.titleLabel setShadowOffset:CGSizeMake(0.0, 1.0)];
	[forgotPasswordButton setTitle:@"Forgot Password?" forState:UIControlStateNormal];
	[forgotPasswordButton addTarget:self action:@selector(forgotPasswordTapped:) forControlEvents:UIControlEventTouchUpInside];
	[forgotPasswordButton setFrame:CGRectMake(0.0, 0.0, 160.0, 40.0)];
	[forgotPasswordButton setCenter:CGPointMake(235.0, FORGOT_PWORD_YPOS)];
	return forgotPasswordButton;
}

- (SZButton*)createAccountButton {
	SZButton* createAccountButton = [[SZButton alloc] initWithColor:SZButtonColorOrange size:SZButtonSizeExtraLarge width:140.0];
	[createAccountButton setCenter:CGPointMake(235.0, LOWER_BUTTONS_YPOS)];
	[createAccountButton addTarget:self action:@selector(createAccountTapped:) forControlEvents:UIControlEventTouchUpInside];
	[createAccountButton setMultilineTitle:@"Create\nAccount" font:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:16.0] lineSpacing:0.0];
	return createAccountButton;
}

- (SZButton*)learnMoreButton {
	SZButton* learnMoreButton = [[SZButton alloc] initWithColor:SZButtonColorPetrol size:SZButtonSizeExtraLarge width:140.0];
	[learnMoreButton setCenter:CGPointMake(85.0, LOWER_BUTTONS_YPOS)];
	[learnMoreButton addTarget:self action:@selector(learnMoreTapped:) forControlEvents:UIControlEventTouchUpInside];
	[learnMoreButton setMultilineTitle:@"Learn\nMore" font:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:16.0] lineSpacing:0.0];
	return learnMoreButton;
}

#pragma mark - User actions

- (void)signInTapped:(id)sender {
	
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
				if ([[user objectForKey:@"emailVerified"] boolValue]) {
					NSLog(@"success");
					// TODO go to dashboard/start page
				}
				else {
					UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Email address not verified" message:@"You should have received an Email from us asking you to verify your Email address. Please click the link in the Email to complete your registration." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:@"Resend Email", nil];
					[alertView show];
				}
			} else {
				[hud hide:YES];
				UIAlertView* alertView = [SZUtils alertViewForError:error delegate:self];
				[alertView addButtonWithTitle:@"Okay"];
				[alertView show];
			}
		}];
	}
	// if one or both fields are left empty, show error message
	else {
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Please provide your Email address and password in order to sign in." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
		[alertView show];
	}
	
}

- (void)forgotPasswordTapped:(id)sender {
//	SZForgotPasswordVC
	[self.navigationController pushViewController:[[SZForgotPasswordVC alloc] init] animated:YES];
}

- (void)createAccountTapped:(id)sender {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signUpSuccess:) name:NOTIF_SIGN_UP_SUCCESS object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(forgotPasswordTapped:) name:NOTIF_REQUEST_PASSWORD object:nil];
	SZNavigationController* navController = [[SZNavigationController alloc] initWithRootViewController:[[SZCreateAccountVC alloc] init]];
	[navController setModalPresentationStyle:UIModalPresentationFullScreen];
	[self presentViewController:navController animated:YES completion:nil];
}

- (void)learnMoreTapped:(id)sender {
	NSLog(@"learnMore");
	// TODO learn more controller
}

#pragma mark - Internal operations

- (void)signUpSuccess:(NSNotification*)notif {
	[self.navigationController setViewControllers:[NSArray arrayWithObject:[[SZCreateAccountSuccessVC alloc] initWithUser:(PFUser*)notif.object]]];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
		NSLog(@"resend email");
		// TODO resend email. doesn't work with parse backend.
	}
}


@end
