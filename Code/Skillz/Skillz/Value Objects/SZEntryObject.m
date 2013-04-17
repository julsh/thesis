//
//  SZEntryObject.m
//  Skillz
//
//  Created by Julia Roggatz on 31.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZEntryObject.h"
#import <Parse/PFObject+Subclass.h>

@implementation SZEntryObject

@dynamic type;
@dynamic user;
@dynamic isActive;
@dynamic category;
@dynamic subcategory;
@dynamic title;
@dynamic description;
@dynamic locationWillGoSomewhere;
@dynamic locationIsRemote;
@dynamic withinZipCode;
@dynamic withinSpecifiedArea;
@dynamic withinNegotiableArea;
@dynamic distance;
@dynamic address;
@dynamic priceIsNegotiable;
@dynamic priceIsFixedPerHour;
@dynamic priceIsFixedPerJob;
@dynamic price;
@dynamic hasTimeFrame;
@dynamic startTime;
@dynamic endTime;

//@synthesize type = _type;
//@synthesize user = _user;
//@synthesize isActive = _isActive;
//@synthesize category = _category;
//@synthesize subcategory = _subcategory;
//@synthesize title = _title;
//@synthesize description = _description;
//@synthesize locationWillGoSomewhere = _locationWillGoSomewhere;
//@synthesize locationIsRemote = _locationIsRemote;
//@synthesize withinZipCode = _withinZipCode;
//@synthesize withinSpecifiedArea = _withinSpecifiedArea;
//@synthesize withinNegotiableArea = _withinNegotiableArea;
//@synthesize distance = _distance;
//@synthesize address = _address;
//@synthesize priceIsNegotiable = _priceIsNegotiable;
//@synthesize priceIsFixedPerHour = _priceIsFixedPerHour;
//@synthesize priceIsFixedPerJob = _priceIsFixedPerJob;
//@synthesize price = _price;
//@synthesize hasTimeFrame = _hasTimeFrame;
//@synthesize startTime = _startTime;
//@synthesize endTime = _endTime;

//+ (SZEntryVO*)entryWithEntryType:(SZEntryType)type {
//	
//	SZEntryVO* entry = (SZEntryVO*)[PFObject objectWithClassName:@"Entry"];
//	entry.type = type;
//	return entry;
//	
//}

+ (NSString *)parseClassName {
	return @"Entry";
}

- (SZEntryType)type {
	if ([[self objectForKey:@"entryType"] isEqualToString:@"offer"]) {
		return SZEntryTypeOffer;
	}
	else if ([[self objectForKey:@"entryType"] isEqualToString:@"request"]) {
		return SZEntryTypeRequest;
	}
	return NSNotFound;
}

- (void)setType:(SZEntryType)type {
	switch (type) {
		case SZEntryTypeOffer:
			[self setObject:@"offer" forKey:@"entryType"];
			break;
		case SZEntryTypeRequest:
			[self setObject:@"request" forKey:@"entryType"];
			break;
	}
}

- (PFUser*)user {
	return [self objectForKey:@"user"];
}

- (void)setUser:(PFUser *)user {
	if (user) {
		[self setObject:user forKey:@"user"];
	}
	else {
		[self setObject:[NSNull null] forKey:@"user"];
	}
}

- (BOOL)isActive {
	return [[self objectForKey:@"isActive"] boolValue];
}

- (void)setIsActive:(BOOL)isActive {
	[self setObject:[NSNumber numberWithBool:isActive] forKey:@"isActive"];
}

- (NSString*)category {
	if ([self objectForKey:@"category"] && [self objectForKey:@"category"] != [NSNull null]) {
		return [self objectForKey:@"category"];
	}
	else return nil;
}

- (void)setCategory:(NSString *)category {
	if (category) {
		[self setObject:category forKey:@"category"];
	}
	else {
		[self setObject:[NSNull null] forKey:@"category"];
	}
}

- (NSString*)subcategory {
	if ([self objectForKey:@"subcategory"] && [self objectForKey:@"subcategory"] != [NSNull null]) {
		return [self objectForKey:@"subcategory"];
	}
	else return nil;
}

- (void)setSubcategory:(NSString *)subcategory {
	if (subcategory) {
		[self setObject:subcategory forKey:@"subcategory"];
	}
	else {
		[self setObject:[NSNull null] forKey:@"subcategory"];
	}
}

- (NSString*)title {
	if ([self objectForKey:@"title"] && [self objectForKey:@"title"] != [NSNull null]) {
		return [self objectForKey:@"title"];
	}
	else return nil;
}

- (void)setTitle:(NSString *)title {
	if (title) {
		[self setObject:title forKey:@"title"];
	}
	else {
		[self setObject:[NSNull null] forKey:@"title"];
	}
}

- (NSString*)description {
	if ([self objectForKey:@"description"] && [self objectForKey:@"description"] != [NSNull null]) {
		return [self objectForKey:@"description"];
	}
	else return nil;
}

- (void)setDescription:(NSString *)description {
	if (description) {
		[self setObject:description forKey:@"description"];
	}
	else {
		[self setObject:[NSNull null] forKey:@"description"];
	}
}

- (BOOL)locationWillGoSomewhere {
	return [[self objectForKey:@"locationWillGoSomewhere"] boolValue];
}

- (void)setLocationWillGoSomewhere:(BOOL)locationWillGoSomewhere {
	[self setObject:[NSNumber numberWithBool:locationWillGoSomewhere] forKey:@"locationWillGoSomewhere"];
}

- (BOOL)locationIsRemote {
	return [[self objectForKey:@"locationIsRemote"] boolValue];
}

- (void)setLocationIsRemote:(BOOL)locationIsRemote {
	[self setObject:[NSNumber numberWithBool:locationIsRemote] forKey:@"locationIsRemote"];
}

- (BOOL)withinZipCode {
	return [[self objectForKey:@"withinZipCode"] boolValue];
}

- (void)setWithinZipCode:(BOOL)withinZipCode {
	[self setObject:[NSNumber numberWithBool:withinZipCode] forKey:@"withinZipCode"];
}

- (BOOL)withinSpecifiedArea {
	return [[self objectForKey:@"withinSpecifiedArea"] boolValue];
}

- (void)setWithinSpecifiedArea:(BOOL)withinSpecifiedArea {
	[self setObject:[NSNumber numberWithBool:withinSpecifiedArea] forKey:@"withinSpecifiedArea"];
}

- (NSNumber*)distance {
	if ([self objectForKey:@"distance"] && [self objectForKey:@"distance"] != [NSNull null]) {
		return [self objectForKey:@"distance"];
	}
	else return nil;
}

- (void)setDistance:(NSNumber *)distance {
	if (distance) {
		[self setObject:distance forKey:@"distance"];
	}
	else {
		[self setObject:[NSNull null] forKey:@"distance"];
	}
}

- (NSDictionary*)address {
	if ([self objectForKey:@"address"] && [self objectForKey:@"address"] != [NSNull null]) {
		return [self objectForKey:@"address"];
	}
	else return nil;
}

- (void)setAddress:(NSDictionary *)address {
	if (address) {
		[self setObject:address forKey:@"address"];
	}
	else {
		[self setObject:[NSNull null] forKey:@"address"];
	}
}

- (BOOL)priceIsFixedPerHour {
	return [[self objectForKey:@"priceIsFixedPerHour"] boolValue];
}

- (void)setPriceIsFixedPerHour:(BOOL)priceIsFixedPerHour {
	[self setObject:[NSNumber numberWithBool:priceIsFixedPerHour] forKey:@"priceIsFixedPerHour"];
}

- (BOOL)priceIsFixedPerJob {
	return [[self objectForKey:@"priceIsFixedPerJob"] boolValue];
}

- (void)setPriceIsFixedPerJob:(BOOL)priceIsFixedPerJob {
	[self setObject:[NSNumber numberWithBool:priceIsFixedPerJob] forKey:@"priceIsFixedPerJob"];
}

- (BOOL)priceIsNegotiable {
	return [[self objectForKey:@"priceIsNegotiable"] boolValue];
}

- (void)setPriceIsNegotiable:(BOOL)priceIsNegotiable {
	[self setObject:[NSNumber numberWithBool:priceIsNegotiable] forKey:@"priceIsNegotiable"];
}

- (NSNumber*)price {
	if ([self objectForKey:@"price"] && [self objectForKey:@"price"] != [NSNull null]) {
		return [self objectForKey:@"price"];
	}
	else return nil;
}

- (void)setPrice:(NSNumber *)price {
	if (price) {
		[self setObject:price forKey:@"price"];
	}
	else {
		[self setObject:[NSNull null] forKey:@"price"];
	}
}

- (BOOL)hasTimeFrame {
	return [[self objectForKey:@"hasTimeFrame"] boolValue];
}

- (void)setHasTimeFrame:(BOOL)hasTimeFrame {
	[self setObject:[NSNumber numberWithBool:hasTimeFrame] forKey:@"hasTimeFrame"];
}

- (NSDate*)startTime {
	if ([self objectForKey:@"startTime"] && [self objectForKey:@"startTime"] != [NSNull null]) {
		return [self objectForKey:@"startTime"];
	}
	else return nil;
}

- (void)setStartTime:(NSDate *)startTime {
	if (startTime) {
		[self setObject:startTime forKey:@"startTime"];
	}
	else {
		[self setObject:[NSNull null] forKey:@"startTime"];
	}
}

- (NSDate*)endTime {
	if ([self objectForKey:@"endTime"] && [self objectForKey:@"endTime"] != [NSNull null]) {
		return [self objectForKey:@"endTime"];
	}
	else return nil;
}

- (void)setEndTime:(NSDate *)endTime {
	if (endTime) {
		[self setObject:endTime forKey:@"endTime"];
	}
	else {
		[self setObject:[NSNull null] forKey:@"endTime"];
	}
}

//+ (PFObject*)serverObjectFromEntryVO:(SZEntryVO*)entryVO className:(NSString*)className {
//	
//	PFObject* object = [PFObject objectWithClassName:className];
//	
//	[object setObject:(entryVO.category) ? entryVO.category : [NSNull null] forKey:@"category"];
//	[object setObject:(entryVO.subcategory) ? entryVO.subcategory : [NSNull null] forKey:@"subcategory"];
//	[object setObject:(entryVO.title) ? entryVO.title : [NSNull null] forKey:@"title"];
//	[object setObject:(entryVO.description) ? entryVO.description : [NSNull null] forKey:@"description"];
//	[object setObject:[NSNumber numberWithBool:entryVO.locationWillGoSomewhere] forKey:@"locationWillGoSomewhere"];
//	[object setObject:[NSNumber numberWithBool:entryVO.locationIsRemote] forKey:@"locationIsRemote"];
//	[object setObject:[NSNumber numberWithBool:entryVO.withinZipCode] forKey:@"withinZipCode"];
//	[object setObject:[NSNumber numberWithBool:entryVO.withinSpecifiedArea] forKey:@"withinSpecifiedArea"];
//	[object setObject:[NSNumber numberWithBool:entryVO.withinNegotiableArea] forKey:@"withinNegotiableArea"];
//	[object setObject:(entryVO.distance) ? entryVO.distance : [NSNull null] forKey:@"distance"];
//	[object setObject:(entryVO.address) ? entryVO.address : [NSNull null] forKey:@"address"];
//	[object setObject:[NSNumber numberWithBool:entryVO.priceIsNegotiable] forKey:@"priceIsNegotiable"];
//	[object setObject:[NSNumber numberWithBool:entryVO.priceIsFixedPerHour] forKey:@"priceIsFixedPerHour"];
//	[object setObject:[NSNumber numberWithBool:entryVO.priceIsFixedPerJob] forKey:@"priceIsFixedPerJob"];
//	[object setObject:(entryVO.price) ? entryVO.price : [NSNull null] forKey:@"price"];
//	[object setObject:[NSNumber numberWithBool:entryVO.hasTimeFrame] forKey:@"hasTimeFrame"];
//	[object setObject:(entryVO.startTime) ? entryVO.startTime : [NSNull null] forKey:@"startTime"];
//	[object setObject:(entryVO.endTime) ? entryVO.endTime : [NSNull null] forKey:@"endTime"];
//	[object setObject:entryVO.user forKey:@"user"];
//	[object setObject:[NSNumber numberWithBool:entryVO.isActive] forKey:@"isActive"];
//	
//	return object;
//}
//
//+ (SZEntryVO*)entryVOFromPFObject:(PFObject*)object user:(PFUser*)user {
//	
//	SZEntryVO* entryVO = [[SZEntryVO alloc] init];
//	
//	entryVO.category = [object objectForKey:@"category"] != [NSNull null] ? [object objectForKey:@"category"] : nil;
//	entryVO.subcategory = [object objectForKey:@"subcategory"] != [NSNull null] ? [object objectForKey:@"subcategory"] : nil;
//	entryVO.title = [object objectForKey:@"title"] != [NSNull null] ? [object objectForKey:@"title"] : nil;
//	entryVO.description = [object objectForKey:@"description"] != [NSNull null] ? [object objectForKey:@"description"] : nil;
//	entryVO.locationWillGoSomewhere = [[object objectForKey:@"locationWillGoSomewhere"] boolValue];
//	entryVO.locationIsRemote = [[object objectForKey:@"locationIsRemote"] boolValue];
//	entryVO.withinZipCode = [[object objectForKey:@"withinZipCode"] boolValue];
//	entryVO.withinNegotiableArea = [[object objectForKey:@"withinNegotiableArea"] boolValue];
//	entryVO.distance = [object objectForKey:@"distance"] != [NSNull null] ? [object objectForKey:@"distance"] : nil;
//	entryVO.priceIsNegotiable = [[object objectForKey:@"priceIsNegotiable"] boolValue];
//	entryVO.priceIsFixedPerHour = [[object objectForKey:@"priceIsFixedPerHour"] boolValue];
//	entryVO.priceIsFixedPerJob = [[object objectForKey:@"priceIsFixedPerJob"] boolValue];
//	entryVO.price = [object objectForKey:@"price"] != [NSNull null] ? [object objectForKey:@"price"] : nil;
//	entryVO.hasTimeFrame = [[object objectForKey:@"hasTimeFrame"] boolValue];
//	entryVO.startTime = [object objectForKey:@"startTime"] != [NSNull null] ? [object objectForKey:@"startTime"] : nil;
//	entryVO.endTime = [object objectForKey:@"endTime"] != [NSNull null] ? [object objectForKey:@"endTime"] : nil;
//	entryVO.isActive = [[object objectForKey:@"isActive"] boolValue];
//	entryVO.objectID = object.objectId;
//	entryVO.address = [object objectForKey:@"address"] != [NSNull null] ? [object objectForKey:@"address"] : nil;
//	
//	if (user) {
//		entryVO.user = user;
//	}
//	
//	return entryVO;
//	
//}
//
//+ (SZEntryVO*)entryVOFromPFObject:(PFObject*)object {
//	
//	SZEntryVO* entryVO = [[SZEntryVO alloc] init];
//	
//	entryVO.category = [object objectForKey:@"category"] != [NSNull null] ? [object objectForKey:@"category"] : nil;
//	entryVO.subcategory = [object objectForKey:@"subcategory"] != [NSNull null] ? [object objectForKey:@"subcategory"] : nil;
//	entryVO.title = [object objectForKey:@"title"] != [NSNull null] ? [object objectForKey:@"title"] : nil;
//	entryVO.description = [object objectForKey:@"description"] != [NSNull null] ? [object objectForKey:@"description"] : nil;
//	entryVO.locationWillGoSomewhere = [[object objectForKey:@"locationWillGoSomewhere"] boolValue];
//	entryVO.locationIsRemote = [[object objectForKey:@"locationIsRemote"] boolValue];
//	entryVO.withinZipCode = [[object objectForKey:@"withinZipCode"] boolValue];
//	entryVO.withinNegotiableArea = [[object objectForKey:@"withinNegotiableArea"] boolValue];
//	entryVO.distance = [object objectForKey:@"distance"] != [NSNull null] ? [object objectForKey:@"distance"] : nil;
//	entryVO.address = [object objectForKey:@"address"] != [NSNull null] ? [object objectForKey:@"address"] : nil;
//	entryVO.priceIsNegotiable = [[object objectForKey:@"priceIsNegotiable"] boolValue];
//	entryVO.priceIsFixedPerHour = [[object objectForKey:@"priceIsFixedPerHour"] boolValue];
//	entryVO.priceIsFixedPerJob = [[object objectForKey:@"priceIsFixedPerJob"] boolValue];
//	entryVO.price = [object objectForKey:@"price"] != [NSNull null] ? [object objectForKey:@"price"] : nil;
//	entryVO.hasTimeFrame = [[object objectForKey:@"hasTimeFrame"] boolValue];
//	entryVO.startTime = [object objectForKey:@"startTime"] != [NSNull null] ? [object objectForKey:@"startTime"] : nil;
//	entryVO.endTime = [object objectForKey:@"endTime"] != [NSNull null] ? [object objectForKey:@"endTime"] : nil;
//	entryVO.user = [object objectForKey:@"user"];
//	entryVO.isActive = [[object objectForKey:@"isActive"] boolValue];
//	entryVO.objectID = object.objectId;
//	
//	return entryVO;
//}
//
+ (NSDictionary*)dictionaryFromEntryVO:(SZEntryObject*)entryVO {

	NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
	
	if (entryVO.objectId) [dict setObject:entryVO.objectId forKey:@"objectID"];
	[dict setObject:[NSNumber numberWithBool:entryVO.isActive] forKey:@"isActive"];
	if (entryVO.category) [dict setObject:entryVO.category forKey:@"category"];
	if (entryVO.subcategory) [dict setObject:entryVO.subcategory forKey:@"subcategory"];
	if (entryVO.title) [dict setObject:entryVO.title forKey:@"title"];
	if (entryVO.description) [dict setObject:entryVO.description forKey:@"description"];
	[dict setObject:[NSNumber numberWithBool:entryVO.locationWillGoSomewhere] forKey:@"locationWillGoSomewhere"];
	[dict setObject:[NSNumber numberWithBool:entryVO.locationIsRemote] forKey:@"locationIsRemote"];
	[dict setObject:[NSNumber numberWithBool:entryVO.withinZipCode] forKey:@"withinZipCode"];
	[dict setObject:[NSNumber numberWithBool:entryVO.withinSpecifiedArea] forKey:@"withinSpecifiedArea"];
	[dict setObject:[NSNumber numberWithBool:entryVO.withinNegotiableArea] forKey:@"withinNegotiableArea"];
	if (entryVO.distance) [dict setObject:entryVO.distance forKey:@"distance"];
	if (entryVO.address) [dict setObject:entryVO.address forKey:@"address"];
	[dict setObject:[NSNumber numberWithBool:entryVO.priceIsNegotiable] forKey:@"priceIsNegotiable"];
	[dict setObject:[NSNumber numberWithBool:entryVO.priceIsFixedPerHour] forKey:@"priceIsFixedPerHour"];
	[dict setObject:[NSNumber numberWithBool:entryVO.priceIsFixedPerJob] forKey:@"priceIsFixedPerJob"];
	if (entryVO.price) [dict setObject:entryVO.price forKey:@"price"];
	[dict setObject:[NSNumber numberWithBool:entryVO.hasTimeFrame] forKey:@"hasTimeFrame"];
	if (entryVO.startTime) [dict setObject:entryVO.startTime forKey:@"startTime"];
	if (entryVO.endTime) [dict setObject:entryVO.endTime forKey:@"endTime"];

	return dict;
}

+ (SZEntryObject*)entryVOfromDictionary:(NSDictionary*)dict {
	
	SZEntryObject* entryVO = [SZEntryObject object];
	
	entryVO.category = [dict valueForKey:@"category"];
	entryVO.subcategory = [dict valueForKey:@"subcategory"];
	entryVO.title = [dict valueForKey:@"title"];
	entryVO.description = [dict valueForKey:@"description"];
	entryVO.locationWillGoSomewhere = [[dict valueForKey:@"locationWillGoSomewhere"] boolValue];
	entryVO.locationIsRemote = [[dict valueForKey:@"locationIsRemote"] boolValue];
	entryVO.withinZipCode = [[dict valueForKey:@"withinZipCode"] boolValue];
	entryVO.withinSpecifiedArea = [[dict valueForKey:@"withinSpecifiedArea"] boolValue];
	entryVO.withinNegotiableArea = [[dict valueForKey:@"withinNegotiableArea"] boolValue];
	entryVO.distance = [dict valueForKey:@"distance"];
	entryVO.address = [dict valueForKey:@"address"];
	entryVO.priceIsNegotiable = [[dict valueForKey:@"priceIsNegotiable"] boolValue];
	entryVO.priceIsFixedPerHour = [[dict valueForKey:@"priceIsFixedPerHour"] boolValue];
	entryVO.priceIsFixedPerJob = [[dict valueForKey:@"priceIsFixedPerJob"] boolValue];
	entryVO.price = [dict valueForKey:@"price"];
	entryVO.hasTimeFrame = [[dict valueForKey:@"hasTimeFrame"] boolValue];
	entryVO.startTime = [dict valueForKey:@"startTime"];
	entryVO.endTime = [dict valueForKey:@"endTime"];
	entryVO.isActive = [[dict valueForKey:@"isActive"] boolValue];
	entryVO.objectId = [dict valueForKey:@"objectID"];
	
	return entryVO;
}


//
//+ (PFObject*)updatePFObject:(PFObject*)object withEntryVO:(SZEntryVO*)entryVO {
//	
//	[object setObject:(entryVO.category) ? entryVO.category : [NSNull null] forKey:@"category"];
//	[object setObject:(entryVO.subcategory) ? entryVO.subcategory : [NSNull null] forKey:@"subcategory"];
//	[object setObject:(entryVO.title) ? entryVO.title : [NSNull null] forKey:@"title"];
//	[object setObject:(entryVO.description) ? entryVO.description : [NSNull null] forKey:@"description"];
//	[object setObject:[NSNumber numberWithBool:entryVO.locationWillGoSomewhere] forKey:@"locationWillGoSomewhere"];
//	[object setObject:[NSNumber numberWithBool:entryVO.locationIsRemote] forKey:@"locationIsRemote"];
//	[object setObject:[NSNumber numberWithBool:entryVO.withinZipCode] forKey:@"withinZipCode"];
//	[object setObject:[NSNumber numberWithBool:entryVO.withinSpecifiedArea] forKey:@"withinSpecifiedArea"];
//	[object setObject:[NSNumber numberWithBool:entryVO.withinNegotiableArea] forKey:@"withinNegotiableArea"];
//	[object setObject:(entryVO.distance) ? entryVO.distance : [NSNull null] forKey:@"distance"];
//	[object setObject:(entryVO.address) ? entryVO.address : [NSNull null] forKey:@"address"];
//	[object setObject:[NSNumber numberWithBool:entryVO.priceIsNegotiable] forKey:@"priceIsNegotiable"];
//	[object setObject:[NSNumber numberWithBool:entryVO.priceIsFixedPerHour] forKey:@"priceIsFixedPerHour"];
//	[object setObject:[NSNumber numberWithBool:entryVO.priceIsFixedPerJob] forKey:@"priceIsFixedPerJob"];
//	[object setObject:(entryVO.price) ? entryVO.price : [NSNull null] forKey:@"price"];
//	[object setObject:[NSNumber numberWithBool:entryVO.hasTimeFrame] forKey:@"hasTimeFrame"];
//	[object setObject:(entryVO.startTime) ? entryVO.startTime : [NSNull null] forKey:@"startTime"];
//	[object setObject:(entryVO.endTime) ? entryVO.endTime : [NSNull null] forKey:@"endTime"];
//	[object setObject:entryVO.user forKey:@"user"];
//	[object setObject:[NSNumber numberWithBool:entryVO.isActive] forKey:@"isActive"];
//	
//	return object;
//}

@end
