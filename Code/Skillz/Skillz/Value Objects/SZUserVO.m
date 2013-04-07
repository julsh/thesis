//
//  SZUserVO.m
//  Skillz
//
//  Created by Julia Roggatz on 01.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZUserVO.h"

@implementation SZUserVO

+ (SZUserVO*)userVOfromPFUser:(PFUser*)user {
	
	SZUserVO* userVO = [[SZUserVO alloc] init];
	
	userVO.userID = user.objectId;
    userVO.emailAddress = user.email;
	userVO.firstName = [user objectForKey:@"firstName"];
	userVO.lastName = [user objectForKey:@"lastName"];
	userVO.zipCode = [user objectForKey:@"zipCode"];
	userVO.state = [user objectForKey:@"state"];
	userVO.reviewPoints = [user objectForKey:@"reviewPoints"];
	
	return userVO;
}

+ (PFUser*)PFUserFromUserVO:(SZUserVO*)user {
	
	return [PFQuery getUserObjectWithId:user.userID];
}

- (BOOL)isWithinDistance:(NSNumber*)distance ofAddress:(NSDictionary*)address {
	// TODO calculate real return value
	
	return YES;
}

@end
