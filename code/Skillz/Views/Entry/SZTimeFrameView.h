//
//  SZTimeFrameView.h
//  Skillz
//
//  Created by Julia Roggatz on 01.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 This class takes care of displaying and laying out the time frame badge that is displayed within an <SZEntryView> if the corresponding entry has a time frame specified.
 */
@interface SZTimeFrameView : UIView

/**
 Initializes the `SZTitleView` with a given title and category.
 @param startDate The start date of the given time frame. Can be `nil`.
 @param endDate The start date of the given time frame.
 @return An instance of `SZTimeFrameView`
 */
- (id)initWithStartDate:(NSDate*)startDate endDate:(NSDate*)endDate;

@end
