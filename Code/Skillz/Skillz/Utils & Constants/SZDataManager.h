//
//  SZDataManager.h
//  Skillz
//
//  Created by Julia Roggatz on 31.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

/**
 The SZDataManager takes care of the local data cache. It is responsible for caching data that should be available in offline mode (such as own offers and requests, open deals and messages. Besides caching data that was created on the device, the SZDataManager communicates with the application's back end to check for new messages or accepted deal proposals, download the new data and cache it on the device as well.
 The SZDataManager is designed as a singleton. Its shared instance can be accessed by calling `[SZDataManager sharedInstance]`. However, most of it's methods are static, so the actual instance of the SZDataManager is usually only needed to store and access properties, with the exception of the the <saveCurrentEntry:completionBlock> method, which is an instance method.
 */

#import <Foundation/Foundation.h>
#import "NSMutableArray+Stack.h"
#import "SZEntryObject.h"

@interface SZDataManager : NSObject

/** @name Temporarily storing values to be available across different classes */

/** This property is used to temporarily save an entry object before it is sent to the server for persistant storage. It is used either during creation of a new entry or while an existing entry is edited by the user. Once an entry object is successfully stored in the data base, this property is reset to `nil`.
 */
@property (nonatomic, strong) SZEntryObject* currentEntry;

/** This property holds a reference to the current entry type that the GUI is representing, for example during browsing or searching for entries. Since offers and requests generally have the same structure, they are only distinguished by their entryType property to avoid code redundancy. The reference to the current entry type is needed internally to generate correct queries or labels while using only one class to perform both offer and request-related tasks. For instance, the <SZSubcategoriesVC> will set the title of its first cell to "All CategoryXY Requests" or "All CategoryXY Offers" depending on the value of this property.
 */
@property (nonatomic, assign) SZEntryType currentEntryType;

/** This property indicates whether the entry that is currently edited has been newly created or if it is an already existing entry that is updated by the user. This will result in different layouting behavior of the view controllers responsible for editing/creating entries. If the current entry is not new, the input elements will already be filled according to the entry's specified data
 */
@property (nonatomic, assign) BOOL currentEntryIsNew;

/** @name Managing an additional view controller stack */

/** A helper array serving as an additional view controller stack used to enable going back and forth between the different steps of creating/editing an entry without losing the view controllers that have been popped from the regular view controller stack when tapping the "Back" button (which is the default behavior). It uses the push and pop methods provided by the <NSMutableArray(Stack)> class category, which was created especially for this purpose.
 */
@property (nonatomic, strong) NSMutableArray* viewControllerStack;


/** This property stores location that the user set for a search (either a specific address or the current position)
 It is saved in a dictionary using the following keys:
 
 - `geoPoint` The geolocation of the search base. A `PFObject`
 - `textInput` The location that the user specified (an address, city, zip code or "Current Location"). An NSString object.
 - `radius` The maximum search radius. An NSNumber object
 
 Will be used to display distances of search results and as the center of the map showing the search results
 */
@property (nonatomic, strong) NSMutableDictionary* searchLocationBase;

/** @name Shared instance */

/** Singleton instance of the SZDataManager
 @return The shared instance of the SZDataManager
 */
+ (SZDataManager*)sharedInstance;

/** @name Accessing categories */

/**
 Static function to obtain an array containing string representation of all supported categories which downloaded and saved onto the device upon first application launch.
 @return An array containing string representations of all supported categories
 */
+ (NSArray*)sortedCategories;

/**
 Static function to obtain an array containing string representation of all supported subcategories for the specified category. All categories and subcategories have been downloaded and saved onto the device upon first application launch.
 @param category The category for which to look up the subcategories
 @return An array containing string representations of the respective subcategories or `nil` if no subcategories are specified.
 */
+ (NSArray*)sortedSubcategoriesForCategory:(NSString*)category;

/** Checks whether or not a certain category has a subcategory
 @param category The category for which to check for subcategory existance
 @return `YES` if the category has subcategories, `NO` if it doesn't
 */
+ (BOOL)categoryHasSubcategory:(NSString*)category;

/** @name Managing the cache for entry objects */

/** Posts the currently edited edited entry to the server and dispatches a completion block as soon as the saving process successfully completed
 @param completionBlock The block of code that is dispatched after successfully saving the current entry
 */
- (void)saveCurrentEntry:(void(^)(BOOL finished))completionBlock;

/** Adds an entry to the local cache file. If the entry already exists in the cache, it will be overwritten with the new version.
 @param entry the <SZEntryObject> which to store in the local cache
 */
+ (void)addEntryToUserCache:(SZEntryObject*)entry;

/** Removes an entry from the local cache file.
 @param entry the <SZEntryObject> which to remove from the local cache
 */
+ (void)removeEntryFromCache:(SZEntryObject*)entry;

/** @name Managing the cache for messages */

/** Stores a message object in the local cache and dispatches a completion block when finished
 @param message A `PFObject` representing the message which to store
 @param completionBlock The block of code which to execute after the operation successfully completed
 */
+ (void)addMessageToUserCache:(PFObject*)message completionBlock:(void(^)(BOOL finished))completionBlock;

/** Runs a query on the database to check for new messages and updates the "messages" cache accordingly, dispatches a completion block after the operation successfully completed (either when the is already cache is up to date or when the update completed). 
 @param completionBlock The block of code which to execute after the operation successfully completed. Returns an array containing the newly downloaded messages (or an empty array if there are no new messages) to be used by whatever class was calling the update.
 */
+ (void)updateMessageCacheWithCompletionBlock:(void(^)(NSArray* newMessages))completionBlock;

/** @name Managing the cache for open deals */

/** Stores a deal object in the local cache and dispatches a completion block when finished
 @param openDeal A `PFObject` representing the deal which to store
 */
+ (void)addOpenDealToUserCache:(PFObject*)openDeal;

/** Runs a query on the database to check for newly accepted deals and updates the "open deals" cache accordingly, dispatches a completion block after the operation successfully completed (either when the is already cache is up to date or when the update completed).
 @param completionBlock The block of code which to execute after the operation successfully completed
 */
+ (void)updateOpenDealsCacheWithCompletionBlock:(void(^)(BOOL finished))completionBlock;

/** @name Retrieving messages */

/** Retrieves all messages from the cache and arranges them into a nested array, grouped by conversation partner and sorted by date (newest messages first)
 @return A nested array, grouped by conversation partner and sorted by date. For each message thread, the newest message is the first object. The message threads are sorted by date as well with the message thread containing the most recent message as the first object.
 */
+ (NSMutableArray*)getGroupedMessages;

/** Retrieves an array of messages representing a message thread with a certain user (specified by user ID).
 @param userId the ID of the user for which to retrieve the message thread
 @return An array of dictionaries, each of which represents a distinct message. The array is sorted by date with the most recent message being the first object.
 */
+ (NSArray*)getMessageThreadForUserId:(NSString*)userId;

/** @name Storing address inputs */

/** Stores the last address that the user entered into an address form to be re-used in other address forms
 @param address A dictionary containing the last address that the user entered into an address form
 */
+ (void)saveLastEnderedAddress:(NSDictionary*)address;

/** Retrieves the last address that the user entered into an address form to be re-used in other address forms
 @return A dictionary containing the last address that the user entered into an address form
 */
+ (NSDictionary*)lastEnteredAddress;

@end
