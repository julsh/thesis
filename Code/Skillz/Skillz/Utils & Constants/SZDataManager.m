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

- (void)updateCaches {
	
	NSMutableArray* offersArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:OFFERS]];
	NSMutableArray* requestsArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:REQUESTS]];
	
	PFQuery* query = [PFQuery queryWithClassName:@"Entry"];
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
		if (objects) {
			if ([objects count] > 0) { // found something!
				
				for (int i = 0; i < [objects count]; i++) {
					PFObject* result = [objects objectAtIndex:i];
					if ([[result objectForKey:@"isActive"] boolValue]) { // only display if entry is activated
						
						PFUser *user = [result objectForKey:@"user"]; // fetch the user object that owns the entry
						[user fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
							if (object) {
								SZEntryObject* entry = (SZEntryObject*)result;
								if ([entry.user.objectId isEqualToString:[PFUser currentUser].objectId]) {
									BOOL contained = NO;
									for (NSDictionary* offer in offersArray) {
										if ([[offer valueForKey:@"objectID"] isEqualToString:entry.objectId]) {
											contained = YES;
										}
									}
									for (NSDictionary* request in requestsArray) {
										if ([[request valueForKey:@"objectID"] isEqualToString:entry.objectId]) {
											contained = YES;
										}
									}
									if (!contained) {
										[self addEntryToUserCache:entry type:entry.type];
									}
								}
							}
							else if (error) {
								NSLog(@"Error: %@ %@", error, [error userInfo]);
							}
						}];
					}
					
				}
			}
		}
		else if (error) {
			NSLog(@"Error: %@ %@", error, [error userInfo]);
		}
	}];
}

- (void)addEntryToUserCache:(SZEntryObject*)entry type:(SZEntryType)type {
	
	NSString* key;
	switch (type) {
		case SZEntryTypeRequest:
			key = REQUESTS;
			break;
		case SZEntryTypeOffer:
			key = OFFERS;
			break;
	}
	
	if ([[NSUserDefaults standardUserDefaults] objectForKey:key] == nil) {
		[[NSUserDefaults standardUserDefaults] setObject:[NSArray array] forKey:key];
	}
	NSMutableArray* entryArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:key]];
	[entryArray addObject:[SZEntryObject dictionaryFromEntryVO:entry]];
	[[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithArray:entryArray] forKey:key];
	
}

- (void)updateEntryCacheWithEntry:(SZEntryObject*)entry type:(SZEntryType)type {
	
	NSString* key;
	switch (type) {
		case SZEntryTypeRequest:
			key = REQUESTS;
			break;
		case SZEntryTypeOffer:
			key = OFFERS;
			break;
	}
	
	NSMutableArray* entryArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:key]];
	for (NSDictionary* dict in entryArray) {
		if ([[dict valueForKey:@"objectID"] isEqualToString:entry.objectId]) {
			[entryArray removeObject:dict];
			break;
		}
	}
	[entryArray addObject:[SZEntryObject dictionaryFromEntryVO:entry]];
	[[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithArray:entryArray] forKey:key];
}

- (void)removeEntryFromCache:(SZEntryObject*)entry type:(SZEntryType)type {
	
	NSString* key;
	switch (type) {
		case SZEntryTypeRequest:
			key = REQUESTS;
			break;
		case SZEntryTypeOffer:
			key = OFFERS;
			break;
	}
	
	NSMutableArray* entryArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:key]];
	for (NSDictionary* dict in entryArray) {
		if ([[dict valueForKey:@"objectID"] isEqualToString:entry.objectId]) {
			[entryArray removeObject:dict];
			break;
		}
	}
	[[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithArray:entryArray] forKey:key];
}

- (void)saveLastEnderedAddress:(NSDictionary*)address {
	[[NSUserDefaults standardUserDefaults] setObject:address forKey:LAST_ENTERED_ADDRESS];
}

- (NSDictionary*)lastEnteredAddress {
	if ([[NSUserDefaults standardUserDefaults] valueForKey:LAST_ENTERED_ADDRESS]) {
		return (NSDictionary*)[[NSUserDefaults standardUserDefaults] valueForKey:LAST_ENTERED_ADDRESS];
	}
	else return nil;
}

@end
