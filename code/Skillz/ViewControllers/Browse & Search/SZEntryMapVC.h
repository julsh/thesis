//
//  SZEntryMapVC.h
//  Skillz
//
//  Created by Julia Roggatz on 16.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import "SZEntryObject.h"

/** This class represents a view controller displaying a map that shows the location or area of an entry.
 */
@interface SZEntryMapVC : UIViewController <MKMapViewDelegate>

/** Initializes an instance of SZEntryMapVC with a given <SZEntryObject>
 @param entry The <SZEntryObject> for which to display the location on the map
 */
- (id)initWithEntry:(SZEntryObject*)entry;

@end
