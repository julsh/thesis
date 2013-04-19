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
#import "SMCalloutView.h"
#import "SZFilterMenuVC.h"
#import "SZSortMenuVC.h"
#import "SZMenuVC.h"

@interface SZSearchResultsVC ()

@property (nonatomic, strong) NSMutableArray* results;
@property (nonatomic, assign) NSInteger fetchCount;
@property (nonatomic, strong) UIView* activityIndicator;
@property (nonatomic, strong) CLLocation* currentUserLocation;
@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) MKMapView* mapView;
@property (nonatomic, strong) UISegmentedControl* mapListSwitcher;
@property (nonatomic, strong) UISegmentedControl* menuButtons;
@property (nonatomic, strong) SZSortMenuVC* sortMenu;
@property (nonatomic, strong) SZFilterMenuVC* filterMenu;

@end

@implementation SZSearchResultsVC

@synthesize results = _results;
@synthesize activityIndicator = _activityIndicator;
@synthesize mapView = _mapView;

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
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sortOrFilterMenuHidden:) name:NOTIF_FILTER_OR_SORT_MENU_HIDDEN object:nil];
	
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Back"
																			   style:UIBarButtonItemStylePlain
																			  target:nil
																			  action:nil]];
	
	self.mapListSwitcher = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0.0, 0.0, 120.0, 30.0)];
	[self.mapListSwitcher insertSegmentWithTitle:@"List" atIndex:0 animated:NO];
	[self.mapListSwitcher insertSegmentWithTitle:@"Map" atIndex:1 animated:NO];
	[self.mapListSwitcher setSegmentedControlStyle:UISegmentedControlStyleBar];
	[self.mapListSwitcher setTintColor:[SZGlobalConstants darkPetrol]];
	[self.mapListSwitcher setSelectedSegmentIndex:0];
	[self.mapListSwitcher setUserInteractionEnabled:NO];
	[self.mapListSwitcher addTarget:self action:@selector(switchViews:) forControlEvents:UIControlEventValueChanged];
	[self.navigationItem setTitleView:self.mapListSwitcher];
	
	self.menuButtons = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0.0, 0.0, 80.0, 30.0)];
	[self.menuButtons insertSegmentWithTitle:@"AA" atIndex:0 animated:NO];
	[self.menuButtons insertSegmentWithTitle:@"BB" atIndex:1 animated:NO];
	[self.menuButtons setSegmentedControlStyle:UISegmentedControlStyleBar];
	[self.menuButtons setTintColor:[SZGlobalConstants darkPetrol]];
	[self.menuButtons addTarget:self action:@selector(toggleSortOrFilterMenu:) forControlEvents:UIControlEventValueChanged];
	UIBarButtonItem* menuItem = [[UIBarButtonItem alloc] initWithCustomView:self.menuButtons];
	
//	UIImage *filterImage = [UIImage imageNamed:@"buttonIcon_filter"];
//	UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithImage:filterImage style:UIBarButtonItemStylePlain target:self action:@selector(showFilter:)];
	[self.navigationItem setRightBarButtonItem:menuItem];
	
	[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_pattern"]]];
	[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	
//	[[SZMenuVC sharedInstance] addHiddenMenu:sortMenu];
//	[self.navigationController.parentViewController performSelector:@selector(addHiddenViewController:) withObject:sortMenu];
//	[self.navigationController addChildViewController:sortMenu];
//	[self.navigationController.parentViewController.view insertSubview:sortMenu.view atIndex:2];
}

- (void)displayResults {
	[self hideActivityIndicator];
	[self.tableView reloadData]; // once all results are complete, display them
	[self.mapListSwitcher setUserInteractionEnabled:YES];
}

- (void)setLocationForEntryDict:(NSMutableDictionary*)dict {
	
	SZEntryObject* entry = [dict valueForKey:@"entry"];
	if (entry.address || entry.withinZipCode) {
		NSString* addressString;
		if (entry.address) addressString = [NSString stringWithFormat:@"%@, %@, %@ %@, USA",
											[entry.address valueForKey:@"streetAddress"],
											[entry.address valueForKey:@"city"],
											[entry.address valueForKey:@"state"],
											[entry.address valueForKey:@"zipCode"]];
		else if (entry.withinZipCode) addressString = [NSString stringWithFormat:@"%@ %@, USA",
													   [entry.user valueForKey:@"zipCode"],
													   [entry.user valueForKey:@"state"]];
		
		CLGeocoder* geoCoder = [[CLGeocoder alloc] init];
		[geoCoder geocodeAddressString:addressString completionHandler:^(NSArray *placemarks, NSError *error) {
			if (placemarks && [placemarks count] > 0) {
				[dict setObject:[placemarks objectAtIndex:0] forKey:@"location"];
//				NSArray* indexPaths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]];
//				[self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
			}
		}];
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
		
		
		MKCoordinateRegion region = MKCoordinateRegionMake(self.currentUserLocation.coordinate, MKCoordinateSpanMake(0.05, 0.05));
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
   return [self.results count];
}

- (SZSearchResultCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"resultCell";
	
	SZSearchResultCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
	
	if (cell == nil) {
		cell = [[SZSearchResultCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
	}
	
	NSMutableDictionary* dict = [self.results objectAtIndex:indexPath.row];
	
	SZEntryObject *entry = [dict valueForKey:@"entry"];
	
	cell.titleLabel.text = entry.title;

	NSString* category = entry.category;
	if (entry.subcategory) category = [category stringByAppendingFormat:@" > %@", entry.subcategory];
	cell.categoryLabel.text = category;
	
	if (entry.priceIsNegotiable) {
		cell.pointsLabel.text = @"negotiable";
	}
	else {
		if (entry.price) {
			cell.pointsLabel.text = [NSString stringWithFormat:@"%i/%@", [entry.price intValue], entry.priceIsFixedPerHour ? @"hour" : @"job"];
		}
	}
	
	if ([entry.user objectForKey:@"firstName"]) {
		cell.userName.text = [entry.user objectForKey:@"firstName"];
	}
	
	PFFile* photo = [entry.user objectForKey:@"photo"];
	[photo getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
		if (data) {
			UIImage* img = [UIImage imageWithData:data];
			[cell.userPhoto.photo setImage:img];
		}
		else if (error) {
			NSLog(@"ERORRRR %@", error);
		}
	}];

	if ([entry.user objectForKey:@"reviewPoints"]) {
		[cell.starsView setStarsForReviewsArray:[entry.user objectForKey:@"reviewPoints"]];
	}
	
	
//	if ([dict valueForKey:@"location"]) {
//		NSLog(@"got location: %@", [dict valueForKey:@"location"]);
//		CLPlacemark* entryPlacemark = [dict valueForKey:@"location"];
//		CLLocation* entryLocation = entryPlacemark.location;
//		CLLocationDistance distance = [entryLocation distanceFromLocation:self.currentUserLocation];
//		NSLog(@"current user location: %@", self.currentUserLocation);
//		NSLog(@"distance: %f", distance);
//		[cell.distanceLabel setText:[NSString stringWithFormat:@"%.2f miles", MetersToMiles(distance)]];
//	}
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 114.0;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	SZEntryObject* entry = [[self.results objectAtIndex:indexPath.row] valueForKey:@"entry"];
	SZEntryDetailVC* vc = [[SZEntryDetailVC alloc] initWithEntry:entry type:[SZDataManager sharedInstance].currentEntryType];
	[self.navigationController pushViewController:vc animated:YES];
}


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

- (void)toggleSortOrFilterMenu:(UISegmentedControl*)sender {
	
	if (!self.sortMenu.isShowing && ! self.filterMenu.isShowing) {
		[self.navigationController.parentViewController performSelector:@selector(toggleSortOrFilterMenu)];
	}
	
	[[SZMenuVC sharedInstance] removeHiddenMenu];
	
	switch (sender.selectedSegmentIndex) {
		case 0:
			[[SZMenuVC sharedInstance] addHiddenMenu:self.sortMenu];
			self.sortMenu.isShowing = YES;
			self.filterMenu.isShowing = NO;
			break;
		case 1:
			[[SZMenuVC sharedInstance] addHiddenMenu:self.filterMenu];
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


@end
