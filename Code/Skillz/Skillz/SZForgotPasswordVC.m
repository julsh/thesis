//
//  SZForgotPasswordVC.m
//  Skillz
//
//  Created by Julia Roggatz on 24.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <Parse/Parse.h>

#import "SZForgotPasswordVC.h"

#import "SZForm.h"
#import "SZButton.h"
#import "SZUtils.h"
#import "UITextView+Shadow.h"

#import "MBProgressHUD.h"

@interface SZForgotPasswordVC ()

@property (nonatomic, strong) SZForm* form;

@end

@implementation SZForgotPasswordVC

@synthesize form = _form;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_pattern"]]];
	[self.navigationItem setTitle:@"Forgot Password"];
	
	[self.view addSubview:[self noWorriesMessage]];
	[self.view addSubview:[self resetPasswordMessage]];
	[self.view addSubview:self.form];
	[self.view addSubview:[self resetPasswordButton]];
	
}

#pragma mark - UI elements (properties)

- (SZForm*)form {
	
	if (_form == nil) {
		
		_form = [[SZForm alloc] initWithWidth:290.0];
		[_form addItem:[NSDictionary dictionaryWithObjects:
						[NSArray arrayWithObjects:@"Email", [NSNumber numberWithInt:UIKeyboardTypeEmailAddress], nil] forKeys:
						[NSArray arrayWithObjects:FORM_PLACEHOLDER, FORM_INPUT_TYPE, nil]] isLastItem:YES];
		[_form setCenter:CGPointMake(160.0, 300.0)];
		[_form setScrollContainer:self.view];
	}
	return _form;
}

#pragma mark - UI elements first view (non-properties)

- (UITextView*)noWorriesMessage {
	UITextView* noWorriesMessage = [[UITextView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 100.0)];
	[noWorriesMessage setFont:[SZGlobalConstants fontWithFontType:SZFontBold size:24.0]];
	[noWorriesMessage setTextColor:[SZGlobalConstants darkPetrol]];
	[noWorriesMessage setUserInteractionEnabled:NO];
	[noWorriesMessage applyWhiteShadow];
	[noWorriesMessage setTextAlignment:NSTextAlignmentCenter];
	[noWorriesMessage setText:@"No worries!"];
	[noWorriesMessage setCenter:CGPointMake(160.0, 90.0)];
	return noWorriesMessage;
}

- (UITextView*)resetPasswordMessage {
	UITextView* resetPasswordMessage = [[UITextView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 180.0)];
	[resetPasswordMessage setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:15.0]];
	[resetPasswordMessage setTextColor:[SZGlobalConstants darkGray]];
	[resetPasswordMessage setUserInteractionEnabled:NO];
	[resetPasswordMessage applyWhiteShadow];
	[resetPasswordMessage setTextAlignment:NSTextAlignmentCenter];
	[resetPasswordMessage setText:@"You can easily reset your password.\n\nWe'll send an Email to the\naddress you provide with further\ninstructions on how to create\nyour new password."];
	[resetPasswordMessage setCenter:CGPointMake(160.0, 190.0)];
	return resetPasswordMessage;
}

- (SZButton*)resetPasswordButton {
	SZButton* resetPasswordButton = [[SZButton alloc] initWithColor:SZButtonColorPetrol size:SZButtonSizeLarge width:290.0];
	[resetPasswordButton setCenter:CGPointMake(160.0, 350.0)];
	[resetPasswordButton addTarget:self action:@selector(resetPasswordTapped:) forControlEvents:UIControlEventTouchUpInside];
	[resetPasswordButton setMultilineTitle:@"Reset Password" font:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:16.0] lineSpacing:0.0];
	return resetPasswordButton;
}

#pragma mark - UI elements second view (non-properties)

- (UIImageView*)checkmark {
	UIImageView* checkMark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark_big"]];
	[checkMark setCenter:CGPointMake(170.0, 135.0)];
	return checkMark;
}

- (UITextView*)emailSentMessage {
	UITextView* emailSentMessage = [[UITextView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 100.0)];
	[emailSentMessage setFont:[SZGlobalConstants fontWithFontType:SZFontBold size:24.0]];
	[emailSentMessage setTextColor:[SZGlobalConstants darkPetrol]];
	[emailSentMessage setUserInteractionEnabled:NO];
	[emailSentMessage applyWhiteShadow];
	[emailSentMessage setTextAlignment:NSTextAlignmentCenter];
	[emailSentMessage setText:@"An Email has been sent."];
	[emailSentMessage setCenter:CGPointMake(160.0, 90.0)];
	return emailSentMessage;
}

- (UITextView*)checkInboxMessage {
	UITextView* checkInboxMessage = [[UITextView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 180.0)];
	[checkInboxMessage setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:15.0]];
	[checkInboxMessage setTextColor:[SZGlobalConstants darkGray]];
	[checkInboxMessage setUserInteractionEnabled:NO];
	[checkInboxMessage applyWhiteShadow];
	[checkInboxMessage setTextAlignment:NSTextAlignmentCenter];
	[checkInboxMessage setText:@"Please check your inbox\nand follow the instructions\nin the Email we sent you.\nAfterwards you can sign in\nwith your new password."];
	[checkInboxMessage setCenter:CGPointMake(160.0, 280.0)];
	return checkInboxMessage;
}

- (SZButton*)backToSignInButton {
	SZButton* backToSignInButton = [[SZButton alloc] initWithColor:SZButtonColorPetrol size:SZButtonSizeLarge width:290.0];
	[backToSignInButton setCenter:CGPointMake(160.0, 350.0)];
	[backToSignInButton addTarget:self action:@selector(goBackTapped:) forControlEvents:UIControlEventTouchUpInside];
	[backToSignInButton setMultilineTitle:@"Go Back & Sign In" font:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:16.0] lineSpacing:0.0];
	return backToSignInButton;
}

#pragma mark - User actions

- (void)resetPasswordTapped:(id)sender {
	
	MBProgressHUD* hud = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:hud];
	[hud setDimBackground:YES];
	[hud setRemoveFromSuperViewOnHide:YES];
	[hud show:YES];
	
	[PFUser requestPasswordResetForEmailInBackground:[[self.form userInputs] valueForKey:@"Email"] block:^(BOOL succeeded, NSError *error) {
		[hud hide:YES];
		if (succeeded) {
			for (UIView* subview in self.view.subviews) {
				[subview removeFromSuperview];
			}
			[self.view addSubview:[self emailSentMessage]];
			[self.view addSubview:[self checkmark]];
			[self.view addSubview:[self checkInboxMessage]];
			[self.view addSubview:[self backToSignInButton]];
		}
		else {
			UIAlertView* alertView = [SZUtils alertViewForError:error delegate:nil];
			[alertView addButtonWithTitle:@"Okay"];
			[alertView show];
		}
	}];
}

- (void)goBackTapped:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

@end
