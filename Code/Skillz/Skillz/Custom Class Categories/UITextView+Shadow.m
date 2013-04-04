//
//  UITextView+Shadow.m
//  Skillz
//
//  Created by Julia Roggatz on 23.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "UITextView+Shadow.h"

@implementation UITextView (Shadow)

- (void) applyWhiteShadow {
	
	[self setBackgroundColor:[UIColor clearColor]];
	self.layer.shadowColor = [UIColor whiteColor].CGColor;
	self.layer.shadowOffset = CGSizeMake(0.0, 1.0);
	self.layer.shadowOpacity = 1.0f;
	self.layer.shadowRadius = 0.0f;
}

- (void) applyBlackShadow {
	[self setBackgroundColor:[UIColor clearColor]];
	self.layer.shadowColor = [UIColor blackColor].CGColor;
	self.layer.shadowOffset = CGSizeMake(0.0, -1.0);
	self.layer.shadowOpacity = 1.0f;
	self.layer.shadowRadius = 0.0f;
}

@end
