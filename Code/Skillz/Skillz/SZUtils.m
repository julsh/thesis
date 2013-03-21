//
//  SZUtils.m
//  Skillz
//
//  Created by Julia Roggatz on 21.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZUtils.h"

@implementation SZUtils

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
