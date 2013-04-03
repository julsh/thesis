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

@property (nonatomic, strong) id currentObject;
@property (nonatomic, assign) BOOL currentObjectIsNew;
@property (nonatomic, strong) SZUserVO* currentUser;
@property (nonatomic, strong) NSMutableArray* viewControllerStack;

+ (SZDataManager*)sharedInstance;
- (void)addRequestToUserCache:(SZEntryVO*)request;
- (void)updateRequestCacheWithRequest:(SZEntryVO*)request;
- (void)removeRequestFromCache:(SZEntryVO*)request;

@end
