//
//  SZAddressVO.m
//  Skillz
//
//  Created by Julia Roggatz on 31.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZAddressVO.h"

@implementation SZAddressVO

+ (PFObject*)serverObjectFromAddressVO:(SZAddressVO*)address {
	
	PFObject* object = [PFObject objectWithClassName:@"Address"];
	
	[object setObject:address.streetAddress forKey:@"streetAddress"];
	[object setObject:address.city forKey:@"city"];
	[object setObject:address.zipCode forKey:@"zipCode"];
	[object setObject:address.state forKey:@"state"];
	
	return object;
}

+ (SZAddressVO*)addressVOFromPFObject:(PFObject*)object {
	
	SZAddressVO* address = [[SZAddressVO alloc] init];
	
	address.streetAddress = [object objectForKey:@"streetAddress"];
	address.city = [object objectForKey:@"city"];
	address.zipCode = [object objectForKey:@"zipCode"];
	address.state = [object objectForKey:@"state"];
	
	return address;
}

+ (NSDictionary*)dictionaryFromAddressVO:(SZAddressVO*)address {
	
	NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
	
	[dict setObject:address.streetAddress forKey:@"streetAddress"];
	[dict setObject:address.city forKey:@"city"];
	[dict setObject:address.zipCode forKey:@"zipCode"];
	[dict setObject:address.state forKey:@"state"];
	
	return dict;
}

+ (SZAddressVO*)addressVOFromDictionary:(NSDictionary*)dict {
	
	if (dict == nil) {
		return nil;
	}
	
	SZAddressVO* addressVO = [[SZAddressVO alloc] init];
	
	addressVO.streetAddress = [dict valueForKey:@"streetAddress"];
	addressVO.city = [dict valueForKey:@"city"];
	addressVO.zipCode = [dict valueForKey:@"zipCode"];
	addressVO.state = [dict valueForKey:@"state"];
	
	return addressVO;
}

@end
