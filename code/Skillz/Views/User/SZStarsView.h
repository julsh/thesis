//
//  SZStarsView.h
//  Skillz
//
//  Created by Julia Roggatz on 07.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	SZStarViewSizeSmall,
	SZStarViewSizeMedium
} SZStarViewSize;

/**
 This class represents a user's average review rating displayed as stars. Stars can be either empty, full, or half-full.
 
 
 Helper method that calculates the average review rating of a user based on all of their reviews and returns a star view as visual representation of this average review rating.
 @param reviews An array containing numbers that represent the user's reviews
 @param size The desired size of the star view. Uses the `SZStarViewSize` enumerator. Supported input parameters are:
 
 - `SZStarViewSizeSmall`
 - `SZStarViewSizeMedium`
 
 @return A star view as visual representation of the user's average review rating
 */
@interface SZStarsView : UIView

/**
 Initializes an SZStarsView with a given size.
 @param size The size of the stars view. Uses the `SZStarViewSize` enumerator. Supported values:
 
 - `SZStarViewSizeSmall`
 - `SZStarViewSizeMedium`
 
 @return An instance of `SZStarsView`
 */
- (id)initWithSize:(SZStarViewSize)size;

/** Sets the stars in an existing `SZStarsView` according to the review array that is passed in.
 @param reviews An `NSArray` containing number that represent individual review ratings.
 */
- (void)setStarsForReviewsArray:(NSArray*)reviews;

@end
