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

@interface SZEntryMapVC : UIViewController <MKMapViewDelegate>

- (id)initWithEntry:(SZEntryObject*)entry;

@end
