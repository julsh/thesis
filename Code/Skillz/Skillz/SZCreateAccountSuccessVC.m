//
//  SZCreateAccountSuccessViewController.m
//  Skillz
//
//  Created by Julia Roggatz on 23.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <Parse/Parse.h>

#import "SZCreateAccountSuccessVC.h"

#import "UITextView+Shadow.h"
#import "SZUtils.h"
#import "SZButton.h"

@interface SZCreateAccountSuccessVC ()

@property (nonatomic, strong) PFUser* user;

@end

@implementation SZCreateAccountSuccessVC

@synthesize user = _user;

- (void)initWithUser:(PFUser*)user {
	self.user = user;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.view addSubview:[self thankYouMessage]];
	[self.view addSubview:[self verifyEmailMessage]];
	[self.view addSubview:[self okayButton]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITextView*)thankYouMessage {
	UITextView* thankYouMessage = [[UITextView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 100.0)];
	[thankYouMessage setFont:[SZGlobalConstants fontWithFontType:SZFontBold size:24.0]];
	[thankYouMessage setTextColor:[SZGlobalConstants darkPetrol]];
	[thankYouMessage setUserInteractionEnabled:NO];
	[thankYouMessage applyWhiteShadow];
	[thankYouMessage setTextAlignment:NSTextAlignmentCenter];
	[thankYouMessage setText:@"Thank you for\nsigning up!"];
	[thankYouMessage setCenter:CGPointMake(160.0, 80.0)];
	return thankYouMessage;
}

- (UITextView*)verifyEmailMessage {
	UITextView* verifyEmailMessage = [[UITextView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 180.0)];
	[verifyEmailMessage setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:15.0]];
	[verifyEmailMessage setTextColor:[SZGlobalConstants darkGray]];
	[verifyEmailMessage setUserInteractionEnabled:NO];
	[verifyEmailMessage applyWhiteShadow];
	[verifyEmailMessage setTextAlignment:NSTextAlignmentCenter];
	[verifyEmailMessage setText:[NSString stringWithFormat:@"A confirmation email has been sent to\n%@.\n\nPlease check your inbox and\nfollow the instructions\nprovided in the email\nto complete your registration.", self.user.email]];
	[verifyEmailMessage setCenter:CGPointMake(160.0, 220.0)];
	return verifyEmailMessage;
}

- (SZButton*)okayButton {
	SZButton* okayButton = [[SZButton alloc] initWithColor:SZButtonColorPetrol size:SZButtonSizeLarge width:200.0];
	[okayButton setCenter:CGPointMake(160.0, 350.0)];
	[okayButton addTarget:self action:@selector(goToSignInVC:) forControlEvents:UIControlEventTouchUpInside];
	[okayButton setMultilineTitle:@"Okay!" font:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:16.0] lineSpacing:0.0];
	return okayButton;
}

- (void)goToSignInVC:(id)sender {
	
}

@end
