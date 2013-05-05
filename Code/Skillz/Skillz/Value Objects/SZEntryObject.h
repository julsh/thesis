//
//  SZEntryObject.h
//  Skillz
//
//  Created by Julia Roggatz on 31.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <Parse/Parse.h>
#import <Foundation/Foundation.h>

typedef enum {
	SZEntryLocationWillGoSomewhereElse,
	SZEntryLocationWillStayAtHome,
	SZEntryLocationRemote
} SZEntryLocationType;

typedef enum {
	SZEntryAreaWithinZipCode,
	SZEntryAreaWithinSpecifiedArea,
	SZEntryAreaWithinNegotiableArea
} SZEntryAreaType;

typedef enum {
	SZEntryPriceNegotiable,
	SZEntryPriceFixedPerHour,
	SZEntryPriceFixedPerJob
} SZEntryPriceType;

/** The SZEntryObject is a server object representing an offer or request. Since entry objects are among the most uses objects within the code base of this project, subclassing PFObject enables easier access to stored properties. Through subclassing, properties can be accessed like this:
	`entry.description` instead of `[entry valueForKey:@"description"]`
 */

@interface SZEntryObject : PFObject<PFSubclassing>


/// @name Storing values


/** The type of the entry.
 
 Uses the `SZEntryType` enumerator. Allowed values are:
 
 - `SZEntryTypeRequest`
 - `SZEntryTypeOffer`
 
 */
@property (nonatomic, assign) SZEntryType type;

/** The `PFUser` that owns the entry.
 */
@property (nonatomic, strong) PFUser* user;

/** Indicates whether or not the entry is active. Entries will only be displayed in search/browse results they are active, but will be listed in the "My Offers" or "My Requests" view for their owners even if they are inactive.
 */
@property (nonatomic, assign) BOOL isActive;

/** The category that the entry belongs to.
 */
@property (nonatomic, strong) NSString* category;

/** The subcategory that the entry belongs to. Can be `nil` if not subcategory is specified.
 */
@property (nonatomic, strong) NSString* subcategory;

/** The title of the entry. Entries will be displayed with their titles in search/browse results or when references in a message thread.
 */
@property (nonatomic, strong) NSString* title;

/** The full description of the entry.
 */
@property (nonatomic, strong) NSString* description;

/** The location type of the entry.
 
 Uses the `SZEntryLocationType` enumerator. Allowed values are:
 
 - `SZEntryLocationWillGoSomewhereElse`	<-- The user specified they are willing to go somewhere else 
 - `SZEntryLocationWillStayAtHome`		<-- The user specified that others have to come to them
 - `SZEntryLocationRemote`				<-- The user specified that the work can be done remotely
 
 */

@property (nonatomic, assign) SZEntryLocationType locationType;

/** If the user specified that they are willing to go somewhere else to perform the work, this property specifies the area in which the user is willing to travel.
 
 Uses the `SZEntryAreaType` enumerator. Allowed values are:
 
 - `SZEntryAreaWithinZipCode`			<-- The user specified they will only travel within their own zip code area
 - `SZEntryAreaWithinSpecifiedArea`		<-- The user specified an address and a maximum distance they are willing to travel
 - `SZEntryAreaWithinNegotiableArea`	<-- The user specified that the travel distance is negotiable
 
 */
@property (nonatomic, assign) SZEntryAreaType areaType;

/** Specifies the whether or not the user specified a price for the entry, and if yes, if the price is hour-based or job-baced.

 Uses the `SZEntryPriceType` enumerator. Allowed values are:
 
 - `SZEntryPriceNegotiable`		<-- The user didn't specify the price.
 - `SZEntryPriceFixedPerHour`	<-- The user set a fixed hourly rate.
 - `SZEntryPriceFixedPerJob`	<-- The user set a fixed job-based rate.
 
 */
@property (nonatomic, assign) SZEntryPriceType priceType;

/** Specifies the maximum distance which the user is willing to travel, used in combination with the <address> property.
 */
@property (nonatomic, strong) NSNumber* distance;

/** Specifies the an address, either where people have to go (if the user requires people to come to their location) or the base address for the maximum travel area (in combination with the <distance> property).
 */
@property (nonatomic, strong) NSDictionary* address;

/** If the user specified an address or the `SZEntryAreaType` is set to `SZEntryAreaWithinZipCode`, this property holds the geo coordinates of the location.
 */
@property (nonatomic, strong) PFGeoPoint* geoPoint;

/** If the user specified an price for the entry, it is stored in this property.
 */
@property (nonatomic, strong) NSNumber* price;

/** Specifies whether or not the user has set a time frame on the entry.
 */
@property (nonatomic, assign) BOOL hasTimeFrame;

/** If the user specified a time frame for the entry, the start time is stored in this property.
 */
@property (nonatomic, strong) NSDate* startTime;

/** If the user specified a time frame for the entry, the start time is stored in this property.
 */
@property (nonatomic, strong) NSDate* endTime;

/// @name Providing the correct class name

/** Overrides the `parseClassName` method of PFObject to return the correct class name with which objects will be retrieved from the database. In this case that would be `Entry`.
 */
+ (NSString *)parseClassName;

/// @name Converting from and to Dictionaries

/** Converts an `SZEntryObject` into an `NSDictionary` to be stored locally.
 @param entryVO The `SZEntryObject` which to convert.
 @return An `NSDictionary` object representing the entry.
 */
+ (NSDictionary*)dictionaryFromEntryVO:(SZEntryObject*)entryVO;

/** Converts an `NSDictionary` (usually retrieved from the local cache) into an `SZEntryObject`.
 @param dict The `NSDictionary` which to convert.
 @return An `SZEntryObject` object representing the entry.
 */
+ (SZEntryObject*)entryVOfromDictionary:(NSDictionary*)dict;

@end
