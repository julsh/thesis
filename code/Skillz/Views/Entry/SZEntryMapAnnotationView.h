//
//  SZEntryMapAnnotationView.h
//  Skillz
//
//  Created by Julia Roggatz on 17.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "SZUserPhotoView.h"
#import "SZStarsView.h"

/**
 This class represents a custom pin annotation representing an entry to be displayed within a map. It will contain the entry's title as well as the photo, name and average review rating of the entry's owner.
 This class has no custom public methods or properties because it subclasses MapKit's MKPinAnnotationView class and internally overrides its standard initialization method to take care of customizing the annotation view.
 */
@interface SZEntryMapAnnotationView : MKPinAnnotationView

@end
