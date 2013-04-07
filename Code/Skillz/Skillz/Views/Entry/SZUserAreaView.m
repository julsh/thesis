//
//  SZUserAreaView.m
//  Skillz
//
//  Created by Julia Roggatz on 01.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZUserAreaView.h"
#import "SZUtils.h"
#import "SZUserPhotoView.h"
#import "SZStarsView.h"

@interface SZUserAreaView ()

@property (nonatomic, strong) PFUser* user;

@end


@implementation SZUserAreaView

- (id)initWithUser:(PFUser*)user hasTimeFrameView:(BOOL)hasTimeFrameView
{
	
	self.user = user;
	
	CGRect frame = hasTimeFrameView ? CGRectMake(0.0, 0.0, 290.0, 102.0) : CGRectMake(0.0, 0.0, 290.0, 103.0);
		
    self = [super initWithFrame:frame];
    if (self) {
		
		UIImage* bgImage = hasTimeFrameView ? [[UIImage imageNamed:@"details_middle2"] resizableImageWithCapInsets:UIEdgeInsetsMake(2.0, 2.0, 1.0, 2.0)] : [[UIImage imageNamed:@"details_middle"] resizableImageWithCapInsets:UIEdgeInsetsMake(1.0, 2.0, 1.0, 2.0)];
        
		UIImageView* bgImageView = [[UIImageView alloc] initWithImage:bgImage];
		[bgImageView setFrame:self.frame];
		[self addSubview:bgImageView];
		
		
		[self addSubview:[self userPhoto]];
		[self addSubview:[self userName]];
		[self addSubview:[self reviewAmount]];
		[self addSubview:[self starsView]];
    }
    return self;
}

- (UIView*)userPhoto {
	
	SZUserPhotoView* userPhoto = [SZUserPhotoView emptyUserPhotoWithSize:SZUserPhotoViewSizeMedium];
	[userPhoto setFrame:CGRectMake(10.0, 10.0, userPhoto.frame.size.width, userPhoto.frame.size.height)];
	
	PFFile* photo = [self.user objectForKey:@"photo"];
	[photo getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
		if (data) {
			[userPhoto.photo setImage:[UIImage imageWithData:data]];
		}
		else if (error) {
			NSLog(@"ERRORRRR %@", error);
		}
	}];
	return userPhoto;
}

- (UILabel*)userName {
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(100.0, 32.0, 190.0, 30.0)];
	[label setAdjustsFontSizeToFitWidth:YES];
	[label setAdjustsLetterSpacingToFitWidth:YES];
	[label setFont:[SZGlobalConstants fontWithFontType:SZFontBold size:20.0]];
	[label setTextColor:[SZGlobalConstants darkPetrol]];
	[label applyWhiteShadow];
	[label setText:[self.user objectForKey:@"firstName"]];
	return label;
}

- (UILabel*)reviewAmount {
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(210.0, 70.0, 70.0, 20.0)];
	[label setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBoldItalic size:13.0]];
	[label setTextColor:[SZGlobalConstants gray]];
	[label applyWhiteShadow];
	NSArray* reviews = [self.user objectForKey:@"reviewPoints"];
	if ([reviews count] == 1) {
		[label setText:@"1 review"];
	}
	else {
		[label setText:[NSString stringWithFormat:@"%i reviews", [reviews count]]];
	}
	return label;
}

- (SZStarsView*)starsView {
	
	SZStarsView* starsView = [[SZStarsView alloc] initWithSize:SZStarViewSizeMedium];
	[starsView setStarsForReviewsArray:[self.user objectForKey:@"reviewPoints"]];
	[starsView setFrame:CGRectMake(100.0, 68.0, starsView.frame.size.width, starsView.frame.size.height)];
	return starsView;
	
}

@end
