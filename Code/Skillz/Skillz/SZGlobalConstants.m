//
//  SZStringConstants.m
//  Skillz
//
//  Created by Julia Roggatz on 20.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZGlobalConstants.h"

@implementation SZGlobalConstants

+ (UIColor*)petrol {
	return [UIColor colorWithHue:0.094 saturation:0.392 brightness:0.42 alpha:1.0];
}
+ (UIColor*)darkPetrol {
	return [UIColor colorWithRed:0.0 green:0.255 blue:0.255 alpha:1.0];
}

+ (UIColor*)darkGray {
	return [UIColor colorWithHue:0.0 saturation:0.0 brightness:0.1 alpha:1.0];
}

+ (UIFont*)fontWithFontType:(SZFontType)fontType size:(CGFloat)size {
	switch (fontType) {
		case SZFontBold:
			return [UIFont fontWithName:@"OpenSans-Bold" size:size];
		case SZFontBoldItalic:
			return [UIFont fontWithName:@"OpenSans-BoldItalic" size:size];
		case SZFontExtraBold:
			return [UIFont fontWithName:@"OpenSans-Extrabold" size:size];
		case SZFontExtraBoldItalic:
			return [UIFont fontWithName:@"OpenSans-ExtraboldItalic" size:size];
		case SZFontItalic:
			return [UIFont fontWithName:@"OpenSans-Italic" size:size];
		case SZFontLight:
			return [UIFont fontWithName:@"OpenSans-Light" size:size];
		case SZFontLightItalic:
			return [UIFont fontWithName:@"OpenSansLight-Italic" size:size];
		case SZFontRegular:
			return [UIFont fontWithName:@"OpenSans" size:size];
		case SZFontSemiBold:
			return [UIFont fontWithName:@"OpenSans-Semibold" size:size];
		case SZFontSemiBoldItalic:
			return [UIFont fontWithName:@"OpenSans-SemiboldItalic" size:size];
	}
}

@end
