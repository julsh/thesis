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
- (void)addEntryToUserCache:(SZEntryObject*)entry;
- (void)updateEntryCacheWithEntry:(SZEntryObject*)entry;
- (void)removeEntryFromCache:(SZEntryObject*)entry;

- (void)saveLastEnderedAddress:(NSDictionary*)address;
- (NSDictionary*)lastEnteredAddress;

- (void)checkForNewMessagesWithCompletionBlock:(void(^)(BOOL finished))completionBlock;
- (void)addMessageToUserCache:(PFObject*)message completionBlock:(void(^)(BOOL finished))completionBlock;
- (void)updateMessageCacheWithCompletionBlock:(void(^)(BOOL finished))completionBlock;

@end
