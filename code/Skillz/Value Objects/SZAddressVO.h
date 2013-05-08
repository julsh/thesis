//
//  SZAddressVO.h
//  Skillz
//
//  Created by Julia Roggatz on 31.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZAddressVO : NSObject

@property (nonatomic, strong) NSString* streetAddress;
@property (nonatomic, strong) NSString* city;
@property (nonatomic, strong) NSString* zipCode;
@property (nonatomic, strong) NSString* state;
//@property (nonatomic, strong) NSString* ownerID;

+ (PFObject*)serverObjectFromAddressVO:(SZAddressVO*)address;
+ (SZAddressVO*)addressVOFromPFObject:(PFObject*)object;
+ (NSDictionary*)dictionaryFromAddressVO:(SZAddressVO*)address;
+ (SZAddressVO*)addressVOFromDictionary:(NSDictionary*)dict;

@end
