//
//  SZEntryMapVC.m
//  Skillz
//
//  Created by Julia Roggatz on 16.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZEntryMapVC.h"

@interface SZEntryMapVC ()

@property (nonatomic, strong) SZEntryObject* entry;
@property (nonatomic, strong) MKMapView* mapView;
@property (nonatomic, strong) MKCircleView* circleView;

@end

@implementation SZEntryMapVC

@synthesize circleView = _circleView;

- (id)initWithEntry:(SZEntryObject*)entry {
    self = [super init];
    if (self) {
        self.entry = entry;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.navigationItem setTitle:[NSString stringWithFormat:@"%@'s %@", [self.entry.user valueForKey:@"firstName"], self.entry.withinZipCode ? @"Area" : @"Location"]];

	self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
	[self.mapView setShowsUserLocation:YES];
	[self.mapView setDelegate:self];
	[self.view addSubview:self.mapView];
	
	if (self.entry.address || self.entry.withinZipCode) {
		NSString* addressString;
		if (self.entry.address) addressString = [NSString stringWithFormat:@"%@, %@, %@ %@, USA",
											[self.entry.address valueForKey:@"streetAddress"],
											[self.entry.address valueForKey:@"city"],
											[self.entry.address valueForKey:@"state"],
											[self.entry.address valueForKey:@"zipCode"]];
		else if (self.entry.withinZipCode) addressString = [NSString stringWithFormat:@"%@ %@, USA",
													   [self.entry.user valueForKey:@"zipCode"],
													   [self.entry.user valueForKey:@"state"]];
		
		CLGeocoder* geoCoder = [[CLGeocoder alloc] init];
		[geoCoder geocodeAddressString:addressString completionHandler:^(NSArray *placemarks, NSError *error) {
			if (placemarks && [placemarks count] > 0) {
				
				CLPlacemark* placemark = [placemarks objectAtIndex:0];
				MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
				annotation.coordinate = placemark.location.coordinate;
				
				MKCoordinateRegion region;
				if (self.entry.locationWillGoSomewhere && !self.entry.locationIsRemote) {
					if (self.entry.withinZipCode) {
						MKCircle* circle = [MKCircle circleWithCenterCoordinate:[placemark region].center radius:[placemark region].radius];
						[self.mapView addOverlay:circle];
						region = MKCoordinateRegionMakeWithDistance([placemark region].center, [placemark region].radius*2, [placemark region].radius*2);
						annotation.title = [NSString stringWithFormat:@"%@'s Area", [self.entry.user objectForKey:@"firstName"]];
					}
					else if (self.entry.withinSpecifiedArea && self.entry.distance) {
						CGFloat radius = MilesToMeters([self.entry.distance floatValue]);
						MKCircle* circle = [MKCircle circleWithCenterCoordinate:[placemark region].center radius:radius];
						[self.mapView addOverlay:circle];
						region = MKCoordinateRegionMakeWithDistance([placemark region].center, radius, radius);
						annotation.title = [NSString stringWithFormat:@"%@'s Location", [self.entry.user objectForKey:@"firstName"]];
						annotation.subtitle = @"and max. travel distance";
					}
				}
				else if (!self.entry.locationWillGoSomewhere && !self.entry.locationIsRemote) {
					region = MKCoordinateRegionMakeWithDistance([placemark region].center, 800.0, 800.0);
					annotation.title = [NSString stringWithFormat:@"%@'s Location", [self.entry.user objectForKey:@"firstName"]];
				}
				
				[self.mapView setRegion:region animated:YES];
				[self.mapView addAnnotation:annotation];
				[self.mapView selectAnnotation:annotation animated:YES];
			}
		}];
	}
	
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id < MKOverlay >)overlay {
	
	if (_circleView == nil) {
		MKCircle* circle = (MKCircle*)overlay;
		_circleView = [[MKCircleView alloc] initWithCircle:circle];
		NSLog(@"created circe view with center: %f, %f // %f", circle.coordinate.latitude, circle.coordinate.longitude, circle.radius);
		_circleView.strokeColor = [SZGlobalConstants petrol];
        _circleView.fillColor = [[SZGlobalConstants petrol] colorWithAlphaComponent:0.2];
	}
	return _circleView;
	
}

@end
