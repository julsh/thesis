//
//  SZDataManager.h
//  Skillz
//
//  Created by Julia Roggatz on 31.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSMutableArray+Stack.h"
#import "SZEntryVO.h"

@interface SZDataManager : NSObject

@property (nonatomic, strong) id currentEntry;
@property (nonatomic, assign) SZEntryType currentEntryType;
@property (nonatomic, assign) BOOL currentEntryIsNew;
//@property (nonatomic, strong) SZUserVO* currentUser;
@property (nonatomic, strong) NSMutableArray* viewControllerStack;

+ (SZDataManager*)sharedInstance;
- (void)addEntryToUserCache:(SZEntryVO*)entry type:(SZEntryType)type;
- (void)updateEntryCacheWithEntry:(SZEntryVO*)entry type:(SZEntryType)type;
- (void)removeEntryFromCache:(SZEntryVO*)entry type:(SZEntryType)type;

@end
