//
//  SZEntryAnnotation.h
//  Skillz
//
//  Created by Julia Roggatz on 17.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <Foundation/Foundation.h>
#import "SZEntryObject.h"

@interface SZEntryAnnotation : NSObject <MKAnnotation> {
	
	CLLocationCoordinate2D coordinate;
	NSString* title;
	NSString* subtitle;
	
}

@property (nonatomic, strong) SZEntryObject* entry;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) NSString* title;
@property (nonatomic, readonly) NSString* subtitle;
@property (nonatomic, assign) NSInteger tag;

- (id)initWithEntry:(SZEntryObject*)entry coordinate:(CLLocationCoordinate2D)coord;

@end
