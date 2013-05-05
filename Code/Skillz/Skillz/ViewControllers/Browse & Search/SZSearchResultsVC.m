//
//  SZSearchResultsVC.m
//  Skillz
//
//  Created by Julia Roggatz on 05.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <MapKit/MapKit.h>

#import "SZSearchResultsVC.h"
#import "SZSearchResultCell.h"
#import "SZEntryObject.h"
#import "SZUtils.h"
#import "MBProgressHUD.h"
#import "SZEntryDetailVC.h"
#import "SZDataManager.h"
#import "SZEntryAnnotation.h"
#import "SZEntryMapAnnotationView.h"
#import "SZFilterMenuVC.h"
#import "SZSortMenuVC.h"
#import "SZMenuVC.h"

@interface SZSearchResultsVC ()

@property (nonatomic, strong) NSMutableArray* results;
@property (nonatomic, strong) NSMutableArray* filteredResults;
@property (nonatomic, assign) NSInteger fetchCount;
@property (nonatomic, strong) UIView* activityIndicator;
@property (nonatomic, strong) CLLocation* currentUserLocation;
@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) MKMapView* mapView;
@property (nonatomic, strong) UISegmentedControl* mapListSwitcher;
@property (nonatomic, strong) UISegmentedControl* menuButtons;
@property (nonatomic, strong) SZSortMenuVC* sortMenu;
@property (nonatomic, strong) SZFilterMenuVC* filterMenu;
@property (nonatomic, assign) NSInteger lastViewedMenuIndex;

@end

@implementation SZSearchResultsVC

@synthesize results = _results;
@synthesize activityIndicator = _activityIndicator;
@synthesize mapView = _mapView;
@synthesize mapListSwitcher = _mapListSwitcher;
@synthesize menuButtons = _menuButtons;

- (id)initWithQuery:(PFQuery*)query {
	
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {

		[self showActivityIndicator];
		
		self.locationManager = [[CLLocationManager alloc] init];
		self.locationManager.delegate = self;
		self.locationManager.distanceFilter = kCLDistanceFilterNone;
		self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
		
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
			if (objects) {
				if ([objects count] > 0) { // found something!
					NSLog(@"found something");
					for (int i = 0; i < [objects count]; i++) {
						PFObject* result = [objects objectAtIndex:i];
						if ([[result objectForKey:@"isActive"] boolValue]) { // only display if entry is activated
							
							PFUser *user = [result objectForKey:@"user"]; // fetch the user object that owns the entry
							[user fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
								if (object) {
									NSMutableDictionary* entryDict = [[NSMutableDictionary alloc] init];
									SZEntryObject* entry = (SZEntryObject*)result;
									entry.user = (PFUser*)object;
									[entryDict setObject:entry forKey:@"entry"];
									[self.results addObject:entryDict];
									[self setLocationForEntryDict:entryDict];
									
									self.fetchCount++;
									if (self.fetchCount == [objects count]) {
										[self displayResults];
									}
								}
								else if (error) {
									NSLog(@"Error: %@ %@", error, [error userInfo]);
									self.fetchCount++;
									if (self.fetchCount == [objects count]) {
										[self displayResults];
									}
								}
							}];
						}
						else {
							self.fetchCount++;
							if (self.fetchCount == [objects count]) {
								[self displayResults];
							}
						}
						
					}
				}
				else { // nothing found
					[self hideActivityIndicator];
					[self showNothingFound];
				}
			}
			else if (error) {
				NSLog(@"Error: %@ %@", error, [error userInfo]);
			}
		}];
    }
	
	self.sortMenu = [[SZSortMenuVC alloc] init];
	self.filterMenu = [[SZFilterMenuVC alloc] init];
	self.lastViewedMenuIndex = 0;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sortOrFilterMenuHidden:) name:NOTIF_FILTER_OR_SORT_MENU_HIDDEN object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSortOrFilterMenu:) name:NOTIF_LEFT_SWIPE object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applySort:) name:NOTIF_SORT object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyFilter:) name:NOTIF_FILTER object:nil];
	
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[self.navigationItem setTitleView:self.mapListSwitcher];
	UIBarButtonItem* menuItem = [[UIBarButtonItem alloc] initWithCustomView:self.menuButtons];
	[self.navigationItem setRightBarButtonItem:menuItem];
	[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	
}

- (UISegmentedControl*)mapListSwitcher {
	if (_mapListSwitcher == nil) {
		_mapListSwitcher = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0.0, 0.0, 120.0, 30.0)];
		[_mapListSwitcher insertSegmentWithTitle:@"List" atIndex:0 animated:NO];
		[_mapListSwitcher insertSegmentWithTitle:@"Map" atIndex:1 animated:NO];
		[_mapListSwitcher setSegmentedControlStyle:UISegmentedControlStyleBar];
		[_mapListSwitcher setTintColor:[SZGlobalConstants darkPetrol]];
		[_mapListSwitcher setSelectedSegmentIndex:0];
		[_mapListSwitcher setUserInteractionEnabled:NO];
		[_mapListSwitcher addTarget:self action:@selector(switchViews:) forControlEvents:UIControlEventValueChanged];
	}
	return _mapListSwitcher;
}

- (UISegmentedControl*)menuButtons {
	if (_menuButtons == nil) {
		_menuButtons = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0.0, 0.0, 80.0, 30.0)];
		[_menuButtons insertSegmentWithImage:[UIImage imageNamed:@"buttonIcon_sort"] atIndex:0 animated:NO];
		[_menuButtons insertSegmentWithImage:[UIImage imageNamed:@"buttonIcon_filter"] atIndex:1 animated:NO];
		[_menuButtons setSegmentedControlStyle:UISegmentedControlStyleBar];
		[_menuButtons setTintColor:[SZGlobalConstants darkPetrol]];
		[_menuButtons addTarget:self action:@selector(toggleSortOrFilterMenu:) forControlEvents:UIControlEventValueChanged];
	}
	return _menuButtons;
}

- (void)displayResults {
	self.filteredResults = self.results;
	[self sortByRating:YES];
	[self hideActivityIndicator];
	[self.tableView reloadData]; // once all results are complete, display them
	[self.mapListSwitcher setUserInteractionEnabled:YES];
}


- (void)setLocationForEntryDict:(NSMutableDictionary*)dict {
	
	SZEntryObject* entry = [dict valueForKey:@"entry"];
	if (entry.address || entry.areaType == SZEntryAreaWithinZipCode) {
		CLGeocoder* geoCoder = [[CLGeocoder alloc] init];
		
		if (entry.address) {
			PFGeoPoint* geoPoint = [entry valueForKey:@"geoPoint"];
			CLLocation* location = [[CLLocation alloc] initWithLatitude:geoPoint.latitude longitude:geoPoint.longitude];
			[geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
				if (placemarks && [placemarks count] > 0) {
					[dict setObject:[placemarks objectAtIndex:0] forKey:@"location"];
				}
			}];
		}
		else if (entry.areaType == SZEntryAreaWithinZipCode) {
			NSString* addressString;
			if (entry.areaType == SZEntryAreaWithinZipCode) addressString = [NSString stringWithFormat:@"%@ %@, USA",
													  [entry.user valueForKey:@"zipCode"],
													  [entry.user valueForKey:@"state"]];
			
			[geoCoder geocodeAddressString:addressString completionHandler:^(NSArray *placemarks, NSError *error) {
				if (placemarks && [placemarks count] > 0) {
					[dict setObject:[placemarks objectAtIndex:0] forKey:@"location"];
				}
			}];
		}
	}
}

- (MKMapView*)mapView {
	if (_mapView == nil) {
		_mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
		[_mapView setDelegate:self];
		[_mapView setShowsUserLocation:YES];
		
		
		for (int i = 0; i < [self.results count]; i++) {
			NSDictionary* dict = [self.results objectAtIndex:i];
			CLPlacemark* placemark = [dict valueForKey:@"location"];
			SZEntryAnnotation* anno = [[SZEntryAnnotation alloc] initWithEntry:[dict valueForKey:@"entry"] coordinate:placemark.location.coordinate];
			anno.tag = i;
			[_mapView addAnnotation:anno];
		}
		
		// setting the center of the map to either the user's current location, or to the search address specified by the user
		PFGeoPoint* mapCenter = [[SZDataManager sharedInstance].searchLocationBase objectForKey:@"geoPoint"];
		CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(mapCenter.latitude, mapCenter.longitude);
		MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(0.05, 0.05));
		[self.mapView setRegion:region];
	}
	return _mapView;
}

- (NSMutableArray*)results {
	if (_results == nil) {
		_results = [[NSMutableArray alloc] init];
	}
	return _results;
}

- (void)showActivityIndicator {
	
	if (_activityIndicator == nil) {
		_activityIndicator = [[UIView alloc] initWithFrame:CGRectMake(100.0, 160.0, 120.0, 120.0)];
		
		UIActivityIndicatorView* spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		[spinner setCenter:CGPointMake(60.0, 30.0)];
		[spinner startAnimating];
		[_activityIndicator addSubview:spinner];
		
		UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 50.0, 120.0, 20.0)];
		[label setTextAlignment:NSTextAlignmentCenter];
		[label setFont:[SZGlobalConstants fontWithFontType:SZFontBold size:16.0]];
		[label setTextColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5]];
		[label applyWhiteShadow];
		[label setText:@"Loading"];
		[_activityIndicator addSubview:label];
		
	}
	
	[self.tableView addSubview:self.activityIndicator];
}

- (void)hideActivityIndicator {
	
	[self.activityIndicator removeFromSuperview];
	self.activityIndicator = nil;
}

- (void)showNothingFound {
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 160.0, 320.0, 80.0)];
	[label setNumberOfLines:0];
	[label setTextAlignment:NSTextAlignmentCenter];
	[label setFont:[SZGlobalConstants fontWithFontType:SZFontBold size:30.0]];
	[label setTextColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5]];
	[label applyWhiteShadow];
	[label setText:@"No results\nfound"];
	[self.tableView addSubview:label];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return [self.filteredResults count];
}

- (SZSearchResultCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"resultCell";
	
	SZSearchResultCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
	
	if (cell == nil) {
		cell = [[SZSearchResultCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
	}
	
	NSMutableDictionary* dict = [self.filteredResults objectAtIndex:indexPath.row];
	
	SZEntryObject *entry = [dict valueForKey:@"entry"];
	
	cell.titleLabel.text = entry.title;

	NSString* category = entry.category;
	if (entry.subcategory) category = [category stringByAppendingFormat:@" > %@", entry.subcategory];
	cell.categoryLabel.text = category;
	
	if (entry.priceType == SZEntryPriceNegotiable) {
		cell.priceLabel.text = @"negotiable";
	}
	else {
		if (entry.price) {
			cell.priceLabel.text = [NSString stringWithFormat:@"%i/%@", [entry.price intValue], entry.priceType == SZEntryPriceFixedPerHour ? @"hour" : @"job"];
		}
	}
	
	if ([entry.user objectForKey:@"firstName"]) {
		cell.userName.text = [entry.user objectForKey:@"firstName"];
	}
	
	PFFile* photo = [entry.user objectForKey:@"photo"];
	[photo getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
		if (data) {
			UIImage* img = [UIImage imageWithData:data];
			[cell.userPhoto setPhoto:img];
		}
		else if (error) {
			NSLog(@"ERORRRR %@", error);
		}
	}];

	if ([entry.user objectForKey:@"reviewPoints"]) {
		[cell.starsView setStarsForReviewsArray:[entry.user objectForKey:@"reviewPoints"]];
	}
	
	PFGeoPoint* entryPoint = [entry valueForKey:@"geoPoint"];
	PFGeoPoint* searchPoint = [[SZDataManager sharedInstance].searchLocationBase valueForKey:@"geoPoint"];
	
	if (entryPoint && searchPoint) {
		CGFloat distance = [entryPoint distanceInMilesTo:searchPoint];
		[cell.distanceLabel setText:[NSString stringWithFormat:@"%.1f miles", distance]];
	}
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 114.0;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	SZEntryObject* entry = [[self.filteredResults objectAtIndex:indexPath.row] valueForKey:@"entry"];
	SZEntryDetailVC* vc = [[SZEntryDetailVC alloc] initWithEntry:entry];
	[self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - map view

- (void)switchViews:(UISegmentedControl*)sender {
	
//	[self.locationManager startUpdatingLocation];
	self.currentUserLocation = [[CLLocation alloc] initWithLatitude:37.785834 longitude:-122.406417];
	
	if (sender.selectedSegmentIndex == 1) {
		
		CGRect frame = self.mapView.frame;
		frame.origin.y = self.tableView.contentOffset.y;
		self.mapView.frame = frame;
		[self.view addSubview:self.mapView];
	}
	else if (sender.selectedSegmentIndex == 0) {
		if (_mapView != nil) {
			[self.mapView removeFromSuperview];
		}
	}
}

- (MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
	if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
	
	if ([annotation isKindOfClass:[SZEntryAnnotation class]]) {
        SZEntryMapAnnotationView* pinView = (SZEntryMapAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
		
        if (!pinView) {
			pinView = [[SZEntryMapAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
        }
        else {
            pinView.annotation = annotation;
		}
		pinView.rightCalloutAccessoryView.tag = ((SZEntryAnnotation*)annotation).tag;
		[(UIButton*)pinView.rightCalloutAccessoryView addTarget:self action:@selector(annotationButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
			
        return pinView;
    }
	
    return nil;
}

- (void)annotationButtonTapped:(UIButton*)sender {
	NSIndexPath* indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
	[self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - Sorting and filtering

- (void)applyFilter:(NSNotification*)notif {
	
	NSDictionary* filterDict = notif.userInfo;
	NSLog(@"filterDict: %@", filterDict);
	
	NSMutableArray* entriesToDelete = [[NSMutableArray alloc] init];
	
	self.filteredResults = [NSMutableArray arrayWithArray:self.results];
	
	for (NSDictionary* result in self.results) {
		SZEntryObject* entry = [result valueForKey:@"entry"];
		CGFloat rating = [SZUtils getAverageValueOfNumberArray:[entry.user valueForKey:@"reviewPoints"]];
		if (rating < [[filterDict valueForKey:@"minRating"] floatValue]) {
			[entriesToDelete addObject:result];
		}
	}
	
	for (NSDictionary* entryToDelete in entriesToDelete) {
		[self.filteredResults removeObject:entryToDelete];
	}
	
	[self.tableView reloadData];
}

- (void)applySort:(NSNotification*)notif {
	NSDictionary* sortDict = notif.userInfo;
	
	// sort by user rating
	if ([[sortDict valueForKey:@"sortBy"] isEqual:@"User Rating"]) {
		if ([[sortDict valueForKey:@"sortOrder"] isEqual:@"asc"])
			[self sortByRating:YES];
		else
			[self sortByRating:NO];
	}
	
	// sort by price
	else if ([[sortDict valueForKey:@"sortBy"] isEqual:@"Price"]) {
		if ([[sortDict valueForKey:@"sortOrder"] isEqual:@"asc"])
			[self sortByPrice:YES];
		else
			[self sortByPrice:NO];
	}
	
	// sort by distance
	else if ([[sortDict valueForKey:@"sortBy"] isEqual:@"Distance"]) {
		if ([[sortDict valueForKey:@"sortOrder"] isEqual:@"asc"])
			[self sortByDistanceToLocation:[sortDict valueForKey:@"sortLocation"] acending:YES];
		else
			[self sortByDistanceToLocation:[sortDict valueForKey:@"sortLocation"] acending:NO];
	}

	[self.tableView reloadData];
}

- (void)showSortOrFilterMenu:(NSNotification*)notif {
	if (!self.sortMenu.isShowing && ! self.filterMenu.isShowing) {
		[self.menuButtons setSelectedSegmentIndex:self.lastViewedMenuIndex];
		[self toggleSortOrFilterMenu:nil];
	}
}

- (void)toggleSortOrFilterMenu:(UISegmentedControl*)sender {
	
	if (!self.sortMenu.isShowing && ! self.filterMenu.isShowing) {
		[self.navigationController.parentViewController performSelector:@selector(toggleSortOrFilterMenu)];
	}
	[[SZMenuVC sharedInstance] removeAdditionalRightMenu];
	
	if (sender) {
		self.lastViewedMenuIndex = sender.selectedSegmentIndex;
	}
	
	switch (self.lastViewedMenuIndex) {
		case 0:
			[[SZMenuVC sharedInstance] addAdditionalRightMenu:self.sortMenu];
			self.sortMenu.isShowing = YES;
			self.filterMenu.isShowing = NO;
			break;
		case 1:
			[[SZMenuVC sharedInstance] addAdditionalRightMenu:self.filterMenu];
			self.filterMenu.isShowing = YES;
			self.sortMenu.isShowing = NO;
			break;
		default:
			break;
	}
}

- (void)sortOrFilterMenuHidden:(NSNotification*)notif {
	self.sortMenu.isShowing = NO;
	self.filterMenu.isShowing = NO;
	[self.menuButtons setSelectedSegmentIndex:UISegmentedControlNoSegment];
	
}

- (void)sortByRating:(BOOL)ascending {
	
	[self.filteredResults sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
		SZEntryObject* entry1 = (SZEntryObject*)[obj1 valueForKey:@"entry"];
		SZEntryObject* entry2 = (SZEntryObject*)[obj2 valueForKey:@"entry"];
		
		CGFloat reviewAverage1 = [SZUtils getAverageValueOfNumberArray:[entry1.user valueForKey:@"reviewPoints"]];
		CGFloat reviewAverage2 = [SZUtils getAverageValueOfNumberArray:[entry2.user valueForKey:@"reviewPoints"]];
		
		if (reviewAverage1 > reviewAverage2) {
			return ascending ? NSOrderedAscending : NSOrderedDescending;
		}
		else if (reviewAverage2 > reviewAverage1) {
			return ascending ? NSOrderedDescending : NSOrderedAscending;
		}
		else return NSOrderedSame;
	}];
}

- (void)sortByPrice:(BOOL)ascending {
	
	[self.filteredResults sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
		SZEntryObject* entry1 = (SZEntryObject*)[obj1 valueForKey:@"entry"];
		SZEntryObject* entry2 = (SZEntryObject*)[obj2 valueForKey:@"entry"];
		
		CGFloat price1 = entry1.price ? [entry1.price floatValue] : 0.0;
		CGFloat price2 = entry2.price ? [entry2.price floatValue] : 0.0;
		
		if (price1 > price2) {
			return ascending ? NSOrderedAscending : NSOrderedDescending;
		}
		else if (price2 > price1) {
			return ascending ? NSOrderedDescending : NSOrderedAscending;
		}
		else return NSOrderedSame;
	}];
}

- (void)sortByDistanceToLocation:(NSString*)locationString acending:(BOOL)ascending {

	if ([locationString isEqualToString:[[SZDataManager sharedInstance].searchLocationBase valueForKey:@"textInput"]] && [[SZDataManager sharedInstance].searchLocationBase valueForKey:@"geoPoint"]) { // location was already determined
		
		[self.filteredResults sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
			SZEntryObject* entry1 = (SZEntryObject*)[obj1 valueForKey:@"entry"];
			SZEntryObject* entry2 = (SZEntryObject*)[obj2 valueForKey:@"entry"];
			
			NSLog(@"search Point %@", [[SZDataManager sharedInstance].searchLocationBase valueForKey:@"geoPoint"]);
			
			CGFloat dist1, dist2;
			if ([entry1 valueForKey:@"geoPoint"]) 
				dist1 = [[entry1 valueForKey:@"geoPoint"] distanceInMilesTo:[[SZDataManager sharedInstance].searchLocationBase valueForKey:@"geoPoint"]];
			else 
				dist1 = 1000000.0;
			
			if ([entry2 valueForKey:@"geoPoint"])
				dist2 = [[entry2 valueForKey:@"geoPoint"] distanceInMilesTo:[[SZDataManager sharedInstance].searchLocationBase valueForKey:@"geoPoint"]];
			else
				dist2 = 1000000.0;
			
			if (dist1 > dist2) {
				return ascending ? NSOrderedAscending : NSOrderedDescending;
			}
			else if (dist2 > dist1) {
				return ascending ? NSOrderedDescending : NSOrderedAscending;
			}
			else return NSOrderedSame;
		}];
		
	}
	else { // location needs to be determined
		[[SZDataManager sharedInstance].searchLocationBase setValue:locationString forKey:@"textInput"];
		if ([locationString isEqualToString:@"Current Location"]) {
			[PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
				if (geoPoint) {
					NSLog(@"");
					[[SZDataManager sharedInstance].searchLocationBase setValue:geoPoint forKey:@"geoPoint"];
					[self sortByDistanceToLocation:locationString acending:ascending];
				}
			}];
			// recursively call this function again, now it should sort
			[self sortByDistanceToLocation:locationString acending:ascending];
		}
		else {
			if (![locationString isEqualToString:@""]) {
				CLGeocoder* geoCoder = [[CLGeocoder alloc] init];
				[geoCoder geocodeAddressString:locationString completionHandler:^(NSArray *placemarks, NSError *error) {
					if (placemarks && [placemarks count] > 0) {
						CLPlacemark* placemark = [placemarks objectAtIndex:0];
						PFGeoPoint* geoPoint = [PFGeoPoint geoPointWithLocation:placemark.location];
						[[SZDataManager sharedInstance].searchLocationBase setValue:geoPoint forKey:@"textInput"];
						// recursively call this function again, now it should sort
						[self sortByDistanceToLocation:locationString acending:ascending];
					}
				}];
			}
		}
	}
}


@end
