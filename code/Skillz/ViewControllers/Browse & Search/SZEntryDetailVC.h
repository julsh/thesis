//
//  SZEntryDetailVC.h
//  Skillz
//
//  Created by Julia Roggatz on 07.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZEntryObject.h"

/** This class represents a view controller displaying details about an entry. See <SZEntryView> for details about how the view is layed out.
 */
@interface SZEntryDetailVC : SZViewController

/** Initializes an instance of SZEntryDetailVC with a given <SZEntryObject>
 @param entry The <SZEntryObject> to display
 */
- (id)initWithEntry:(SZEntryObject*)entry;

@end
