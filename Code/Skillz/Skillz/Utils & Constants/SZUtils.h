//
//  SZUtils.h
//  Skillz
//
//  Created by Julia Roggatz on 21.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

/**
 The SZUtils class provides some static convenience and helper methods that are used in different places of the application.
 While it's theoretically possible to instantiate the SZUtils class, there would be no point in doing so, since an instance of this class would be nothing more than a generic NSObject instance.
 */

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import "SZStarsView.h"

@interface SZUtils : NSObject

#define LogRect(RECT) NSLog(@"%s: (%0.0f, %0.0f) %0.0f x %0.0f", #RECT, RECT.origin.x, RECT.origin.y, RECT.size.width, RECT.size.height)

/** @name Static helper methods */

/**
 Helper method to genereate a `UIAlertView` object for a specific error code. The `UIAlertView` will display the error in humanly readable format depending on the error code.
 @param error the error object for which the alert view should be created
 @param delegate (optional) the delegate object that will handle user actions, if required
 @return A `UIAlertView` object to display the error in humanly readable format depending on the error code
 */
+ (UIAlertView*)alertViewForError:(NSError*)error delegate:(id)delegate;

/**
 Helper method to convert a `NSDate` object into a `NSString` object representing the date in a humanly readable format.
 @param date The `NSDate` object which to convert to a string
 @return An `NSString` object representing the date in a humanly readable format
 */
+ (NSString*)formattedDateFromDate:(NSDate*)date;

/**
 Helper method to obtain an NSDate object from the current time, rounded up to the next full 15 minutes (so 4:03 PM and 4:14 PM for example would both be rounded up to 4:15 PM. This method is used to set the start state for UIDatePickers that let the user select a time in 15 minute intervals.
 @return The `NSDate` object representing the current time, rounded up to the next full 15 minutes
 */
+ (NSDate*)rightNowRoundedUp;

/**
 Helper method to convert a decimal string into an NSNumber object.
 @param string The NSString object to be converted into a number
 @return The number object representing the string
 */
+ (NSNumber*)numberFromDecimalString:(NSString*)string;

/**
 Calculates the average from an array of numbers.
 @param numbers An array containing `NSNumber` objects
 @return The average of all numbers contained in the array
 */
+ (CGFloat)getAverageValueOfNumberArray:(NSArray*)numbers;

@end
