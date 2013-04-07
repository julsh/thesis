//
//  SZUtils.h
//  Skillz
//
//  Created by Julia Roggatz on 21.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZUtils : NSObject

#define LogRect(RECT) NSLog(@"%s: (%0.0f, %0.0f) %0.0f x %0.0f", #RECT, RECT.origin.x, RECT.origin.y, RECT.size.width, RECT.size.height)

+ (UIAlertView*)alertViewForError:(NSError*)error delegate:(id)delegate;
+ (NSString*)formattedDateFromDate:(NSDate*)date;
+ (NSDate*)rightNowRoundedUp;
+ (NSNumber*)numberFromDecimalString:(NSString*)string;
+ (UIView*)separatorViewWithHeight:(CGFloat)height;
+ (NSArray*)sortedCategories;
+ (NSArray*)sortedSubcategoriesForCategory:(NSString*)category;
+ (UIView*)starViewForReviewArray:(NSArray*)reviews size:(SZStarViewSize)size;
+ (BOOL)currentUserisWithinDistance:(NSNumber*)distance ofAddress:(NSDictionary*)address;
//+ (UIView*)

@end
