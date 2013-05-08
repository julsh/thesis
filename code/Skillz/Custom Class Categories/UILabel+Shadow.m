//
//  UILabel+Shadow.m
//  Skillz
//
//  Created by Julia Roggatz on 21.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "UILabel+Shadow.h"

@implementation UILabel (Shadow)

- (void) applyWhiteShadow {
	[self setBackgroundColor:[UIColor clearColor]];
	[self setShadowColor:[UIColor whiteColor]];
	[self setShadowOffset:CGSizeMake(0.0, 1.0)];
}

- (void) applyBlackShadow {
	[self setBackgroundColor:[UIColor clearColor]];
	[self setShadowColor:[UIColor blackColor]];
	[self setShadowOffset:CGSizeMake(0.0, -1.0)];
}

@end
