//
//  SZStringConstants.h
//  Skillz
//
//  Created by Julia Roggatz on 20.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

/**
 The SZGlobalConstants class provides convenient access to commonly used properties, mainly comments and fonts.
 
 It contains only static functions. While it's theoretically possible to instantiate the SZGlobalConstants class, there would be no point in doing so, since an instance of this class would be nothing more than a generic NSObject instance.
 The SZGlobalConstants class is imported into the project's prexif header and thus available by default in all other classes without he need to explicitly import it again.
 */

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

#define NOTIF_SIGN_UP_SUCCESS @"Sign Up Success"
#define NOTIF_REQUEST_PASSWORD @"Request Password"
#define NOTIF_ENTRY_UPDATED @"Entry Updated"
#define NOTIF_FILTER_OR_SORT_MENU_HIDDEN @"Filter or Sort Menu Hidden"
#define NOTIF_LEFT_SWIPE @"Right Swipe"
#define NOTIF_MESSAGES_UPDATED @"Messages Updated"
#define NOTIF_SORT @"Sort"
#define NOTIF_FILTER @"Filter"

typedef enum {
	SZEntryTypeRequest,
	SZEntryTypeOffer
} SZEntryType;

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

#define MilesToMeters(MILES) MILES * 1609.344
#define MetersToMiles(METERS) METERS / 1609.344

@interface SZGlobalConstants : NSObject

/** @name Obtaining color objects */

/**
 Static function to obtain a color object representing the app's typical petrol color
 @return A color object representing the app's typical petrol color
 */
+ (UIColor*)petrol;

/**
 Static function to obtain a color object representing the app's typical dark petrol color (primarily used in text labels)
 @return A color object representing the app's typical dark petrol color
 */
+ (UIColor*)darkPetrol;

/**
 Static function to obtain a color object representing a very dark petrol color, used as the tint color for navigation bars
 @return A color object representing a very dark petrol color
 */
+ (UIColor*)veryDarkPetrol;

/**
 Static function to obtain a color object representing the app's typical orange color
 @return A color object representing the app's typical orange color
 */
+ (UIColor*)orange;

/**
 Static function to obtain a color object representing a light gray color
 @return A color object representing a light gray color
 */
+ (UIColor*)lightGray;

/**
 Static function to obtain a color object representing a medium gray color
 @return A color object representing a medium gray color
 */
+ (UIColor*)gray;

/**
 Static function to obtain a color object representing a dark gray color
 @return A color object representing a dark gray color
 */
+ (UIColor*)darkGray;

/**
 Static function to obtain a color object representing the color of a menu cell
 @return A color object representing the color of a menu cell
 */
+ (UIColor*)menuCellColor;

/**
 Static function to obtain a color object representing the color of a menu section
 @return A color object representing the color of a menu section
 */
+ (UIColor*)menuSectionColor;

/**
 Static function to obtain a color object representing the text color of a menu cell
 @return A color object representing the text color of a menu cell
 */
+ (UIColor*)menuCellTextColor;

/**
 Static function to obtain a color object representing the selected text color of a menu cell
 @return A color object representing the selected text color of a menu cell
 */
+ (UIColor*)menuCellTextSelectedColor;

/**
 Static function to obtain a color object representing the text color of a menu section
 @return A color object representing the text color of a menu section
 */
+ (UIColor*)menuSectionTextColor;

/** @name Obtaining font objects */

/**
 Static function to obtain a font object of the app's standard font (OpenSans) with a specified font size and font face
 @param fontType the font face for the desired font object. Uses the `SZFontType` enumeration. Allowed input parameters are:
 
 - `SZFontBold`
 - `SZFontBoldItalic`
 - `SZFontExtraBold`
 - `SZFontExtraBoldItalic`
 - `SZFontItalic`
 - `SZFontLight`
 - `SZFontLightItalic`
 - `SZFontRegular`
 - `SZFontSemiBold`
 - `SZFontSemiBoldItalic`
 
 @param size the desired font size
 @return A font object with the specified face and size
 */
+ (UIFont*)fontWithFontType:(SZFontType)fontType size:(CGFloat)size;

/** @name Obtaining an array of states */

/**
 Static function to obtain an array containing string representations of U.S. states. Used for the picker view in address forms.
 @return An array containing string representations of U.S. states
 */
+ (NSArray*)statesArray;

/** @name Obtaining categories and subcategories */

@end
