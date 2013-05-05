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

@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) SZForm* form;

@end

@implementation SZSignInVC

@synthesize scrollView = _scrollView;
@synthesize form = _form;

- (void)viewDidLoad {
    [super viewDidLoad];
	[self addMenuButton];
	[self.navigationItem setTitle:@"Sign In"];
	[self.navigationItem.backBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [SZGlobalConstants fontWithFontType:SZFontBold size:12.0], UITextAttributeFont,nil] forState:UIControlStateNormal];
	
	[self.view addSubview:self.scrollView];
	
	[self.scrollView addSubview:self.form];
	[self.scrollView addSubview:[self logo]];
	[self.scrollView addSubview:[self signInButton]];
	[self.scrollView addSubview:[self forgotPasswordButton]];
	[self.scrollView addSubview:[self createAccountButton]];
	[self.scrollView addSubview:[self learnMoreButton]];
}

#pragma mark - UI elements (properties)

- (SZForm*)form {
	
	if (_form == nil) {
		
		_form = [[SZForm alloc] initWithWidth:290.0];
		
		SZFormFieldVO* emailField = [SZFormFieldVO formFieldValueObjectForTextWithKey:@"email" placeHolderText:@"Email" keyboardType:UIKeyboardTypeEmailAddress];
		SZFormFieldVO* passwordField = [SZFormFieldVO formFieldValueObjectForTextWithKey:@"password" placeHolderText:@"Password" keyboardType:UIKeyboardTypeDefault];
		passwordField.isPassword = YES;
		
		[_form addItem:emailField showsClearButton:YES isLastItem:NO];
		[_form addItem:passwordField showsClearButton:YES isLastItem:YES];
		
		[_form setCenter:CGPointMake(160.0, FORM_YPOS)];
		
		[_form setScrollContainer:self.scrollView];
		[_form addKeyboardToolbar];
	}
	return _form;
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

#pragma mark - UI elements (non-properties)

- (UIImageView*)logo {
	UIImageView* logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_transparent_shadow"]];
	[logo setCenter:CGPointMake(160.0, 80.0)];
	return logo;
}

- (SZButton*)signInButton {
	SZButton* signInButton =[SZButton buttonWithColor:SZButtonColorPetrol size:SZButtonSizeLarge width:290.0];
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
	SZButton* createAccountButton = [SZButton buttonWithColor:SZButtonColorOrange size:SZButtonSizeExtraLarge width:140.0];
	[createAccountButton setCenter:CGPointMake(235.0, LOWER_BUTTONS_YPOS)];
	[createAccountButton addTarget:self action:@selector(createAccountTapped:) forControlEvents:UIControlEventTouchUpInside];
	[createAccountButton setMultilineTitle:@"Create\nAccount" font:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:16.0] lineSpacing:0.0];
	return createAccountButton;
}

- (SZButton*)learnMoreButton {
	SZButton* learnMoreButton = [SZButton buttonWithColor:SZButtonColorPetrol size:SZButtonSizeExtraLarge width:140.0];
	[learnMoreButton setCenter:CGPointMake(85.0, LOWER_BUTTONS_YPOS)];
	[learnMoreButton addTarget:self action:@selector(learnMoreTapped:) forControlEvents:UIControlEventTouchUpInside];
	[learnMoreButton setMultilineTitle:@"Learn\nMore" font:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:16.0] lineSpacing:0.0];
	return learnMoreButton;
}

#pragma mark - User actions

- (void)signInTapped:(id)sender {
	
	// check if both fields have inputs
	if (!([[self.form.userInputs valueForKey:@"email"] isEqualToString:@""] || [[self.form.userInputs valueForKey:@"password"] isEqualToString:@""])) {
		MBProgressHUD* hud = [[MBProgressHUD alloc] initWithView:self.view];
		[self.view addSubview:hud];
		[hud setDimBackground:YES];
		[hud setRemoveFromSuperViewOnHide:YES];
		[hud show:YES];
		[PFUser logInWithUsernameInBackground:[[self.form.userInputs valueForKey:@"email"] lowercaseString] password:[self.form.userInputs valueForKey:@"password"] block:^(PFUser *user, NSError *error) {
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
