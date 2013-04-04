//
//  SZDataManager.m
//  Skillz
//
//  Created by Julia Roggatz on 31.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZDataManager.h"

@implementation SZDataManager

@synthesize currentEntry = _currentObject;
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

- (void)addEntryToUserCache:(SZEntryVO*)entry type:(SZEntryType)type {
	
	NSString* key;
	switch (type) {
		case SZEntryTypeRequest:
			key = @"requests";
			break;
		case SZEntryTypeOffer:
			key = @"offers";
			break;
	}
	
	if ([[NSUserDefaults standardUserDefaults] objectForKey:key] == nil) {
		[[NSUserDefaults standardUserDefaults] setObject:[NSArray array] forKey:key];
	}
	NSMutableArray* entryArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:key]];
	[entryArray addObject:[SZEntryVO dictionaryFromEntryVO:entry]];
	[[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithArray:entryArray] forKey:key];
	
}

- (void)updateEntryCacheWithEntry:(SZEntryVO*)entry type:(SZEntryType)type {
	
	NSString* key;
	switch (type) {
		case SZEntryTypeRequest:
			key = @"requests";
			break;
		case SZEntryTypeOffer:
			key = @"offers";
			break;
	}
	
	NSMutableArray* entryArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:key]];
	for (NSDictionary* dict in entryArray) {
		if ([[dict valueForKey:@"objectID"] isEqualToString:entry.objectID]) {
			[entryArray removeObject:dict];
			break;
		}
	}
	[entryArray addObject:[SZEntryVO dictionaryFromEntryVO:entry]];
	[[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithArray:entryArray] forKey:key];
}

- (void)removeEntryFromCache:(SZEntryVO*)entry type:(SZEntryType)type {
	
	NSString* key;
	switch (type) {
		case SZEntryTypeRequest:
			key = @"requests";
			break;
		case SZEntryTypeOffer:
			key = @"offers";
			break;
	}
	
	NSMutableArray* entryArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:key]];
	for (NSDictionary* dict in entryArray) {
		if ([[dict valueForKey:@"objectID"] isEqualToString:entry.objectID]) {
			[entryArray removeObject:dict];
			break;
		}
	}
	[[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithArray:entryArray] forKey:key];
}

@end
