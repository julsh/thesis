//
//  SZDataManager.m
//  Skillz
//
//  Created by Julia Roggatz on 31.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZDataManager.h"

@interface SZDataManager ()

//@property (nonatomic, assign) NSInteger messagesToUpdateCount;

@end

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
										[self addEntryToUserCache:entry];
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

- (void)addEntryToUserCache:(SZEntryObject*)entry {
	
	NSString* key;
	switch (entry.type) {
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

- (void)updateEntryCacheWithEntry:(SZEntryObject*)entry {
	
	NSString* key;
	switch (entry.type) {
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

- (void)removeEntryFromCache:(SZEntryObject*)entry {
	
	NSString* key;
	switch (entry.type) {
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

- (void)checkForNewMessages {
		
	if ([[NSUserDefaults standardUserDefaults] objectForKey:@"messages"] == nil) {
		[[NSUserDefaults standardUserDefaults] setObject:[NSDictionary dictionary] forKey:@"messages"];
	}
	NSMutableDictionary* messagesDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"messages"];
//	NSInteger cachedMessagesCount = [messagesDict count];
	
	PFQuery* messageQuery = [PFQuery queryWithClassName:@"MessageStore"];
	[messageQuery whereKey:@"user" equalTo:[PFUser currentUser]];
	[messageQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
		if (object) {
			NSString* timestampString = [object objectForKey:@"lastReceivedMessageAt"];
			NSLog(@"timestampString: %@", timestampString);
			if ([messagesDict valueForKey:timestampString]) {
				NSLog(@"up to date");
			}
			else {
				[self updateMessageCacheWithMessageStore:object];
				NSLog(@"must fetch!!");
			}
		}
	}];
}

- (void)addMessageToUserCache:(PFObject*)message {
	
	if ([[NSUserDefaults standardUserDefaults] objectForKey:@"messages"] == nil) {
		[[NSUserDefaults standardUserDefaults] setObject:[NSDictionary dictionary] forKey:@"messages"];
	}
	
	NSMutableDictionary* messagesDict = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"messages"]];
	
	NSMutableDictionary* messageDict = [[NSMutableDictionary alloc] init];
	NSString* messageDictKey = [NSString stringWithFormat:@"%.0f", [[message createdAt] timeIntervalSince1970]];
	
	NSLog(@"messageText: %@", [message objectForKey:@"messageText"]);
	[messageDict setValue:[message objectId] forKey:@"messageId"];
	
	if ([message valueForKey:@"messageText"]) {
		[messageDict setValue:[message objectForKey:@"messageText"] forKey:@"messageText"];
	}
	if ([message valueForKey:@"entry"]) {
		PFObject* entry = [message valueForKey:@"entry"];
		[messageDict setValue:[entry objectId] forKey:@"entry"];
	}
	
	PFUser* toUser = [message objectForKey:@"toUser"];
	PFUser* fromUser = [message objectForKey:@"fromUser"];
	
	if ([fromUser isDataAvailable]) {
		if (![fromUser isEqual:[PFUser currentUser]]) {
			[messageDict setValue:[fromUser objectId] forKey:@"fromUser"];
			[messageDict setValue:[fromUser objectForKey:@"firstName"] forKey:@"fromUserName"];
		}
	}
	else {
		[fromUser fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
			NSLog(@"fetched from user");
			if (object) {
				if (![[object objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
					NSLog(@"will set from user to: %@", [object valueForKey:@"firstName"]);
					[self addFromUser:object toMessageWithKey:messageDictKey];
				}
			}
		}];
	}
	
	if ([toUser isDataAvailable]) {
		if (![toUser isEqual:[PFUser currentUser]]) {
			[messageDict setValue:[toUser objectId] forKey:@"toUser"];
			[messageDict setValue:[toUser objectForKey:@"firstName"] forKey:@"toUserName"];
		}
	}
	else {
		[toUser fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
			NSLog(@"fetched to user");
			if (object) {
				if (![[object objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
					NSLog(@"will set to user to: %@", [object valueForKey:@"firstName"]);
					[self addToUser:object toMessageWithKey:messageDictKey];
				}
				
			}
		}];
	}
	
	if ([message objectForKey:@"proposedDeal"] && [message objectForKey:@"proposedDeal"] != [NSNull null]) {
		PFObject* dealProposal = [message objectForKey:@"proposedDeal"];
		if ([dealProposal isDataAvailable]) {
			[messageDict setValue:[dealProposal objectId] forKey:@"proposedDeal"];
			[messageDict setValue:[dealProposal valueForKey:@"isAccepted"] forKey:@"hasAcceptedDeal"];
		}
		else {
			[dealProposal fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
				NSLog(@"fetched proposed deal");
				if (object) {
					[self addProposedDeal:object toMessageWithKey:messageDictKey];
				}
			}];
		}
	}
	
	[messagesDict setObject:messageDict forKey:messageDictKey];
	[[NSUserDefaults standardUserDefaults] setObject:messagesDict forKey:@"messages"];
}

- (void)addFromUser:(PFObject*)fromUser toMessageWithKey:(NSString*)key {
	NSMutableDictionary* messagesDict = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"messages"]];
	NSMutableDictionary* messageDict = [[NSMutableDictionary alloc] initWithDictionary:[messagesDict valueForKey:key]];
	[messageDict setValue:[fromUser objectId] forKey:@"fromUser"];
	[messageDict setValue:[fromUser objectForKey:@"firstName"] forKey:@"fromUserName"];
	[messagesDict setValue:messageDict forKey:key];
	[[NSUserDefaults standardUserDefaults] setObject:messagesDict forKey:@"messages"];
}

- (void)addToUser:(PFObject*)toUser toMessageWithKey:(NSString*)key {
	NSMutableDictionary* messagesDict = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"messages"]];
	NSMutableDictionary* messageDict = [[NSMutableDictionary alloc] initWithDictionary:[messagesDict valueForKey:key]];
	[messageDict setValue:[toUser objectId] forKey:@"toUser"];
	[messageDict setValue:[toUser objectForKey:@"firstName"] forKey:@"toUserName"];
	[messagesDict setValue:messageDict forKey:key];
	[[NSUserDefaults standardUserDefaults] setObject:messagesDict forKey:@"messages"];
}

- (void)addProposedDeal:(PFObject*)proposedDeal toMessageWithKey:(NSString*)key {
	if ([[NSUserDefaults standardUserDefaults] objectForKey:@"messages"] == nil) {
		[[NSUserDefaults standardUserDefaults] setObject:[NSDictionary dictionary] forKey:@"messages"];
	}
	NSMutableDictionary* messagesDict = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"messages"]];
	NSMutableDictionary* messageDict = [[NSMutableDictionary alloc] initWithDictionary:[messagesDict valueForKey:key]];
	[messageDict setValue:[proposedDeal objectId] forKey:@"proposedDeal"];
	[messageDict setValue:[proposedDeal valueForKey:@"isAccepted"] forKey:@"hasAcceptedDeal"];
	[messagesDict setValue:messageDict forKey:key];
	[[NSUserDefaults standardUserDefaults] setObject:messagesDict forKey:@"messages"];
}

- (void)updateMessageCacheWithMessageStore:(PFObject*)messageStore {
	
	if ([[NSUserDefaults standardUserDefaults] objectForKey:@"messages"] == nil) {
		[[NSUserDefaults standardUserDefaults] setObject:[NSDictionary dictionary] forKey:@"messages"];
	}
	NSMutableDictionary* messagesDict = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"messages"]];
	
	NSArray* messages = [messageStore objectForKey:@"messages"];
	
	for (NSDictionary* message in messages) {
		NSString* key = [[message allKeys] objectAtIndex:0];
		NSLog(@"key: %@", key);
		if ([messagesDict valueForKey:key]) { // message already exists
			
		}
		else { // need to fetch the message
			PFQuery* query = [PFQuery queryWithClassName:@"Message"];
			[query whereKey:@"objectId" equalTo:[message valueForKey:key]];
			[query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
				if (object) {
					[self addMessageToUserCache:object];
				}
			}];
		}
	}
}

@end
