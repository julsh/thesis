//
//  SZTitleView.h
//  Skillz
//
//  Created by Julia Roggatz on 01.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 This class takes care of displaying and laying out the title view that is displayed within an <SZEntryView>.
 */
@interface SZTitleView : UIView

/**
 Initializes the `SZTitleView` with a given title and category.
 @param title The title to display
 @param category The category to display
 @return An instance of `SZTitleView`
 */
- (id)initWithTitle:(NSString*)title category:(NSString*)category;

@end
