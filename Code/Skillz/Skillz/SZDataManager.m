//
//  SZDataManager.m
//  Skillz
//
//  Created by Julia Roggatz on 31.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZDataManager.h"

@implementation SZDataManager

@synthesize currentObject = _currentObject;
@synthesize viewControllerStack = _viewControllerStack;

+ (SZDataManager*)sharedInstance {
	
	static dispatch_once_t singletonPredicate;
	static SZDataManager* singleton = nil;
	
	dispatch_once(&singletonPredicate, ^{
        singleton = [[super allocWithZone:nil] init];
		NSLog(@"constants singleton created");
	});
	return singleton;
}

- (NSMutableArray*)viewControllerStack {
	if (_viewControllerStack == nil) {
		_viewControllerStack = [[NSMutableArray alloc] init];
	}
	return _viewControllerStack;
}

- (void)addRequestToUserCache:(SZEntryVO*)request {
	
	if ([[NSUserDefaults standardUserDefaults] objectForKey:@"requests"] == nil) {
		[[NSUserDefaults standardUserDefaults] setObject:[NSArray array] forKey:@"requests"];
	}
	NSMutableArray* requestArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"requests"]];
	[requestArray addObject:[SZEntryVO dictionaryFromEntryVO:request]];
	[[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithArray:requestArray] forKey:@"requests"];
	
}

- (void)updateRequestCacheWithRequest:(SZEntryVO*)request {
	NSMutableArray* requestArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"requests"]];
	for (NSDictionary* dict in requestArray) {
		if ([[dict valueForKey:@"objectID"] isEqualToString:request.objectID]) {
			[requestArray removeObject:dict];
			break;
		}
	}
	[requestArray addObject:[SZEntryVO dictionaryFromEntryVO:request]];
	[[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithArray:requestArray] forKey:@"requests"];
}

- (void)removeRequestFromCache:(SZEntryVO*)request {
	NSMutableArray* requestArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"requests"]];
	for (NSDictionary* dict in requestArray) {
		if ([[dict valueForKey:@"objectID"] isEqualToString:request.objectID]) {
			[requestArray removeObject:dict];
			break;
		}
	}
	[[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithArray:requestArray] forKey:@"requests"];
}

@end
