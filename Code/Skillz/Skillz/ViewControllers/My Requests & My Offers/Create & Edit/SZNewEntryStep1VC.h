//
//  SZNewEntryStep1VC.h
//  Skillz
//
//  Created by Julia Roggatz on 25.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZStepVC.h"
#import "SZForm.h"

/**
 This class represents the first step of creating or editing an entry. Asks the user to specify category & subcategory.
 */
@interface SZNewEntryStep1VC : SZStepVC <SZFormDelegate>

/**
 Creates an SZNewEntryStep1VC instance with a given entry.
 @param entry The <SZEntryObject> which has just been created or which should be edited.
 @return An SZNewEntryStep1VC instance
 */
- (id)initWithEntry:(SZEntryObject*)entry;

@end
