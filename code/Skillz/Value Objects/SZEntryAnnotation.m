//
//  SZEntryAnnotation.m
//  Skillz
//
//  Created by Julia Roggatz on 17.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZEntryAnnotation.h"

@implementation SZEntryAnnotation

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;

- (id)initWithEntry:(SZEntryObject*)entry coordinate:(CLLocationCoordinate2D)coord {
	self = [super init];
	if (self) {
		self.entry = entry;
		coordinate = coord;
		title = self.entry.title;
		subtitle = [self.entry.user valueForKey:@"firstName"];
	}
	return self;
}

@end
