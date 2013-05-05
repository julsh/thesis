//
//  SZDataManager.m
//  Skillz
//
//  Created by Julia Roggatz on 31.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "Reachability.h"
#import "SZDataManager.h"

#define REQUESTS 				@"requests"
#define OFFERS					@"offers"
#define LAST_ENTERED_ADDRESS 	@"lastEnteredAddress"
#define MESSAGES				@"messages"
#define OPEN_DEALS				@"openDeals"
#define OBJECT_ID				@"objectId"
#define FROM_USER				@"fromUser"
#define FROM_USER_NAME			@"fromUserName"
#define TO_USER					@"toUser"
#define TO_USER_NAME			@"toUserName"
#define FIRST_NAME				@"firstName"
#define PROPOSED_DEAL			@"proposedDeal"
#define TIMESTAMP				@"timeStamp"
#define USER					@"user"
#define ENTRY					@"entry"
#define CATEGORY				@"category"
#define SUBCATEGORY				@"subcategory"
#define ENTRY_TYPE				@"entryType"
#define IS_ACTIVE				@"isActive"
#define IS_ACCEPTED				@"isAccepted"
#define IS_DONE					@"isDone"
#define DEAL_VALUE				@"dealValue"
#define HOURS					@"hours"
#define TITLE					@"title"
#define MESSAGE_TEXT			@"messageText"
#define MESSAGE_ID				@"messageId"
#define CREATED_AT				@"createdAt"
#define ENTRY_TITLE				@"entryTitle"


@interface SZDataManager ()

@end

@implementation SZDataManager

@synthesize currentEntry = _currentEntry;
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

+ (NSArray*)sortedCategories {
	NSMutableArray* categories = [[NSMutableArray alloc] init];
	NSArray* unsortedCategories = [[NSUserDefaults standardUserDefaults] objectForKey:@"categories"];
	for (NSDictionary* categoryDict in unsortedCategories) {
		[categories addObject:[categoryDict objectForKey:@"categoryName"]];
	}
	categories = [NSMutableArray arrayWithArray:[categories sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
	[categories removeObject:@"Miscellaneous"]; // remove the "misc" category from somewhere in the middle of the array
	[categories addObject:@"Miscellaneous"];    // and put it back at the end. "misc" should not be in alphabetical order.
	
	return categories;
}

+ (NSArray*)sortedSubcategoriesForCategory:(NSString*)category {
	NSArray* subcategories;
	NSArray* unsortedCategories = [[NSUserDefaults standardUserDefaults] objectForKey:@"categories"];
	for (NSDictionary* categoryDict in unsortedCategories) {
		if ([[categoryDict valueForKey:@"categoryName"] isEqualToString:category]) {
			subcategories = [[categoryDict valueForKey:@"subcategories"] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
			break;
		}
	}
	return subcategories;
}

+ (BOOL)categoryHasSubcategory:(NSString*)category {
	NSArray* unsortedCategories = [[NSUserDefaults standardUserDefaults] objectForKey:@"categories"];
	for (NSDictionary* categoryDict in unsortedCategories) {
		if ([[categoryDict valueForKey:@"categoryName"] isEqualToString:category]) {
			if ([categoryDict valueForKey:@"subcategories"]) return YES;
			break;
		}
	}
	return NO;
}

+ (void)addEntryToUserCache:(SZEntryObject*)entry {
	
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
	
	for (NSDictionary* dict in entryArray) {
		if ([[dict valueForKey:OBJECT_ID] isEqualToString:entry.objectId]) {
			[entryArray removeObject:dict];
			break;
		}
	}
	
	[entryArray addObject:[SZEntryObject dictionaryFromEntryVO:entry]];
	[[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithArray:entryArray] forKey:key];
	
}


+ (void)removeEntryFromCache:(SZEntryObject*)entry {
	
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
		if ([[dict valueForKey:OBJECT_ID] isEqualToString:entry.objectId]) {
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
			[SZDataManager addEntryToUserCache:self.currentEntry];
			
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

+ (void)saveLastEnderedAddress:(NSDictionary*)address {
	[[NSUserDefaults standardUserDefaults] setObject:address forKey:LAST_ENTERED_ADDRESS];
}

+ (NSDictionary*)lastEnteredAddress {
	if ([[NSUserDefaults standardUserDefaults] valueForKey:LAST_ENTERED_ADDRESS]) {
		return (NSDictionary*)[[NSUserDefaults standardUserDefaults] valueForKey:LAST_ENTERED_ADDRESS];
	}
	else return nil;
}

+ (void)updateMessageCacheWithCompletionBlock:(void(^)(NSArray* newMessages))completionBlock {
	
	// flush messages
//	[[NSUserDefaults standardUserDefaults] setObject:[NSDictionary dictionary] forKey:MESSAGES];
	
	Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
	if (![reach isReachable]) {	// network not available
		NSLog(@"network not available");
		dispatch_async(dispatch_get_main_queue(), ^{
			completionBlock(nil);
		});
	}
	else {	// network available
		NSLog(@"network available");
		if ([[NSUserDefaults standardUserDefaults] objectForKey:MESSAGES] == nil) {
			[[NSUserDefaults standardUserDefaults] setObject:[NSDictionary dictionary] forKey:MESSAGES];
		}
		NSMutableDictionary* messagesDict = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:MESSAGES]];
		
		double lastCachedMessageTimeStamp = 0.0;
		for (NSString* key in [messagesDict allKeys]) {
			NSLog(@"key %@", key);
			if (lastCachedMessageTimeStamp < [key doubleValue]) {
				lastCachedMessageTimeStamp = [key doubleValue];
			}
		}
		
		NSDate* lastCachedMessageDate = [NSDate dateWithTimeIntervalSince1970:lastCachedMessageTimeStamp];
		NSLog(@"lastCachedMessageTimeStamp: %f", lastCachedMessageTimeStamp);
		NSLog(@"my object id: %@", [[PFUser currentUser] objectId]);
		
		PFQuery* fromQuery = [PFQuery queryWithClassName:@"Message"];
		[fromQuery whereKey:FROM_USER equalTo:[PFUser currentUser]];
		PFQuery* toQuery = [PFQuery queryWithClassName:@"Message"];
		[toQuery whereKey:TO_USER equalTo:[PFUser currentUser]];
		
		PFQuery* messageQuery = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:fromQuery, toQuery, nil]];
		[messageQuery  whereKey:CREATED_AT greaterThan:lastCachedMessageDate];
		[messageQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
			if (objects && [objects count] > 0) {
				__block NSInteger storeCount = 0;
				for (PFObject* message in objects) {
					[SZDataManager addMessageToUserCache:message completionBlock:^(BOOL finished) {
						storeCount++;
						NSLog(@"stored message %i", storeCount);
						if (storeCount == [objects count] && completionBlock) {
							dispatch_async(dispatch_get_main_queue(), ^{
								NSLog(@"dispatching completion block");
								completionBlock(objects);
							});
						}
					}];
				}
			}
			else {
				// up to date
				NSLog(@"up to date!");
				dispatch_async(dispatch_get_main_queue(), ^{
					completionBlock(nil);
				});
			}
		}];
	}
}

+ (void)addMessageToUserCache:(PFObject*)message completionBlock:(void(^)(BOOL finished))completionBlock {
	
	if ([[NSUserDefaults standardUserDefaults] objectForKey:MESSAGES] == nil) {
		[[NSUserDefaults standardUserDefaults] setObject:[NSDictionary dictionary] forKey:MESSAGES];
	}
	
	NSMutableDictionary* messagesDict = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:MESSAGES]];
	
	NSMutableDictionary* messageDict = [[NSMutableDictionary alloc] init];
	NSString* messageDictKey = [NSString stringWithFormat:@"%f", [[message createdAt] timeIntervalSince1970]];
	
	NSLog(@"messageText: %@", [message objectForKey:MESSAGE_TEXT]);
	[messageDict setValue:[message objectId] forKey:MESSAGE_ID];
	
	if ([message valueForKey:MESSAGE_TEXT]) {
		[messageDict setValue:[message objectForKey:MESSAGE_TEXT] forKey:MESSAGE_TEXT];
	}
	
	[messagesDict setObject:messageDict forKey:messageDictKey];
	[[NSUserDefaults standardUserDefaults] setObject:messagesDict forKey:MESSAGES];
	
	__block BOOL fromUserFetched = NO;
	__block BOOL toUserFetched = NO;
	__block BOOL dealFetched = NO;
	__block BOOL entryFetched = NO;
	
	PFUser* toUser = [message objectForKey:TO_USER];
	PFUser* fromUser = [message objectForKey:FROM_USER];
	
	NSLog(@"FROM_USER: %@ // TO_USER %@", [[message objectForKey:FROM_USER] objectId], [[message objectForKey:TO_USER] objectId]);
	
	//------------------------ saving message sender
	
	if (![fromUser isEqual:[PFUser currentUser]]) {
		[fromUser fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
			if (object) {
				if (![[object objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
					[SZDataManager addFromUser:object toMessageWithKey:messageDictKey];
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
	else {
		fromUserFetched = YES;
		if (fromUserFetched && toUserFetched && entryFetched && dealFetched && completionBlock) {
			dispatch_async(dispatch_get_main_queue(), ^{
				completionBlock(YES);
			});
		}
	}
	
	//------------------------ saving message recipient
	
	if (![toUser isEqual:[PFUser currentUser]]) {
		[toUser fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
			if (object) {
				if (![[object objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
					[SZDataManager addToUser:object toMessageWithKey:messageDictKey];
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
	else {
		toUserFetched = YES;
		if (fromUserFetched && toUserFetched && entryFetched && dealFetched && completionBlock) {
			dispatch_async(dispatch_get_main_queue(), ^{
				completionBlock(YES);
			});
		}
	}
	
	//------------------------ saving referenced entry (if applicable)
	
	if ([message objectForKey:ENTRY] && [message objectForKey:ENTRY] != [NSNull null]) {
		PFObject* entry = [message objectForKey:ENTRY];
		[entry fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
				if (object) {
					[SZDataManager addEntry:object toMessageWithKey:messageDictKey];
					entryFetched = YES;
					if (fromUserFetched && toUserFetched && entryFetched && dealFetched && completionBlock) {
						dispatch_async(dispatch_get_main_queue(), ^{
							completionBlock(YES);
						});
					}
				}
		}];
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
	
	if ([message objectForKey:PROPOSED_DEAL] && [message objectForKey:PROPOSED_DEAL] != [NSNull null]) {
		NSLog(@"has deal proposal");
		PFObject* dealProposal = [message objectForKey:PROPOSED_DEAL];
		[dealProposal fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
				if (object) {
					[SZDataManager addProposedDeal:object toMessageWithKey:messageDictKey];
					dealFetched = YES;
					if (fromUserFetched && toUserFetched && entryFetched && dealFetched && completionBlock) {
						dispatch_async(dispatch_get_main_queue(), ^{
							completionBlock(YES);
						});
					}
				}
		}];
	}
	else {
		dealFetched = YES;
		if (fromUserFetched && toUserFetched && entryFetched && dealFetched && completionBlock) {
			dispatch_async(dispatch_get_main_queue(), ^{
				completionBlock(YES);
			});
		}
	}
	
}

+ (void)addFromUser:(PFObject*)fromUser toMessageWithKey:(NSString*)key {
	NSMutableDictionary* messagesDict = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:MESSAGES]];
	NSMutableDictionary* messageDict = [[NSMutableDictionary alloc] initWithDictionary:[messagesDict valueForKey:key]];
	[messageDict setValue:[fromUser objectId] forKey:FROM_USER];
	[messageDict setValue:[fromUser objectForKey:FIRST_NAME] forKey:FROM_USER_NAME];
	[messagesDict setValue:messageDict forKey:key];
	[[NSUserDefaults standardUserDefaults] setObject:messagesDict forKey:MESSAGES];
	NSLog(@"added to fromUser %@ to message with timeStamp: %@", [fromUser objectId], key);
}

+ (void)addToUser:(PFObject*)toUser toMessageWithKey:(NSString*)key {
	NSMutableDictionary* messagesDict = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:MESSAGES]];
	NSMutableDictionary* messageDict = [[NSMutableDictionary alloc] initWithDictionary:[messagesDict valueForKey:key]];
	[messageDict setValue:[toUser objectId] forKey:TO_USER];
	[messageDict setValue:[toUser objectForKey:FIRST_NAME] forKey:TO_USER_NAME];
	[messagesDict setValue:messageDict forKey:key];
	[[NSUserDefaults standardUserDefaults] setObject:messagesDict forKey:MESSAGES];
	NSLog(@"added to user %@ to message with timeStamp: %@", [toUser objectId], key);
}

+ (void)addProposedDeal:(PFObject*)dealProposal toMessageWithKey:(NSString*)key {
	if ([[NSUserDefaults standardUserDefaults] objectForKey:MESSAGES] == nil) {
		[[NSUserDefaults standardUserDefaults] setObject:[NSDictionary dictionary] forKey:MESSAGES];
	}
	NSMutableDictionary* messagesDict = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:MESSAGES]];
	NSMutableDictionary* messageDict = [[NSMutableDictionary alloc] initWithDictionary:[messagesDict valueForKey:key]];
	NSMutableDictionary* proposedDeal = [[NSMutableDictionary alloc] init];
	[proposedDeal setValue:[dealProposal objectId] forKey:OBJECT_ID];
	[proposedDeal setValue:[[dealProposal valueForKey:FROM_USER] objectId] forKey:FROM_USER];
	[proposedDeal setValue:[dealProposal valueForKey:IS_ACCEPTED] forKey:IS_ACCEPTED];
	if ([[dealProposal valueForKey:IS_ACCEPTED] boolValue]) {
		[SZDataManager addOpenDealToUserCache:dealProposal];
	}
	[proposedDeal setValue:[dealProposal valueForKey:DEAL_VALUE] forKey:DEAL_VALUE];
	if ([dealProposal valueForKey:HOURS]) [proposedDeal setValue:[dealProposal valueForKey:HOURS] forKey:HOURS];
	if ([dealProposal valueForKey:IS_DONE]) [proposedDeal setValue:[dealProposal valueForKey:IS_DONE] forKey:IS_DONE];
	[messageDict setValue:proposedDeal forKey:PROPOSED_DEAL];
	[messagesDict setValue:messageDict forKey:key];
	[[NSUserDefaults standardUserDefaults] setObject:messagesDict forKey:MESSAGES];
	NSLog(@"added proposed deal %@ to message with timeStamp: %@", [dealProposal objectId], key);
}

+ (void)addEntry:(PFObject*)entry toMessageWithKey:(NSString*)key {
	if ([[NSUserDefaults standardUserDefaults] objectForKey:MESSAGES] == nil) {
		[[NSUserDefaults standardUserDefaults] setObject:[NSDictionary dictionary] forKey:MESSAGES];
	}
	NSMutableDictionary* messagesDict = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:MESSAGES]];
	NSMutableDictionary* messageDict = [[NSMutableDictionary alloc] initWithDictionary:[messagesDict valueForKey:key]];
	NSMutableDictionary* entryDict = [[NSMutableDictionary alloc] init];
	[entryDict setValue:[entry objectId] forKey:OBJECT_ID];
	[entryDict setValue:[entry valueForKey:TITLE] forKey:TITLE];
	[entryDict setValue:[[entry valueForKey:USER] objectId] forKey:USER];
	[entryDict setValue:[entry valueForKey:ENTRY_TYPE] forKey:ENTRY_TYPE];
	[entryDict setValue:[entry valueForKey:CATEGORY] forKey:CATEGORY];
	[entryDict setValue:[entry valueForKey:SUBCATEGORY] forKey:SUBCATEGORY];
	[messageDict setValue:entryDict forKey:ENTRY];
	[messagesDict setValue:messageDict forKey:key];
	[[NSUserDefaults standardUserDefaults] setObject:messagesDict forKey:MESSAGES];
	NSLog(@"added entry %@ to message with timeStamp: %@", [entry objectId], key);
}


+ (NSMutableArray*)getGroupedMessages {
	
	NSMutableDictionary* messagesGrouped = [[NSMutableDictionary alloc] init];
	NSDictionary* messages = [[NSUserDefaults standardUserDefaults] objectForKey:MESSAGES];
	
	NSLog(@"messages: %@", messages);
	
	NSMutableArray* messagesGroupedArray = [[NSMutableArray alloc] init];
	
	NSArray* messageKeys = [messages allKeys];
	for (NSString* key in messageKeys) {
		NSMutableDictionary* message = [[NSMutableDictionary alloc] initWithDictionary:[messages valueForKey:key] copyItems:YES];
		
		NSLog(@"message: %@", message);
		
		[message setObject:key forKey:TIMESTAMP];
		
		NSString* userID;
		NSLog(@"message: %@ // from: %@ // to: %@", key, [message valueForKey:FROM_USER], [message valueForKey:TO_USER]);
		if ([message valueForKey:FROM_USER]) userID = [message valueForKey:FROM_USER];
		else userID = [message valueForKey:TO_USER];
		
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
			if ([[obj1 valueForKey:TIMESTAMP] compare:[obj2 valueForKey:TIMESTAMP] options:NSCaseInsensitiveSearch] == NSOrderedAscending) {
				return NSOrderedDescending;
			}
			if ([[obj1 valueForKey:TIMESTAMP] compare:[obj2 valueForKey:TIMESTAMP] options:NSCaseInsensitiveSearch] == NSOrderedDescending) {
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
		if ([[[obj1 objectAtIndex:0] valueForKey:TIMESTAMP] compare:[[obj2 objectAtIndex:0] valueForKey:TIMESTAMP] options:NSCaseInsensitiveSearch] == NSOrderedAscending) {
			return NSOrderedDescending;
		}
		if ([[[obj1 objectAtIndex:0] valueForKey:TIMESTAMP] compare:[[obj2 objectAtIndex:0] valueForKey:TIMESTAMP] options:NSCaseInsensitiveSearch] == NSOrderedDescending) {
			return NSOrderedAscending;
		}
		else {
			return NSOrderedSame;
		}
	}];
	
	return messagesGroupedArray;
}

+ (NSArray*)getMessageThreadForUserId:(NSString*)userId {
	NSMutableArray* groupedMessages = [SZDataManager getGroupedMessages];
	for (NSArray* messageArr in groupedMessages) {
		NSDictionary* topMessage = [messageArr objectAtIndex:0];
		if ([[topMessage valueForKey:FROM_USER] isEqualToString:userId] || [[topMessage valueForKey:TO_USER] isEqualToString:userId]) {
			return messageArr;
		}
	}
	return nil;
}

+ (void)addOpenDealToUserCache:(PFObject*)openDeal {
	
	[SZDataManager markDealAccepted:[openDeal objectId]];
	
	if ([[NSUserDefaults standardUserDefaults] objectForKey:OPEN_DEALS] == nil) {
		[[NSUserDefaults standardUserDefaults] setObject:[NSArray array] forKey:OPEN_DEALS];
	}
	NSMutableArray* openDealsArr = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:OPEN_DEALS]];
	
	for (NSDictionary* cachedDeal in openDealsArr) {
		if ([[cachedDeal valueForKey:OBJECT_ID] isEqualToString:[openDeal objectId]]) {
			return; // already chached
		}
	}
	
	NSMutableDictionary* deal = [[NSMutableDictionary alloc] init];
	[deal setValue:[openDeal objectId] forKey:OBJECT_ID];
	[deal setValue:[openDeal valueForKey:IS_ACCEPTED] forKey:IS_ACCEPTED];
	[deal setValue:[openDeal valueForKey:DEAL_VALUE] forKey:DEAL_VALUE];
	if ([openDeal valueForKey:HOURS]) [deal setValue:[openDeal valueForKey:HOURS] forKey:HOURS];
	if ([openDeal valueForKey:IS_DONE]) [deal setValue:[openDeal valueForKey:IS_DONE] forKey:IS_DONE];
	
	__block BOOL entryFetchted = NO;
	__block BOOL otherUserFetched = NO;
	
	if ([openDeal valueForKey:ENTRY]) {
		PFObject* entry = [openDeal valueForKey:ENTRY];
		[entry fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
			if (object) {
				NSLog(@"fetched entry");
				[deal setValue:[object valueForKey:TITLE] forKey:ENTRY_TITLE];
				[deal setValue:[object valueForKey:ENTRY_TYPE] forKey:ENTRY_TYPE];
				if ([[object valueForKey:USER] isEqual:[PFUser currentUser]]) {
					[deal setValue:[NSNumber numberWithBool:YES] forKey:@"isOwnEntry"];
				}
				else {
					[deal setValue:[NSNumber numberWithBool:NO] forKey:@"isOwnEntry"];
				}
				entryFetchted = YES;
				if ( otherUserFetched) {
					[openDealsArr addObject:deal];
					[[NSUserDefaults standardUserDefaults] setObject:openDealsArr forKey:OPEN_DEALS];
					NSLog(@"added deal to cache");
				}
			}
		}];
	}
	
	NSLog(@"deal: %@", openDeal);
	
	if ([[[openDeal valueForKey:FROM_USER] objectId] isEqual:[[PFUser currentUser] objectId]]) { // we're proposing the deal to someone else
		NSLog(@"we're proposing the deal to someone else");
		[deal setValue:@"self" forKey:FROM_USER];
		PFUser* toUser = [openDeal valueForKey:TO_USER];
		[toUser fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
				if (object) {
					NSLog(@"fetched to user");
					[deal setValue:[object objectId] forKey:TO_USER];
					[deal setValue:[object valueForKey:FIRST_NAME] forKey:TO_USER_NAME];
					otherUserFetched = YES;
					if (entryFetchted) {
						[openDealsArr addObject:deal];
						[[NSUserDefaults standardUserDefaults] setObject:openDealsArr forKey:OPEN_DEALS];
						NSLog(@"added deal to cache");
					}
				}
		}];
	}
	else { // someone else is proposing a deal to us
		NSLog(@"someone else is proposing a deal to us");
		[deal setValue:@"self" forKey:TO_USER];
		PFUser* fromUser = [openDeal valueForKey:FROM_USER];
		[fromUser fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
			if (object) {
				NSLog(@"fetched from user");
				[deal setValue:[object objectId] forKey:FROM_USER];
				[deal setValue:[object valueForKey:FIRST_NAME] forKey:FROM_USER_NAME];
				otherUserFetched = YES;
				if (entryFetchted) {
					[openDealsArr addObject:deal];
					[[NSUserDefaults standardUserDefaults] setObject:openDealsArr forKey:OPEN_DEALS];
					NSLog(@"added deal to cache");
				}
			}
		}];
	}
}

+ (NSArray*)getOpenDeals {
	
	return [[NSUserDefaults standardUserDefaults] objectForKey:OPEN_DEALS];
}

+ (void)markDealAccepted:(NSString*)dealId {
	
	NSMutableDictionary* messages = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:MESSAGES]];
	NSArray* keys = [messages allKeys];
	for (NSString* key in keys) {
		NSMutableDictionary* messageDict = [[NSMutableDictionary alloc] initWithDictionary:[messages valueForKey:key]];
		if ([messageDict valueForKey:PROPOSED_DEAL]) {
			NSMutableDictionary* dealDict = [[NSMutableDictionary alloc] initWithDictionary:[messageDict valueForKey:PROPOSED_DEAL]];
			if ([[dealDict valueForKey:OBJECT_ID] isEqualToString:dealId]) {
				[dealDict setValue:[NSNumber numberWithBool:YES] forKey:IS_ACCEPTED];
				NSLog(@"marked deal as accepted");
				[messageDict setValue:dealDict forKey:PROPOSED_DEAL];
				[messages setValue:messageDict forKey:key];
				[[NSUserDefaults standardUserDefaults] setValue:messages forKey:MESSAGES];
				break;
			}
		}
	}
}

+ (void)updateOpenDealsCacheWithCompletionBlock:(void(^)(BOOL finished))completionBlock {
	
	Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
	if (![reach isReachable]) {	// network not available
		NSLog(@"network not available");
		dispatch_async(dispatch_get_main_queue(), ^{
			completionBlock(YES);
		});
	}
	else {
		PFQuery* fromQuery = [PFQuery queryWithClassName:@"Deal"];
		[fromQuery whereKey:FROM_USER equalTo:[PFUser currentUser]];
		PFQuery* toQuery = [PFQuery queryWithClassName:@"Deal"];
		[toQuery whereKey:TO_USER equalTo:[PFUser currentUser]];
		
		PFQuery* query = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:fromQuery, toQuery, nil]];
		[query whereKey:IS_ACCEPTED equalTo:[NSNumber numberWithBool:YES]];
		[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
			if (objects && [objects count] > 0) {
				__block NSInteger storeCount = 0;
				for (PFObject* deal in objects) {
					[SZDataManager markDealAccepted:[deal objectId]];
					[SZDataManager addOpenDealToUserCache:deal];
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
