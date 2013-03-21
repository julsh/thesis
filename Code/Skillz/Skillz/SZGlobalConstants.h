//
//  SZStringConstants.h
//  Skillz
//
//  Created by Julia Roggatz on 20.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FORM_PLACEHOLDER @"Placeholder"
#define FORM_INPUT_TYPE @"InputType"
#define INPUT_TYPE_PICKER 1001
#define INPUT_TYPE_PASSWORD 1002
#define PICKER_OPTIONS @"PickerOptions"

typedef enum {
	SZFontBold,
	SZFontBoldItalic,
	SZFontExtraBold,
	SZFontExtraBoldItalic,
	SZFontItalic,
	SZFontLight,
	SZFontLightItalic,
	SZFontRegular,
	SZFontSemiBold,
	SZFontSemiBoldItalic
} SZFontType;

typedef enum {
	SZButtonSizeBig,
	SZButtonSizeMedium,
	SZButtonSizeSmall
} SZButtonSize;

typedef enum {
	SZButtonColorPetrol,
	SZButtonColorOrange
} SZButtonColor;

@interface SZGlobalConstants : NSObject

+ (UIColor*)petrol;
+ (UIColor*)darkPetrol;
+ (UIColor*)darkGray;

@end
