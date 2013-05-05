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
	return [UIColor colorWithHue:0.52 saturation:0.78 brightness:0.42 alpha:1.0];
}

+ (UIColor*)darkPetrol {
	return [UIColor colorWithHue:0.52 saturation:1.0 brightness:0.3 alpha:1.0];
}

+ (UIColor*)veryDarkPetrol {
	return [UIColor colorWithHue:0.52 saturation:1.0 brightness:0.2 alpha:1.0];
}

+ (UIColor*)orange {
	return [UIColor colorWithHue:0.078 saturation:0.99 brightness:0.82 alpha:1.0];
}

+ (UIColor*)lightGray {
	return [UIColor colorWithHue:0.52 saturation:0.05 brightness:0.76 alpha:1.0];
}

+ (UIColor*)gray {
	return [UIColor colorWithHue:0.0 saturation:0.0 brightness:0.3 alpha:1.0];
}

+ (UIColor*)darkGray {
	return [UIColor colorWithHue:0.0 saturation:0.0 brightness:0.1 alpha:1.0];
}

+ (UIColor*)menuCellColor {
	return [UIColor colorWithHue:0.52 saturation:0.9 brightness:0.2 alpha:1.0];
}

+ (UIColor*)menuSectionColor {
	return [UIColor colorWithHue:0.52 saturation:0.9 brightness:0.25 alpha:1.0];
}

+ (UIColor*)menuCellTextColor {
	return [UIColor colorWithHue:0.52 saturation:0.1 brightness:0.75 alpha:1.0];
}

+ (UIColor*)menuCellTextSelectedColor {
	return [UIColor colorWithHue:0.52 saturation:0.1 brightness:0.85 alpha:1.0];
}

+ (UIColor*)menuSectionTextColor {
	return [UIColor colorWithHue:0.52 saturation:0.1 brightness:0.65 alpha:1.0];
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

+ (NSArray*)statesArray {

	return [NSArray arrayWithObjects:
			@"Alabama",
			@"Alaska",
			@"Arizona",
			@"Arkansas",
			@"California",
			@"Colorado",
			@"Connecticut",
			@"Delaware",
			@"Florida",
			@"Georgia",
			@"Hawaii",
			@"Idaho",
			@"Illinois",
			@"Indiana",
			@"Iowa",
			@"Kansas",
			@"Kentucky",
			@"Louisiana",
			@"Maine",
			@"Maryland",
			@"Massachusetts",
			@"Michigan",
			@"Minnesota",
			@"Mississippi",
			@"Missouri",
			@"Montana",
			@"Nebraska",
			@"Nevada",
			@"New Hampshire",
			@"New Jersey",
			@"New Mexico",
			@"New York",
			@"North Carolina",
			@"North Dakota",
			@"Ohio",
			@"Oklahoma",
			@"Oregon",
			@"Pennsylvania",
			@"Rhode Island",
			@"South Carolina",
			@"South Dakota",
			@"Tennessee",
			@"Texas",
			@"Utah",
			@"Vermont",
			@"Virginia",
			@"Washington",
			@"West Virginia",
			@"Wisconsin",
			@"Wyoming",
			nil];

}


@end
