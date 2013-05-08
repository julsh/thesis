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
#import "SZSignInVC.h"

@interface SZCreateAccountSuccessVC ()

@property (nonatomic, strong) PFUser* user;

@end

@implementation SZCreateAccountSuccessVC

@synthesize user = _user;

- (id)initWithUser:(PFUser*)user {
	self = [super init];
	if (self) {
		self.user = user;
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[self addMenuButton];
	[self.view addSubview:[self thankYouMessage]];
	[self.view addSubview:[self verifyEmailMessage]];
	[self.view addSubview:[self okayButton]];

}

#pragma mark - UI elements (non-properties)

- (UITextView*)thankYouMessage {
	UITextView* thankYouMessage = [[UITextView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 100.0)];
	[thankYouMessage setFont:[SZGlobalConstants fontWithFontType:SZFontBold size:24.0]];
	[thankYouMessage setTextColor:[SZGlobalConstants darkPetrol]];
	[thankYouMessage setUserInteractionEnabled:NO];
	[thankYouMessage applyWhiteShadow];
	[thankYouMessage setTextAlignment:NSTextAlignmentCenter];
	[thankYouMessage setText:@"Welcome to the\nSkillz community!"];
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
	SZButton* okayButton = [SZButton buttonWithColor:SZButtonColorPetrol size:SZButtonSizeLarge width:200.0];
	[okayButton setCenter:CGPointMake(160.0, 350.0)];
	[okayButton addTarget:self action:@selector(goToSignInVC:) forControlEvents:UIControlEventTouchUpInside];
	[okayButton setMultilineTitle:@"Okay!" font:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:16.0] lineSpacing:0.0];
	return okayButton;
}

#pragma mark - User actions

- (void)goToSignInVC:(id)sender {
	[UIView
	 transitionWithView:self.navigationController.view
	 duration:0.5
	 options:UIViewAnimationOptionTransitionCrossDissolve
	 animations:^{
		 [self.navigationController setViewControllers:[NSArray arrayWithObject:[[SZSignInVC alloc] init]]];
	 }
	 completion:nil];
	
}

@end
