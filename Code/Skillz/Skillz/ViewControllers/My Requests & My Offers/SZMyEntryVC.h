//
//  SZMyRequestVC.h
//  Skillz
//
//  Created by Julia Roggatz on 02.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZEntryObject.h"

/**
 This class represents a detail view of an entry that belongs to the current user. Gives the user the possibility to delete or edit the entry.
 */
@interface SZMyEntryVC : SZViewController <UIAlertViewDelegate>

/**
 Creates an SZMyEntryVC instance with a given entry.
 @param entry The <SZEntryObject> to display.
 @return An SZMyEntryVC instance
 */
- (id)initWithEntry:(SZEntryObject*)entry;

@end
