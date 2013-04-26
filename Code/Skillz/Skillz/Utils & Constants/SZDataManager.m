//
//  SZDataManager.m
//  Skillz
//
//  Created by Julia Roggatz on 31.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "Reachability.h"
#import "SZDataManager.h"

@interface SZDataManager ()

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

- (void)checkForNewMessagesWithCompletionBlock:(void(^)(BOOL finished))completionBlock {
		
	if ([[NSUserDefaults standardUserDefaults] objectForKey:@"messages"] == nil) {
		[[NSUserDefaults standardUserDefaults] setObject:[NSDictionary dictionary] forKey:@"messages"];
	}
	NSMutableDictionary* messagesDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"messages"];
	
	
	Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
	if (![reach isReachable]) {	// network not available
		NSLog(@"network not available");
		dispatch_async(dispatch_get_main_queue(), ^{
			completionBlock(YES);
		});
	}
	else {	// network available
		NSLog(@"network available");
		PFQuery* messageQuery = [PFQuery queryWithClassName:@"MessageStore"];
		[messageQuery whereKey:@"user" equalTo:[PFUser currentUser]];
		[messageQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
			if (object) {
				NSString* timestampString = [object objectForKey:@"lastReceivedMessageAt"];
				NSLog(@"timestampString: %@", timestampString);
				if ([messagesDict valueForKey:timestampString]) {
					NSLog(@"up to date");
					if (completionBlock) {
						dispatch_async(dispatch_get_main_queue(), ^{
							completionBlock(YES);
						});
					}
				}
				else {
					[self updateMessageCacheWithCompletionBlock:completionBlock];
					NSLog(@"must fetch!!");
				}
			}
			else {
				dispatch_async(dispatch_get_main_queue(), ^{
					completionBlock(YES);
				});
			}
		}];
	}
}

- (void)addMessageToUserCache:(PFObject*)message completionBlock:(void(^)(BOOL finished))completionBlock {
	
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
	
	__block BOOL fromUserFetched = NO;
	__block BOOL toUserFetched = NO;
	__block BOOL dealFetched = NO;
	
	PFUser* toUser = [message objectForKey:@"toUser"];
	PFUser* fromUser = [message objectForKey:@"fromUser"];
	
	if ([fromUser isDataAvailable]) {
		if (![fromUser isEqual:[PFUser currentUser]]) {
			[messageDict setValue:[fromUser objectId] forKey:@"fromUser"];
			[messageDict setValue:[fromUser objectForKey:@"firstName"] forKey:@"fromUserName"];
		}
		fromUserFetched = YES;
		if (fromUserFetched && toUserFetched && dealFetched && completionBlock) {
			dispatch_async(dispatch_get_main_queue(), ^{
				completionBlock(YES);
			});
		}
	}
	else {
		[fromUser fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
			if (object) {
				if (![[object objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
					[self addFromUser:object toMessageWithKey:messageDictKey];
				}
				fromUserFetched = YES;
				if (fromUserFetched && toUserFetched && dealFetched && completionBlock) {
					dispatch_async(dispatch_get_main_queue(), ^{
						completionBlock(YES);
					});
				}
			}
		}];
	}
	
	if ([toUser isDataAvailable]) {
		if (![toUser isEqual:[PFUser currentUser]]) {
			[messageDict setValue:[toUser objectId] forKey:@"toUser"];
			[messageDict setValue:[toUser objectForKey:@"firstName"] forKey:@"toUserName"];
			
		}
		toUserFetched = YES;
		if (fromUserFetched && toUserFetched && dealFetched && completionBlock) {
			dispatch_async(dispatch_get_main_queue(), ^{
				completionBlock(YES);
			});
		}
	}
	else {
		[toUser fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
			if (object) {
				if (![[object objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
					[self addToUser:object toMessageWithKey:messageDictKey];
				}
				toUserFetched = YES;
				if (fromUserFetched && toUserFetched && dealFetched && completionBlock) {
					dispatch_async(dispatch_get_main_queue(), ^{
						completionBlock(YES);
					});
				}
				
			}
		}];
	}
	
	if ([message objectForKey:@"proposedDeal"] && [message objectForKey:@"proposedDeal"] != [NSNull null]) {
		PFObject* dealProposal = [message objectForKey:@"proposedDeal"];
		if ([dealProposal isDataAvailable]) {
			[messageDict setValue:[dealProposal objectId] forKey:@"proposedDeal"];
			[messageDict setValue:[dealProposal valueForKey:@"isAccepted"] forKey:@"hasAcceptedDeal"];
			dealFetched = YES;
			if (fromUserFetched && toUserFetched && dealFetched && completionBlock) {
				dispatch_async(dispatch_get_main_queue(), ^{
					completionBlock(YES);
				});
			}
		}
		else {
			[dealProposal fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
				if (object) {
					[self addProposedDeal:object toMessageWithKey:messageDictKey];
					dealFetched = YES;
					if (fromUserFetched && toUserFetched && dealFetched && completionBlock) {
						dispatch_async(dispatch_get_main_queue(), ^{
							completionBlock(YES);
						});
					}
				}
			}];
		}
	}
	else {
		dealFetched = YES;
		if (fromUserFetched && toUserFetched && dealFetched && completionBlock) {
			dispatch_async(dispatch_get_main_queue(), ^{
				completionBlock(YES);
			});
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

- (void)updateMessageCacheWithCompletionBlock:(void(^)(BOOL finished))completionBlock {
	
	if ([[NSUserDefaults standardUserDefaults] objectForKey:@"messages"] == nil) {
		[[NSUserDefaults standardUserDefaults] setObject:[NSDictionary dictionary] forKey:@"messages"];
	}
	NSMutableDictionary* messagesDict = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"messages"]];
	
	uint lastCachedMessageTimeStamp = 0;
	for (NSString* key in [messagesDict allKeys]) {
		if (lastCachedMessageTimeStamp < [key intValue]) {
			lastCachedMessageTimeStamp = [key intValue];
		}
	}
	
	NSDate* lastCachedMessageDate = [NSDate dateWithTimeIntervalSince1970:lastCachedMessageTimeStamp];
	NSLog(@"last cached message: %@", lastCachedMessageDate);
	
	PFQuery* fromQuery = [PFQuery queryWithClassName:@"Message"];
	[fromQuery whereKey:@"fromUser" equalTo:[PFUser currentUser]];
	PFQuery* toQuery = [PFQuery queryWithClassName:@"Message"];
	[fromQuery whereKey:@"toUser" equalTo:[PFUser currentUser]];
	
	PFQuery* messageQuery = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:fromQuery, toQuery, nil]];
	[messageQuery whereKey:@"createdAt" greaterThan:lastCachedMessageDate];
	[messageQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
		if (objects && [objects count] > 0) {
			__block NSInteger storeCount = 0;
			for (PFObject* message in objects) {
				NSLog(@"%@", [message valueForKey:@"messageText"]);
				[self addMessageToUserCache:message completionBlock:^(BOOL finished) {
					storeCount++;
					NSLog(@"stored message %i", storeCount);
					if (storeCount == [objects count] && completionBlock) {
						dispatch_async(dispatch_get_main_queue(), ^{
							NSLog(@"dispatching completion block");
							completionBlock(YES);
						});
					}
				}];
			}
		}
	}];
	
//	NSArray* messages = [messageStore objectForKey:@"messages"];
//	
//	__block NSInteger storeCount = 0;
//	for (NSDictionary* message in messages) {
//		NSString* key = [[message allKeys] objectAtIndex:0];
//		NSLog(@"key: %@", key);
//		if ([messagesDict valueForKey:key]) { // message already exists
//			storeCount++;
//		}
//		else { // need to fetch the message
//			PFQuery* query = [PFQuery queryWithClassName:@"Message"];
//			[query whereKey:@"objectId" equalTo:[message valueForKey:key]];
//			[query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
//				if (object) {
//					[self addMessageToUserCache:object];
//					storeCount++;
//					if (storeCount == [messages count]) {
//						dispatch_async(dispatch_get_main_queue(), ^{
//							completionBlock(YES);
//						});
//					}
//				}
//			}];
//		}
//	}
}

@end
