//
//  SZUtils.m
//  Skillz
//
//  Created by Julia Roggatz on 21.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZUtils.h"

@implementation SZUtils

+ (UIAlertView*)alertViewForError:(NSError*)error delegate:(id)delegate {
	NSString* errorTitle;
	NSString* errorMessage;
	if (error.code == 101) {
		errorTitle = @"Incorrect password or Email address.";
		errorMessage = @"If you forgot your password, you can request a new one through the \"Forgot Password?\" link below the \"Sign In\" button.";
	}
	else if (error.code == 202 || error.code == 203) {
		errorTitle = @"The Email address is already taken.";
		errorMessage = @"Please use a different Email address. If you already have an account, you can sign in directly or request a new password.";
	}
	else if (error.code == 125) {
		errorTitle = @"Invalid Email address";
		errorMessage = @"The Email address you provided is invalid. Please check for typos and give it another try.";
	}
	else if (error.code == 205) {
		errorTitle = @"Email address not found";
		errorMessage = @"We couldn't find you. Maybe you have a type in the address you provided or you used a different Email address to sign up.";
	}
	else {
		errorTitle = @"An unknown error occured.";
		errorMessage = @"Please try again.";
	}
	return [[UIAlertView alloc] initWithTitle:errorTitle message:errorMessage delegate:delegate cancelButtonTitle:nil otherButtonTitles: nil];
}

+ (NSString*)formattedDateFromDate:(NSDate*)date {
	NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"EEE, MMM d, YYYY - hh:mm aaa"];
	return [dateFormat stringFromDate:date];
}

+ (NSDate*)rightNowRoundedUp {
	
	NSDate* date = [NSDate date];
	NSDateComponents *time = [[NSCalendar currentCalendar]
    						  components:NSHourCalendarUnit | NSMinuteCalendarUnit
    						  fromDate:date];
    NSInteger minutes = [time minute];
    NSInteger remain = minutes % 15;
	date = [date dateByAddingTimeInterval:60*(15-remain)];
	
	NSInteger roundedTimeIgnoreSeconds = [date timeIntervalSinceReferenceDate];
	NSDate *roundedDate = [NSDate dateWithTimeIntervalSinceReferenceDate:roundedTimeIgnoreSeconds];
    return roundedDate;
}

+ (NSNumber*)numberFromDecimalString:(NSString*)string {
	NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
	[formatter setNumberStyle:NSNumberFormatterDecimalStyle];
	return [formatter numberFromString:string];
}

+ (UIView*)separatorViewWithHeight:(CGFloat)height {
	UIView* separator = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 3.0, height)];
	
	UIView* left = [[UIView alloc] initWithFrame:CGRectMake(0.0, 1.0, 1.0, height - 2.0)];
	[left setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.9]];
	
	UIView* middle = [[UIView alloc] initWithFrame:CGRectMake(1.0, 0.0, 1.0, height)];
	[middle setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4]];
	
	UIView* right = [[UIView alloc] initWithFrame:CGRectMake(2.0, 1.0, 1.0, height - 2.0)];
	[right setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.9]];
	
	[separator addSubview:left];
	[separator addSubview:middle];
	[separator addSubview:right];
	
	return separator;
}

+ (NSArray*)sortedCategories {
	NSMutableArray* categories = [[NSMutableArray alloc] init];
	NSArray* unsortedCategories = [[NSUserDefaults standardUserDefaults] objectForKey:@"categories"];
	for (NSDictionary* categoryDict in unsortedCategories) {
		[categories addObject:[categoryDict objectForKey:@"categoryName"]];
	}
	categories = [NSMutableArray arrayWithArray:[categories sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
	[categories removeObject:@"Miscellaneous"]; // remove the "misc" category from somewhere in the middle of the array
	[categories addObject:@"Miscellaneous"];    // and put it back at the end. "misc" should not be in alphabetical order.
	
	return categories;
}

+ (NSArray*)sortedSubcategoriesForCategory:(NSString*)category {
	NSArray* subcategories;
	NSArray* unsortedSubcategories = [[NSUserDefaults standardUserDefaults] objectForKey:@"categories"];
	for (NSDictionary* categoryDict in unsortedSubcategories) {
		if ([[categoryDict valueForKey:@"categoryName"] isEqualToString:category]) {
			subcategories = [[categoryDict valueForKey:@"subcategories"] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
			break;
		}
	}
	return subcategories;
}

+ (UIView*)starViewForReviewArray:(NSArray*)reviews size:(SZStarViewSize)size {
	
	CGFloat totalPoints = 0;
	for (NSNumber* points in reviews) {
		totalPoints += points.floatValue;
	}
	CGFloat average = totalPoints / [reviews count];
	NSLog(@"average: %f", average);
	
	NSInteger fullStars = floorf(average);
	NSInteger halfStars = 0;
	if ((average - fullStars) >= 0.25 && (average - fullStars) <= 0.75) halfStars = 1;
	else if ((average - fullStars) > 0.75) fullStars++;
	NSInteger emptyStars = 5 - fullStars - halfStars;
	
	CGSize viewSize;
	CGFloat spacing;
	NSString* appendix = @"";
	switch (size) {
		case SZStarViewSizeSmall:
			viewSize = CGSizeMake(50.0, 10.0);
			spacing = 10.0;
			appendix = @"_small";
			break;
		case SZStarViewSizeMedium:
			viewSize = CGSizeMake(100.0, 20.0);
			spacing = 20.0;
			break;
	}
	
	UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, viewSize.width, viewSize.height)];
	CGFloat xPos = 0;
	for (int i = 0; i < fullStars; i++) {
		UIImageView* fullStar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"star_full%@", appendix]]];
		[fullStar setFrame:CGRectMake(xPos, 0.0, fullStar.frame.size.width, fullStar.frame.size.height)];
		[view addSubview:fullStar];
		xPos += spacing;
	}
	for (int i = 0; i < halfStars; i++) {
		UIImageView* halfStar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"star_half%@", appendix]]];
		[halfStar setFrame:CGRectMake(xPos, 0.0, halfStar.frame.size.width, halfStar.frame.size.height)];
		[view addSubview:halfStar];
		xPos += spacing;
	}
	for (int i = 0; i < emptyStars; i++) {
		UIImageView* emptyStar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"star_empty%@", appendix]]];
		[emptyStar setFrame:CGRectMake(xPos, 0.0, emptyStar.frame.size.width, emptyStar.frame.size.height)];
		[view addSubview:emptyStar];
		xPos += spacing;
	}
	
	return view;
	
}

+ (BOOL)currentUserisWithinDistance:(NSNumber*)distance ofAddress:(NSDictionary*)address {
	return YES;
}


@end
