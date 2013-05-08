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

/** This class conforms to the MKAnnotation class used by the iOS CoreLocation framework to represent a location annotation on a map. It provides a coordinate representing the location as well as a title and subtitle that the corresponding annotation view will display if the annotation (represented by a needle pin) is tapped.
 */

@interface SZEntryAnnotation : NSObject <MKAnnotation> {
	
	CLLocationCoordinate2D coordinate;
	NSString* title;
	NSString* subtitle;
	
}

/** The corresponding <SZEntryObject> that the annotation represents.
 */
@property (nonatomic, strong) SZEntryObject* entry;

/** The coordinate of the annotation.
 */
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

/** The title that the annotation will display when tapped.
 */
@property (nonatomic, readonly) NSString* title;

/** The subtitle that the annotation will display when tapped.
 */
@property (nonatomic, readonly) NSString* subtitle;

/** This property is used to assign a specific tag to an annotation to make it easily retrievable
 */
@property (nonatomic, assign) NSInteger tag;

/// @name Initializing 

/** Initializes an SZEntryAnnotation object with a given <SZEntryObject> and coordinate.
 @param entry The <SZEntryObject> representing the entry that belongs to the annotation
 @param coord A coordinate object representing the annoation's location.
 @return An instance of SZEntryAnnotation
 */
- (id)initWithEntry:(SZEntryObject*)entry coordinate:(CLLocationCoordinate2D)coord;

@end
