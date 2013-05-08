//
//  SZDescriptionView.h
//  Skillz
//
//  Created by Julia Roggatz on 01.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 This class takes care of displaying and laying out the entry description area within an <SZEntryView>.  
 */
@interface SZDescriptionView : UIView

/**
 Initializes the `SZDescriptionView` with a given user
 @param description The description that belongs to the entry that is displayed.
 @return An instance of `SZDescriptionView`
 */
- (id)initWithDescription:(NSString*)description;

@end
