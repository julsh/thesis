//
//  SZButton.m
//  Skillz
//
//  Created by Julia Roggatz on 21.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZButton.h"
#import "SZUtils.h"

@implementation SZButton

- (id)initWithColor:(SZButtonColor)color size:(SZButtonSize)size width:(CGFloat)width {
	
	NSString* prefix;
	switch (color) {
		case SZButtonColorPetrol:
			prefix = @"button_petrol";
			break;
		case SZButtonColorOrange:
			prefix = @"button_orange";
		default:
			break;
	}
	
	NSString* suffix;
	CGFloat height = 0.0;
	CGFloat fontSize = 0.0;
	switch (size) {
		case SZButtonSizeBig:
			suffix = @"_big";
			height = 40.0;
			fontSize = 18.0;
			break;
		case SZButtonSizeMedium:
			suffix = @"_medium";
			height = 30.0;
			fontSize = 14.0;
			break;
		case SZButtonSizeSmall:
			suffix = @"_small";
			height = 20.0;
			fontSize = 10.0;
			break;
		default:
			break;
	}
	
	UIImage* bgImage = [[UIImage imageNamed:[NSString stringWithFormat:@"%@%@", prefix, suffix]] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 30.0, 0.0, 30.0)];
	UIImage* selectedImage = [[UIImage imageNamed:[NSString stringWithFormat:@"%@%@%@", prefix, suffix, @"_down"]] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 30.0, 0.0, 30.0)];;
	
	self = [super initWithFrame:CGRectMake(0.0, 0.0, width, height)];
    if (self) {
        [self setBackgroundImage:bgImage forState:UIControlStateNormal];
		[self setBackgroundImage:selectedImage forState:UIControlStateHighlighted];
		
		[self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[self setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.8] forState:UIControlStateHighlighted];
		[self.titleLabel setFont:[SZUtils fontWithFontType:SZFontSemiBold size:fontSize]];
		[self.titleLabel setShadowColor:[UIColor blackColor]];
		[self.titleLabel setShadowOffset:CGSizeMake(0.0, -1.0)];
    }
    return self;
}

@end
