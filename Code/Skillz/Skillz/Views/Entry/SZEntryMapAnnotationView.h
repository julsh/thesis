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

@interface SZEntryMapAnnotationView : MKPinAnnotationView

//@property (nonatomic, strong) UILabel* titleLabel;
//@property (nonatomic, strong) UILabel* pointsLabel;
//@property (nonatomic, strong) UILabel* userName;
@property (nonatomic, strong) SZUserPhotoView* userPhoto;
//@property (nonatomic, strong) SZStarsView* starsView;

@end
