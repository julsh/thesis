//
//  SZDataManager.h
//  Skillz
//
//  Created by Julia Roggatz on 31.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSMutableArray+Stack.h"
#import "SZEntryObject.h"

#define REQUESTS 				@"requests"
#define OFFERS					@"offers"
#define LAST_ENTERED_ADDRESS 	@"lastEnteredAddress"

@interface SZDataManager : NSObject

@property (nonatomic, strong) id currentEntry;
@property (nonatomic, assign) SZEntryType currentEntryType;
@property (nonatomic, assign) BOOL currentEntryIsNew;
@property (nonatomic, strong) NSMutableArray* viewControllerStack;

+ (SZDataManager*)sharedInstance;
- (void)updateCaches;
- (void)addEntryToUserCache:(SZEntryObject*)entry type:(SZEntryType)type;
- (void)updateEntryCacheWithEntry:(SZEntryObject*)entry type:(SZEntryType)type;
- (void)removeEntryFromCache:(SZEntryObject*)entry type:(SZEntryType)type;
- (void)saveLastEnderedAddress:(NSDictionary*)address;
- (NSDictionary*)lastEnteredAddress;

@end
