//
//  SZentryVO.m
//  Skillz
//
//  Created by Julia Roggatz on 31.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <Parse/Parse.h>
#import "SZEntryVO.h"

@implementation SZEntryVO

+ (PFObject*)serverObjectFromEntryVO:(SZEntryVO*)entryVO className:(NSString*)className {
	
	PFObject* object = [PFObject objectWithClassName:className];
	
	[object setObject:(entryVO.category) ? entryVO.category : [NSNull null] forKey:@"category"];
	[object setObject:(entryVO.subcategory) ? entryVO.subcategory : [NSNull null] forKey:@"subcategory"];
	[object setObject:(entryVO.title) ? entryVO.title : [NSNull null] forKey:@"title"];
	[object setObject:(entryVO.description) ? entryVO.description : [NSNull null] forKey:@"description"];
	[object setObject:[NSNumber numberWithBool:entryVO.locationWillGoSomewhere] forKey:@"locationWillGoSomewhere"];
	[object setObject:[NSNumber numberWithBool:entryVO.locationIsRemote] forKey:@"locationIsRemote"];
	[object setObject:[NSNumber numberWithBool:entryVO.withinZipCode] forKey:@"withinZipCode"];
	[object setObject:[NSNumber numberWithBool:entryVO.withinSpecifiedArea] forKey:@"withinSpecifiedArea"];
	[object setObject:[NSNumber numberWithBool:entryVO.withinNegotiableArea] forKey:@"withinNegotiableArea"];
	[object setObject:(entryVO.distance) ? entryVO.distance : [NSNull null] forKey:@"distance"];
	[object setObject:(entryVO.address) ? [SZAddressVO serverObjectFromAddressVO:entryVO.address] : [NSNull null] forKey:@"address"];
	[object setObject:[NSNumber numberWithBool:entryVO.priceIsNegotiable] forKey:@"priceIsNegotiable"];
	[object setObject:[NSNumber numberWithBool:entryVO.priceIsFixedPerHour] forKey:@"priceIsFixedPerHour"];
	[object setObject:[NSNumber numberWithBool:entryVO.priceIsFixedPerJob] forKey:@"priceIsFixedPerJob"];
	[object setObject:(entryVO.price) ? entryVO.price : [NSNull null] forKey:@"price"];
	[object setObject:[NSNumber numberWithBool:entryVO.hasTimeFrame] forKey:@"hasTimeFrame"];
	[object setObject:(entryVO.startTime) ? entryVO.startTime : [NSNull null] forKey:@"startTime"];
	[object setObject:(entryVO.endTime) ? entryVO.endTime : [NSNull null] forKey:@"endTime"];
	[object setObject:[SZUserVO PFUserFromUserVO:entryVO.user] forKey:@"user"];
	[object setObject:[NSNumber numberWithBool:entryVO.isActive] forKey:@"isActive"];
	
	return object;
}

+ (SZEntryVO*)entryVOFromPFObject:(PFObject*)object {
	
	SZEntryVO* entryVO = [[SZEntryVO alloc] init];
	
	entryVO.category = [object objectForKey:@"category"] != [NSNull null] ? [object objectForKey:@"category"] : nil;
	entryVO.subcategory = [object objectForKey:@"subcategory"] != [NSNull null] ? [object objectForKey:@"subcategory"] : nil;
	entryVO.title = [object objectForKey:@"title"] != [NSNull null] ? [object objectForKey:@"title"] : nil;
	entryVO.description = [object objectForKey:@"description"] != [NSNull null] ? [object objectForKey:@"description"] : nil;
	entryVO.locationWillGoSomewhere = [[object objectForKey:@"locationWillGoSomewhere"] boolValue];
	entryVO.locationIsRemote = [[object objectForKey:@"locationIsRemote"] boolValue];
	entryVO.withinZipCode = [[object objectForKey:@"withinZipCode"] boolValue];
	entryVO.withinNegotiableArea = [[object objectForKey:@"withinNegotiableArea"] boolValue];
	entryVO.distance = [object objectForKey:@"distance"] != [NSNull null] ? [object objectForKey:@"distance"] : nil;
	entryVO.address = [object objectForKey:@"address"] != [NSNull null] ? [SZAddressVO addressVOFromPFObject:[object objectForKey:@"address"]] : nil;
	entryVO.priceIsNegotiable = [[object objectForKey:@"priceIsNegotiable"] boolValue];
	entryVO.priceIsFixedPerHour = [[object objectForKey:@"priceIsFixedPerHour"] boolValue];
	entryVO.priceIsFixedPerJob = [[object objectForKey:@"priceIsFixedPerJob"] boolValue];
	entryVO.price = [object objectForKey:@"price"] != [NSNull null] ? [object objectForKey:@"price"] : nil;
	entryVO.hasTimeFrame = [[object objectForKey:@"hasTimeFrame"] boolValue];
	entryVO.startTime = [object objectForKey:@"startTime"] != [NSNull null] ? [object objectForKey:@"startTime"] : nil;
	entryVO.endTime = [object objectForKey:@"endTime"] != [NSNull null] ? [object objectForKey:@"endTime"] : nil;
	entryVO.user = [SZUserVO userVOfromPFUser:[object objectForKey:@"user"]];
	entryVO.isActive = [[object objectForKey:@"isActive"] boolValue];
	entryVO.objectID = object.objectId;
	
	return entryVO;
}

+ (NSDictionary*)dictionaryFromEntryVO:(SZEntryVO*)entryVO {

	NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
	
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
	if (entryVO.address) [dict setObject:[SZAddressVO dictionaryFromAddressVO:entryVO.address] forKey:@"address"];
	[dict setObject:[NSNumber numberWithBool:entryVO.priceIsNegotiable] forKey:@"priceIsNegotiable"];
	[dict setObject:[NSNumber numberWithBool:entryVO.priceIsFixedPerHour] forKey:@"priceIsFixedPerHour"];
	[dict setObject:[NSNumber numberWithBool:entryVO.priceIsFixedPerJob] forKey:@"priceIsFixedPerJob"];
	if (entryVO.price) [dict setObject:entryVO.price forKey:@"price"];
	[dict setObject:[NSNumber numberWithBool:entryVO.hasTimeFrame] forKey:@"hasTimeFrame"];
	if (entryVO.startTime) [dict setObject:entryVO.startTime forKey:@"startTime"];
	if (entryVO.endTime) [dict setObject:entryVO.endTime forKey:@"endTime"];
	[dict setObject:[NSNumber numberWithBool:entryVO.isActive] forKey:@"isActive"];
	if (entryVO.objectID) [dict setObject:entryVO.objectID forKey:@"objectID"];

	return dict;
}

+ (SZEntryVO*)entryVOfromDictionary:(NSDictionary*)dict {
	
	SZEntryVO* entryVO = [[SZEntryVO alloc] init];
	
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
	entryVO.address = [SZAddressVO addressVOFromDictionary:[dict valueForKey:@"address"]];
	entryVO.priceIsNegotiable = [[dict valueForKey:@"priceIsNegotiable"] boolValue];
	entryVO.priceIsFixedPerHour = [[dict valueForKey:@"priceIsFixedPerHour"] boolValue];
	entryVO.priceIsFixedPerJob = [[dict valueForKey:@"priceIsFixedPerJob"] boolValue];
	entryVO.price = [dict valueForKey:@"price"];
	entryVO.hasTimeFrame = [[dict valueForKey:@"hasTimeFrame"] boolValue];
	entryVO.startTime = [dict valueForKey:@"startTime"];
	entryVO.endTime = [dict valueForKey:@"endTime"];
	entryVO.isActive = [[dict valueForKey:@"isActive"] boolValue];
	entryVO.objectID = [dict valueForKey:@"objectID"];
	
	return entryVO;
}

+ (PFObject*)updatePFObject:(PFObject*)object withEntryVO:(SZEntryVO*)entryVO {
	
	[object setObject:(entryVO.category) ? entryVO.category : [NSNull null] forKey:@"category"];
	[object setObject:(entryVO.subcategory) ? entryVO.subcategory : [NSNull null] forKey:@"subcategory"];
	[object setObject:(entryVO.title) ? entryVO.title : [NSNull null] forKey:@"title"];
	[object setObject:(entryVO.description) ? entryVO.description : [NSNull null] forKey:@"description"];
	[object setObject:[NSNumber numberWithBool:entryVO.locationWillGoSomewhere] forKey:@"locationWillGoSomewhere"];
	[object setObject:[NSNumber numberWithBool:entryVO.locationIsRemote] forKey:@"locationIsRemote"];
	[object setObject:[NSNumber numberWithBool:entryVO.withinZipCode] forKey:@"withinZipCode"];
	[object setObject:[NSNumber numberWithBool:entryVO.withinSpecifiedArea] forKey:@"withinSpecifiedArea"];
	[object setObject:[NSNumber numberWithBool:entryVO.withinNegotiableArea] forKey:@"withinNegotiableArea"];
	[object setObject:(entryVO.distance) ? entryVO.distance : [NSNull null] forKey:@"distance"];
	[object setObject:(entryVO.address) ? [SZAddressVO serverObjectFromAddressVO:entryVO.address] : [NSNull null] forKey:@"address"];
	[object setObject:[NSNumber numberWithBool:entryVO.priceIsNegotiable] forKey:@"priceIsNegotiable"];
	[object setObject:[NSNumber numberWithBool:entryVO.priceIsFixedPerHour] forKey:@"priceIsFixedPerHour"];
	[object setObject:[NSNumber numberWithBool:entryVO.priceIsFixedPerJob] forKey:@"priceIsFixedPerJob"];
	[object setObject:(entryVO.price) ? entryVO.price : [NSNull null] forKey:@"price"];
	[object setObject:[NSNumber numberWithBool:entryVO.hasTimeFrame] forKey:@"hasTimeFrame"];
	[object setObject:(entryVO.startTime) ? entryVO.startTime : [NSNull null] forKey:@"startTime"];
	[object setObject:(entryVO.endTime) ? entryVO.endTime : [NSNull null] forKey:@"endTime"];
	[object setObject:[SZUserVO PFUserFromUserVO:entryVO.user] forKey:@"user"];
	[object setObject:[NSNumber numberWithBool:entryVO.isActive] forKey:@"isActive"];
	
	return object;
}

@end
