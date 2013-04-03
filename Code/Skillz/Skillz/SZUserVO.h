//
//  SZUserVO.h
//  Skillz
//
//  Created by Julia Roggatz on 01.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <Parse/Parse.h>
#import <Foundation/Foundation.h>
#import "SZAddressVO.h"

@interface SZUserVO : NSObject

@property (nonatomic, strong) NSString* userID;
@property (nonatomic, strong) NSString* firstName;
@property (nonatomic, strong) NSString* lastName;
@property (nonatomic, strong) NSString* emailAddress;
@property (nonatomic, strong) NSString* zipCode;
@property (nonatomic, strong) NSString* state;
@property (nonatomic, assign) BOOL hasFullAddress;
//@property (nonatomic, strong) NSString* 

+ (SZUserVO*)userVOfromPFUser:(PFUser*)user;
+ (PFUser*)PFUserFromUserVO:(SZUserVO*)user;
- (BOOL)isWithinDistance:(NSNumber*)distance ofAddress:(SZAddressVO*)address;

@end
