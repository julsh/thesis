//
//  SZRequestVO.h
//  Skillz
//
//  Created by Julia Roggatz on 31.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SZAddressVO.h"
#import "SZUserVO.h"

@interface SZEntryVO : NSObject

@property (nonatomic, strong) NSString* category;
@property (nonatomic, strong) NSString* subcategory;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* description;
@property (nonatomic, assign) BOOL locationWillGoSomewhere;
@property (nonatomic, assign) BOOL locationIsRemote;
@property (nonatomic, assign) BOOL withinZipCode;
@property (nonatomic, assign) BOOL withinSpecifiedArea;
@property (nonatomic, assign) BOOL withinNegotiableArea;
@property (nonatomic, strong) NSNumber* distance;
@property (nonatomic, strong) SZAddressVO* address;
@property (nonatomic, assign) BOOL priceIsNegotiable;
@property (nonatomic, assign) BOOL priceIsFixedPerHour;
@property (nonatomic, assign) BOOL priceIsFixedPerJob;
@property (nonatomic, strong) NSNumber* price;
@property (nonatomic, assign) BOOL hasTimeFrame;
@property (nonatomic, assign) NSDate* startTime;
@property (nonatomic, assign) NSDate* endTime;
@property (nonatomic, assign) SZUserVO* user;
@property (nonatomic, assign) BOOL isActive;
@property (nonatomic, assign) NSString* objectID;

+ (PFObject*)serverObjectFromEntryVO:(SZEntryVO*)entryVO className:(NSString*)className;
+ (SZEntryVO*)entryVOFromPFObject:(PFObject*)object;
+ (SZEntryVO*)entryVOFromPFObject:(PFObject*)object user:(PFUser*)user address:(PFObject*)address;
+ (NSDictionary*)dictionaryFromEntryVO:(SZEntryVO*)entryVO;
+ (SZEntryVO*)entryVOfromDictionary:(NSDictionary*)dict;
+ (PFObject*)updatePFObject:(PFObject*)object withEntryVO:(SZEntryVO*)entryVO;

@end
