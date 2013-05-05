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

/** This class represents a table view controller that will run a search or browse query and display the results both in a list view and a map view. The user may switch between both views through a segmented control in the navigation bar.
 */
@interface SZSearchResultsVC : SZTableViewController <CLLocationManagerDelegate, MKMapViewDelegate>

/** Initializes an instance of SZSearchResultsVC with a given query
 @param query The query to run
 */
- (id)initWithQuery:(PFQuery*)query;

@end
