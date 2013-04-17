//
//  SZEntryMapAnnotationView.m
//  Skillz
//
//  Created by Julia Roggatz on 17.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SZEntryMapAnnotationView.h"
#import "SZEntryAnnotation.h"

//@interface SZEntryMapAnnotationView ()
//
//
//@end

@implementation SZEntryMapAnnotationView

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.pinColor = MKPinAnnotationColorRed;
		self.animatesDrop = YES;
		self.canShowCallout = YES;
		
		SZEntryAnnotation* anno = annotation;
		
		UIButton* rightButton = [UIButton buttonWithType: UIButtonTypeDetailDisclosure];
		self.rightCalloutAccessoryView = rightButton;
		
        self.opaque = NO;
		
		
		UIView* contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 27.0, 28.0)];
		[contentView setClipsToBounds:NO];
		UIImageView* imgView = [[UIImageView alloc] initWithFrame:contentView.frame];
		[contentView addSubview:imgView];
		self.leftCalloutAccessoryView = contentView;
		
		// user photo
		PFFile* photo = [anno.entry.user objectForKey:@"photo"];
		[photo getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
			if (data) {
				UIImage* img = [UIImage imageWithData:data];
				[imgView setImage:img];
			}
			else if (error) {
				NSLog(@"ERORRRR %@", error);
			}
		}];
		
		CGSize subtitleSize = [[anno.entry.user valueForKey:@"firstName"] sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:11]];
		NSLog(@"%@ width: %f",[anno.entry.user valueForKey:@"firstName"], subtitleSize.width);
		
		SZStarsView* starsView = [[SZStarsView alloc] initWithSize:SZStarViewSizeSmall];
		[starsView setFrame:CGRectMake(45.0 + subtitleSize.width, 19.0, starsView.frame.size.width, starsView.frame.size.height)];
		if ([anno.entry.user objectForKey:@"reviewPoints"]) {
			[starsView setStarsForReviewsArray:[anno.entry.user objectForKey:@"reviewPoints"]];
		}
		[contentView addSubview:starsView];
		
		UILabel* reviewLabel = [[UILabel alloc] initWithFrame:CGRectMake(starsView.frame.origin.x + starsView.frame.size.width + 10.0, 19.0, 70.0, 12.0)];
		[reviewLabel setBackgroundColor:[UIColor clearColor]];
		[reviewLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Italic" size:12]];
		[reviewLabel setTextColor:[UIColor whiteColor]];
		NSArray* reviews = [anno.entry.user objectForKey:@"reviewPoints"];
		if ([reviews count] == 1) {
			[reviewLabel setText:@"1 review"];
		}
		else {
			[reviewLabel setText:[NSString stringWithFormat:@"%i reviews", [reviews count]]];
		}
		[contentView addSubview:reviewLabel];
		
		
    }
    return self;
}




@end
