//
//  SZMyEntriesVC.h
//  Skillz
//
//  Created by Julia Roggatz on 04.05.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//


/**
 This class represents a list of either all offers or all requests that belong to a user. Will be subclassed by <SZMyRequestsVC> and <SZMyOffersVC> specifically. Also offers the possibility to create a new offer or request.
 */
@interface SZMyEntriesVC : SZViewController <UITableViewDataSource, UITableViewDelegate>

/**
 Creates and SZMyEntriesVC instance with a specific entry type. 
 
 @param entryType The entry type. Uses the `SZEntryType` enumerator. Allowed values are
 
 - `SZEntryTypeOffer`
 - `SZEntryTypeRequest`
 
 @return An SZMyEntriesVC instance
 */
- (id)initWithEntryType:(SZEntryType)entryType;

@end
