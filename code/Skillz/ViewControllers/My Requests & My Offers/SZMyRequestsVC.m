//
//  SZMyRequestsVC.m
//  Skillz
//
//  Created by Julia Roggatz on 02.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZMyRequestsVC.h"

@implementation SZMyRequestsVC

- (id)init {
	return (SZMyRequestsVC*)[[SZMyEntriesVC alloc] initWithEntryType:SZEntryTypeRequest];
}

@end
