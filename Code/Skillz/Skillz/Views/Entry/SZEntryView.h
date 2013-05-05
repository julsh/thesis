//
//  SZEntryView.h
//  Skillz
//
//  Created by Julia Roggatz on 31.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZEntryObject.h"

/**
 This class takes care of displaying and laying out an entry.
 */

@interface SZEntryView : UIView

/**
 Initializes the `SZEntryView` with a given <SZEntryObject>.
 @param entry The entry which is to be displayed by the `SZEntryView`
 @return An instance of `SZEntryView`
 */
- (id)initWithEntry:(SZEntryObject*)entry;

@end
