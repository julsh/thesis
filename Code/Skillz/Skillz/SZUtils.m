//
//  SZUtils.m
//  Skillz
//
//  Created by Julia Roggatz on 21.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZUtils.h"

@implementation SZUtils

+ (UIAlertView*)alertViewForError:(NSError*)error delegate:(id)delegate {
	NSString* errorTitle;
	NSString* errorMessage;
	if (error.code == 101) {
		errorTitle = @"Incorrect password or Email address.";
		errorMessage = @"If you forgot your password, you can request a new one through the \"Forgot Password?\" link below the \"Sign In\" button.";
	}
	else if (error.code == 202 || error.code == 203) {
		errorTitle = @"The Email address is already taken.";
		errorMessage = @"Please use a different Email address. If you already have an account, you can sign in directly or request a new password.";
	}
	else if (error.code == 125) {
		errorTitle = @"Invalid Email address";
		errorMessage = @"The Email address you provided is invalid. Please check for typos and give it another try.";
	}
	else if (error.code == 205) {
		errorTitle = @"Email address not found";
		errorMessage = @"We couldn't find you. Maybe you have a type in the address you provided or you used a different Email address to sign up.";
	}
	else {
		errorTitle = @"An unknown error occured.";
		errorMessage = @"Please try again.";
	}
	return [[UIAlertView alloc] initWithTitle:errorTitle message:errorMessage delegate:delegate cancelButtonTitle:nil otherButtonTitles: nil];
}



@end
