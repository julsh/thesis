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
@dynamic distance;
@dynamic address;
@dynamic price;
@dynamic hasTimeFrame;
@dynamic startTime;
@dynamic endTime;

@synthesize locationType = _locationType;
@synthesize areaType = _areaType;
@synthesize priceType = _priceType;


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

- (SZEntryLocationType)locationType {
	
	if ([[self objectForKey:@"locationWillGoSomewhere"] boolValue])
		return SZEntryLocationWillGoSomewhereElse;
	else if ([[self objectForKey:@"locationIsRemote"] boolValue])
		return SZEntryLocationRemote;
	else
		return SZEntryLocationWillStayAtHome;
	
}

- (void)setLocationType:(SZEntryLocationType)locationType {
	
	[self setObject:[NSNumber numberWithBool:locationType == SZEntryLocationWillGoSomewhereElse] forKey:@"locationWillGoSomewhere"];
	[self setObject:[NSNumber numberWithBool:locationType == SZEntryLocationRemote] forKey:@"locationIsRemote"];
	
}

- (SZEntryAreaType)areaType {
	if ([[self objectForKey:@"withinZipCode"] boolValue])
		return SZEntryAreaWithinZipCode;
	else if ([[self objectForKey:@"withinSpecifiedArea"] boolValue])
		return SZEntryAreaWithinSpecifiedArea;
	else
		return SZEntryAreaWithinNegotiableArea;
}

- (void)setAreaType:(SZEntryAreaType)areaType {
	
	[self setObject:[NSNumber numberWithBool:areaType == SZEntryAreaWithinZipCode] forKey:@"withinZipCode"];
	[self setObject:[NSNumber numberWithBool:areaType == SZEntryAreaWithinSpecifiedArea] forKey:@"withinSpecifiedArea"];
	[self setObject:[NSNumber numberWithBool:areaType == SZEntryAreaWithinNegotiableArea] forKey:@"withinNegotiableArea"];
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

- (PFGeoPoint*)geoPoint {
	if ([self objectForKey:@"geoPoint"] && [self objectForKey:@"address"] != [NSNull null]) {
		return [self objectForKey:@"geoPoint"];
	}
	else return nil;
}

- (void)setGeoPoint:(PFGeoPoint *)geoPoint {
	if (geoPoint) {
		[self setObject:geoPoint forKey:@"geoPoint"];
	}
	else {
		[self setObject:[NSNull null] forKey:@"geoPoint"];
	}
}

- (SZEntryPriceType)priceType {
	if ([[self objectForKey:@"priceIsFixedPerHour"] boolValue])
		return SZEntryPriceFixedPerHour;
	else if ([[self objectForKey:@"priceIsFixedPerJob"] boolValue])
		return SZEntryPriceFixedPerJob;
	else
		return SZEntryPriceNegotiable;
		
}

- (void)setPriceType:(SZEntryPriceType)priceType {
	
	[self setObject:[NSNumber numberWithBool:priceType == SZEntryPriceFixedPerHour] forKey:@"priceIsFixedPerHour"];
	[self setObject:[NSNumber numberWithBool:priceType == SZEntryPriceFixedPerJob] forKey:@"priceIsFixedPerJob"];
	[self setObject:[NSNumber numberWithBool:priceType == SZEntryPriceNegotiable] forKey:@"priceIsNegotiable"];
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

+ (NSDictionary*)dictionaryFromEntryVO:(SZEntryObject*)entryVO {

	NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
	
	if (entryVO.objectId) [dict setObject:entryVO.objectId forKey:@"objectID"];
	[dict setObject:[NSNumber numberWithBool:entryVO.isActive] forKey:@"isActive"];
	if (entryVO.category) [dict setObject:entryVO.category forKey:@"category"];
	if (entryVO.subcategory) [dict setObject:entryVO.subcategory forKey:@"subcategory"];
	if (entryVO.title) [dict setObject:entryVO.title forKey:@"title"];
	if (entryVO.description) [dict setObject:entryVO.description forKey:@"description"];
	[dict setObject:[NSNumber numberWithInt:entryVO.locationType] forKey:@"locationType"];
	[dict setObject:[NSNumber numberWithInt:entryVO.areaType] forKey:@"areaType"];
	if (entryVO.distance) [dict setObject:entryVO.distance forKey:@"distance"];
	if (entryVO.address) [dict setObject:entryVO.address forKey:@"address"];
	[dict setObject:[NSNumber numberWithInt:entryVO.priceType] forKey:@"priceType"];
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
	entryVO.locationType = [[dict valueForKey:@"locationType"] intValue];
	entryVO.areaType = [[dict valueForKey:@"areaType"] intValue];
	entryVO.distance = [dict valueForKey:@"distance"];
	entryVO.address = [dict valueForKey:@"address"];
	entryVO.priceType = [[dict valueForKey:@"priceType"] intValue];
	entryVO.price = [dict valueForKey:@"price"];
	entryVO.hasTimeFrame = [[dict valueForKey:@"hasTimeFrame"] boolValue];
	entryVO.startTime = [dict valueForKey:@"startTime"];
	entryVO.endTime = [dict valueForKey:@"endTime"];
	entryVO.isActive = [[dict valueForKey:@"isActive"] boolValue];
	entryVO.objectId = [dict valueForKey:@"objectID"];
	
	return entryVO;
}


@end
