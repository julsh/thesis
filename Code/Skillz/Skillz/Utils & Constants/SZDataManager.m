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

- (void)saveCurrentEntry:(void(^)(BOOL finished))completionBlock {
	
	[self.currentEntry saveEventually:^(BOOL succeeded, NSError *error) {
		if (succeeded) {
			// cache the request to be used offline
			[self updateEntryCacheWithEntry:self.currentEntry];
			
			if (completionBlock) {
				dispatch_async(dispatch_get_main_queue(), ^{
					completionBlock(YES);
				});
			}
		}
		else {
			if (error) {
				NSLog(@"%@", error);
			}
		}
	}];
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

- (void)updateMessageCacheWithCompletionBlock:(void(^)(BOOL finished))completionBlock {
	
	Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
	if (![reach isReachable]) {	// network not available
		NSLog(@"network not available");
		dispatch_async(dispatch_get_main_queue(), ^{
			completionBlock(YES);
		});
	}
	else {	// network available
		NSLog(@"network available");
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
		NSLog(@"my object id: %@", [[PFUser currentUser] objectId]);
		
		PFQuery* fromQuery = [PFQuery queryWithClassName:@"Message"];
		[fromQuery whereKey:@"fromUser" equalTo:[PFUser currentUser]];
		PFQuery* toQuery = [PFQuery queryWithClassName:@"Message"];
		[toQuery whereKey:@"toUser" equalTo:[PFUser currentUser]];
		
		PFQuery* messageQuery = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:fromQuery, toQuery, nil]];
		[messageQuery  whereKey:@"createdAt" greaterThan:lastCachedMessageDate];
		[messageQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
			if (objects && [objects count] > 0) {
				__block NSInteger storeCount = 0;
				for (PFObject* message in objects) {
					NSLog(@"from: %@, to: %@", [[message valueForKey:@"fromUser"] objectId], [[message valueForKey:@"toUser"] objectId]);
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
			else {
				// up to date
				NSLog(@"up to date!");
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
	
	__block BOOL fromUserFetched = NO;
	__block BOOL toUserFetched = NO;
	__block BOOL dealFetched = NO;
	__block BOOL entryFetched = NO;
	
	PFUser* toUser = [message objectForKey:@"toUser"];
	PFUser* fromUser = [message objectForKey:@"fromUser"];
	
	//------------------------ saving message sender
	
	if ([fromUser isDataAvailable]) {
		if (![fromUser isEqual:[PFUser currentUser]]) {
			[messageDict setValue:[fromUser objectId] forKey:@"fromUser"];
			[messageDict setValue:[fromUser objectForKey:@"firstName"] forKey:@"fromUserName"];
		}
		fromUserFetched = YES;
		if (fromUserFetched && toUserFetched && entryFetched && dealFetched && completionBlock) {
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
				if (fromUserFetched && toUserFetched && entryFetched && dealFetched && completionBlock) {
					dispatch_async(dispatch_get_main_queue(), ^{
						completionBlock(YES);
					});
				}
			}
		}];
	}
	
	//------------------------ saving message recipien
	
	if ([toUser isDataAvailable]) {
		if (![toUser isEqual:[PFUser currentUser]]) {
			[messageDict setValue:[toUser objectId] forKey:@"toUser"];
			[messageDict setValue:[toUser objectForKey:@"firstName"] forKey:@"toUserName"];
			
		}
		toUserFetched = YES;
		if (fromUserFetched && toUserFetched && entryFetched && dealFetched && completionBlock) {
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
				if (fromUserFetched && toUserFetched && entryFetched && dealFetched && completionBlock) {
					dispatch_async(dispatch_get_main_queue(), ^{
						completionBlock(YES);
					});
				}
				
			}
		}];
	}
	
	//------------------------ saving referenced entry (if applicable)
	
	if ([message objectForKey:@"entry"] && [message objectForKey:@"entry"] != [NSNull null]) {
		PFObject* entry = [message objectForKey:@"entry"];
		if ([entry isDataAvailable]) {
			NSMutableDictionary* entryDict = [[NSMutableDictionary alloc] init];
			[entryDict setValue:[entry objectId] forKey:@"objectId"];
			[entryDict setValue:[entry valueForKey:@"title"] forKey:@"title"];
			[entryDict setValue:[[entry valueForKey:@"user"] objectId] forKey:@"user"];
			[entryDict setValue:[entry valueForKey:@"entryType"] forKey:@"entryType"];
			[messageDict setValue:entryDict forKey:@"entry"];
			entryFetched = YES;
			if (fromUserFetched && toUserFetched && entryFetched && dealFetched && completionBlock) {
				dispatch_async(dispatch_get_main_queue(), ^{
					completionBlock(YES);
				});
			}
		}
		else {
			[entry fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
				if (object) {
					[self addEntry:object toMessageWithKey:messageDictKey];
					entryFetched = YES;
					if (fromUserFetched && toUserFetched && entryFetched && dealFetched && completionBlock) {
						dispatch_async(dispatch_get_main_queue(), ^{
							completionBlock(YES);
						});
					}
				}
			}];
		}
	}
	else {
		entryFetched = YES;
		if (fromUserFetched && toUserFetched && entryFetched && dealFetched && completionBlock) {
			dispatch_async(dispatch_get_main_queue(), ^{
				completionBlock(YES);
			});
		}
	}
	
	//------------------------ saving proposed deal (if applicable)
	
	if ([message objectForKey:@"proposedDeal"] && [message objectForKey:@"proposedDeal"] != [NSNull null]) {
		NSLog(@"has deal proposal");
		PFObject* dealProposal = [message objectForKey:@"proposedDeal"];
		if ([dealProposal isDataAvailable]) {
			NSMutableDictionary* proposedDeal = [[NSMutableDictionary alloc] init];
			[proposedDeal setValue:[dealProposal objectId] forKey:@"objectId"];
			[proposedDeal setValue:[[dealProposal valueForKey:@"fromUser"] objectId] forKey:@"fromUser"];
			[proposedDeal setValue:[dealProposal valueForKey:@"isAccepted"] forKey:@"isAccepted"];
			[proposedDeal setValue:[dealProposal valueForKey:@"dealValue"] forKey:@"dealValue"];
			if ([proposedDeal valueForKey:@"hours"]) [proposedDeal setValue:[dealProposal valueForKey:@"hours"] forKey:@"hours"];
			if ([proposedDeal valueForKey:@"isDone"]) [proposedDeal setValue:[dealProposal valueForKey:@"isDone"] forKey:@"isDone"];
			[messageDict setValue:proposedDeal forKey:@"proposedDeal"];
			dealFetched = YES;
			if (fromUserFetched && toUserFetched && entryFetched && dealFetched && completionBlock) {
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
					if (fromUserFetched && toUserFetched && entryFetched && dealFetched && completionBlock) {
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
		if (fromUserFetched && toUserFetched && entryFetched && dealFetched && completionBlock) {
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

- (void)addProposedDeal:(PFObject*)dealProposal toMessageWithKey:(NSString*)key {
	NSLog(@"adding proposed deal");
	if ([[NSUserDefaults standardUserDefaults] objectForKey:@"messages"] == nil) {
		[[NSUserDefaults standardUserDefaults] setObject:[NSDictionary dictionary] forKey:@"messages"];
	}
	NSMutableDictionary* messagesDict = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"messages"]];
	NSMutableDictionary* messageDict = [[NSMutableDictionary alloc] initWithDictionary:[messagesDict valueForKey:key]];
	NSMutableDictionary* proposedDeal = [[NSMutableDictionary alloc] init];
	[proposedDeal setValue:[dealProposal objectId] forKey:@"objectId"];
	[proposedDeal setValue:[[dealProposal valueForKey:@"fromUser"] objectId] forKey:@"fromUser"];
	[proposedDeal setValue:[dealProposal valueForKey:@"isAccepted"] forKey:@"isAccepted"];
	if ([[dealProposal valueForKey:@"isAccepted"] boolValue]) {
		[self addOpenDealToUserCache:dealProposal];
	}
	[proposedDeal setValue:[dealProposal valueForKey:@"dealValue"] forKey:@"dealValue"];
	if ([dealProposal valueForKey:@"hours"]) [proposedDeal setValue:[dealProposal valueForKey:@"hours"] forKey:@"hours"];
	if ([dealProposal valueForKey:@"isDone"]) [proposedDeal setValue:[dealProposal valueForKey:@"isDone"] forKey:@"isDone"];
	[messageDict setValue:proposedDeal forKey:@"proposedDeal"];
	[messagesDict setValue:messageDict forKey:key];
	[[NSUserDefaults standardUserDefaults] setObject:messagesDict forKey:@"messages"];
}

- (void)addEntry:(PFObject*)entry toMessageWithKey:(NSString*)key {
	if ([[NSUserDefaults standardUserDefaults] objectForKey:@"messages"] == nil) {
		[[NSUserDefaults standardUserDefaults] setObject:[NSDictionary dictionary] forKey:@"messages"];
	}
	NSMutableDictionary* messagesDict = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"messages"]];
	NSMutableDictionary* messageDict = [[NSMutableDictionary alloc] initWithDictionary:[messagesDict valueForKey:key]];
	NSMutableDictionary* entryDict = [[NSMutableDictionary alloc] init];
	[entryDict setValue:[entry objectId] forKey:@"objectId"];
	[entryDict setValue:[entry valueForKey:@"title"] forKey:@"title"];
	[entryDict setValue:[[entry valueForKey:@"user"] objectId] forKey:@"user"];
	[entryDict setValue:[entry valueForKey:@"entryType"] forKey:@"entryType"];
	[entryDict setValue:[entry valueForKey:@"category"] forKey:@"category"];
	[entryDict setValue:[entry valueForKey:@"subcategory"] forKey:@"subcategory"];
	[messageDict setValue:entryDict forKey:@"entry"];
	[messagesDict setValue:messageDict forKey:key];
	[[NSUserDefaults standardUserDefaults] setObject:messagesDict forKey:@"messages"];
}


- (NSMutableArray*)getGroupedMessages {
	
	NSMutableDictionary* messagesGrouped = [[NSMutableDictionary alloc] init];
	NSDictionary* messages = [[NSUserDefaults standardUserDefaults] objectForKey:@"messages"];
	
	NSMutableArray* messagesGroupedArray = [[NSMutableArray alloc] init];
	
	NSArray* messageKeys = [messages allKeys];
	for (NSString* key in messageKeys) {
		NSMutableDictionary* message = [[NSMutableDictionary alloc] initWithDictionary:[messages valueForKey:key]];
		[message setObject:key forKey:@"timeStamp"];
		
		NSString* userID;
		if ([message valueForKey:@"fromUser"]) userID = [message valueForKey:@"fromUser"];
		else if ([message valueForKey:@"toUser"]) userID = [message valueForKey:@"toUser"];
		
		NSMutableArray* messageArray;
		if ([messagesGrouped valueForKey:userID]) {
			messageArray = [messagesGrouped valueForKey:userID];
		}
		else {
			messageArray = [[NSMutableArray alloc] init];
			[messagesGrouped setObject:messageArray forKey:userID];
			
		}
		[messageArray addObject:message];
	}
	
	// sort messages within each message group, display the newest first
	for (NSString* key in [messagesGrouped allKeys]) {
		NSMutableArray* messageArray = [messagesGrouped valueForKey:key];
		[messageArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
			if ([[obj1 valueForKey:@"timeStamp"] compare:[obj2 valueForKey:@"timeStamp"] options:NSCaseInsensitiveSearch] == NSOrderedAscending) {
				return NSOrderedDescending;
			}
			if ([[obj1 valueForKey:@"timeStamp"] compare:[obj2 valueForKey:@"timeStamp"] options:NSCaseInsensitiveSearch] == NSOrderedDescending) {
				return NSOrderedAscending;
			}
			else {
				return NSOrderedSame;
			}
		}];
		[messagesGroupedArray addObject:messageArray];
	}
	
	// sort grouped messages, diplay the newest first
	[messagesGroupedArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
		if ([[[obj1 objectAtIndex:0] valueForKey:@"timeStamp"] compare:[[obj2 objectAtIndex:0] valueForKey:@"timeStamp"] options:NSCaseInsensitiveSearch] == NSOrderedAscending) {
			return NSOrderedDescending;
		}
		if ([[[obj1 objectAtIndex:0] valueForKey:@"timeStamp"] compare:[[obj2 objectAtIndex:0] valueForKey:@"timeStamp"] options:NSCaseInsensitiveSearch] == NSOrderedDescending) {
			return NSOrderedAscending;
		}
		else {
			return NSOrderedSame;
		}
	}];
	
	return messagesGroupedArray;
}

- (void)addOpenDealToUserCache:(PFObject*)openDeal {
	if ([[NSUserDefaults standardUserDefaults] objectForKey:@"openDeals"] == nil) {
		[[NSUserDefaults standardUserDefaults] setObject:[NSArray array] forKey:@"openDeals"];
	}
	NSMutableArray* openDealsArr = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"openDeals"]];
	
	for (NSDictionary* cachedDeal in openDealsArr) {
		if ([[cachedDeal valueForKey:@"objectId"] isEqualToString:[openDeal objectId]]) {
			return; // already chached
		}
	}
	
	NSMutableDictionary* deal = [[NSMutableDictionary alloc] init];
	[deal setValue:[openDeal objectId] forKey:@"objectId"];
	[deal setValue:[openDeal valueForKey:@"isAccepted"] forKey:@"isAccepted"];
	[deal setValue:[openDeal valueForKey:@"dealValue"] forKey:@"dealValue"];
	if ([openDeal valueForKey:@"hours"]) [deal setValue:[openDeal valueForKey:@"hours"] forKey:@"hours"];
	if ([openDeal valueForKey:@"isDone"]) [deal setValue:[openDeal valueForKey:@"isDone"] forKey:@"isDone"];
	
	__block BOOL entryFetchted = NO;
	__block BOOL otherUserFetched = NO;
	
	if ([openDeal valueForKey:@"entry"]) {
		PFObject* entry = [openDeal valueForKey:@"entry"];
		[entry fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
			if (object) {
				NSLog(@"fetched entry");
				[deal setValue:[object valueForKey:@"title"] forKey:@"entryTitle"];
				[deal setValue:[object valueForKey:@"entryType"] forKey:@"entryType"];
				if ([[object valueForKey:@"user"] isEqual:[PFUser currentUser]]) {
					[deal setValue:[NSNumber numberWithBool:YES] forKey:@"isOwnEntry"];
				}
				else {
					[deal setValue:[NSNumber numberWithBool:NO] forKey:@"isOwnEntry"];
				}
				entryFetchted = YES;
				if ( otherUserFetched) {
					[openDealsArr addObject:deal];
					[[NSUserDefaults standardUserDefaults] setObject:openDealsArr forKey:@"openDeals"];
					NSLog(@"added deal to cache");
				}
			}
		}];
	}
	
	if ([[openDeal valueForKey:@"fromUser"] isEqual:[PFUser currentUser]]) { // we're proposing the deal to someone else
		[deal setValue:@"self" forKey:@"fromUser"];
		PFUser* toUser = [openDeal valueForKey:@"toUser"];
		[toUser fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
				if (object) {
					NSLog(@"fetched from user");
					[deal setValue:[object objectId] forKey:@"toUser"];
					[deal setValue:[object valueForKey:@"firstName"] forKey:@"toUserName"];
					otherUserFetched = YES;
					if (entryFetchted) {
						[openDealsArr addObject:deal];
						[[NSUserDefaults standardUserDefaults] setObject:openDealsArr forKey:@"openDeals"];
						NSLog(@"added deal to cache");
					}
				}
		}];
	}
	else { // someone else is proposing a deal to us
		[deal setValue:@"self" forKey:@"toUser"];
		PFUser* fromUser = [openDeal valueForKey:@"fromUser"];
		[fromUser fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
			if (object) {
				NSLog(@"fetched from user");
				[deal setValue:[object objectId] forKey:@"fromUser"];
				[deal setValue:[object valueForKey:@"firstName"] forKey:@"fromUserName"];
				otherUserFetched = YES;
				if (entryFetchted) {
					[openDealsArr addObject:deal];
					[[NSUserDefaults standardUserDefaults] setObject:openDealsArr forKey:@"openDeals"];
					NSLog(@"added deal to cache");
				}
			}
		}];
	}
}

- (void)markDealAccepted:(NSString*)dealId {
	
	NSMutableDictionary* messages = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"messages"]];
	NSArray* keys = [messages allKeys];
	for (NSString* key in keys) {
		NSMutableDictionary* messageDict = [[NSMutableDictionary alloc] initWithDictionary:[messages valueForKey:key]];
		if ([messageDict valueForKey:@"proposedDeal"]) {
			NSMutableDictionary* dealDict = [[NSMutableDictionary alloc] initWithDictionary:[messageDict valueForKey:@"proposedDeal"]];
			if ([[dealDict valueForKey:@"objectId"] isEqualToString:dealId]) {
				[dealDict setValue:[NSNumber numberWithBool:YES] forKey:@"isAccepted"];
				NSLog(@"marked deal as accepted");
				[messageDict setValue:dealDict forKey:@"proposedDeal"];
				[messages setValue:messageDict forKey:key];
				[[NSUserDefaults standardUserDefaults] setValue:messages forKey:@"messages"];
				break;
			}
		}
	}
}

- (void)updateOpenDealsCacheWithCompletionBlock:(void(^)(BOOL finished))completionBlock {
	
	Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
	if (![reach isReachable]) {	// network not available
		NSLog(@"network not available");
		dispatch_async(dispatch_get_main_queue(), ^{
			completionBlock(YES);
		});
	}
	else {
		PFQuery* fromQuery = [PFQuery queryWithClassName:@"Deal"];
		[fromQuery whereKey:@"fromUser" equalTo:[PFUser currentUser]];
		PFQuery* toQuery = [PFQuery queryWithClassName:@"Deal"];
		[toQuery whereKey:@"toUser" equalTo:[PFUser currentUser]];
		
		PFQuery* query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:fromQuery, toQuery, nil]];
		[query whereKey:@"isAccepted" equalTo:[NSNumber numberWithBool:YES]];
		[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
			if (objects && [objects count] > 0) {
				__block NSInteger storeCount = 0;
				for (PFObject* deal in objects) {
					[self markDealAccepted:[deal objectId]];
					[self addOpenDealToUserCache:deal];
					storeCount++;
					if (storeCount == [objects count] && completionBlock) {
						dispatch_async(dispatch_get_main_queue(), ^{
							completionBlock(YES);
						});
					}
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


@end
