//
//  SZStringConstants.h
//  Skillz
//
//  Created by Julia Roggatz on 20.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

#define NOTIF_SIGN_UP_SUCCESS @"Sign Up Success"
#define NOTIF_REQUEST_PASSWORD @"Request Password"
#define NOTIF_ENTRY_UPDATED @"Entry Updated"
#define NOTIF_FILTER_OR_SORT_MENU_HIDDEN @"Filter or Sort Menu Hidden"

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
	SZButtonSizeSmall,
	SZButtonSizeMedium,
	SZButtonSizeLarge,
	SZButtonSizeExtraLarge
} SZButtonSize;

typedef enum {
	SZButtonColorPetrol,
	SZButtonColorOrange
} SZButtonColor;

typedef enum {
	SZFormFieldInputTypeKeyboard,
	SZFormFieldInputTypePicker,
	SZFormFieldInputTypeDatePicker
} SZFormFieldInputType;

typedef enum {
	SZEntryLocationWillGoSomewhereElse,
	SZEntryLocationWillStayAtHome,
	SZEntryLocationRemote
} SZEntryLocationType;

typedef enum {
	SZEntryPriceNegotiable,
	SZEntryPriceFixedPerHour,
	SZEntryPriceFixedPerJob
} SZEntryPriceType;

typedef enum {
	SZStarViewSizeSmall,
	SZStarViewSizeMedium
} SZStarViewSize;

typedef enum {
	SZUserPhotoViewSizeSmall,
	SZUserPhotoViewSizeMedium,
	SZUserPhotoViewSizeLarge
} SZUserPhotoViewSize;

typedef enum {
	SZNavigationMenu,
	SZNavigationSortOrFiler
} SZNavigationType;

#define MilesToMeters(MILES) MILES * 1609.344
#define MetersToMiles(METERS) METERS / 1609.344

@interface SZGlobalConstants : NSObject

+ (UIColor*)petrol;
+ (UIColor*)darkPetrol;
+ (UIColor*)veryDarkPetrol;
+ (UIColor*)orange;
+ (UIColor*)lightGray;
+ (UIColor*)gray;
+ (UIColor*)darkGray;
+ (UIColor*)menuCellColor;
+ (UIColor*)menuSectionColor;
+ (UIColor*)menuCellTextColor;
+ (UIColor*)menuCellTextSelectedColor;
+ (UIColor*)menuSectionTextColor;
+ (UIFont*)fontWithFontType:(SZFontType)fontType size:(CGFloat)size;
+ (NSArray*)statesArray;

@end
