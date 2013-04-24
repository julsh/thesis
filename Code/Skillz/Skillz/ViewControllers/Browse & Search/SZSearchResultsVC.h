//
//  SZSearchResultsVC.h
//  Skillz
//
//  Created by Julia Roggatz on 05.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

@interface SZSearchResultsVC : UITableViewController <CLLocationManagerDelegate, MKMapViewDelegate>

- (id)initWithQuery:(PFQuery*)query;

@property (nonatomic, strong) CLLocation* mapCenter;

@end
