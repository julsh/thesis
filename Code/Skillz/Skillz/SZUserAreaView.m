//
//  SZUserAreaView.m
//  Skillz
//
//  Created by Julia Roggatz on 01.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZUserAreaView.h"

@implementation SZUserAreaView

- (id)initWithUser:(SZUserVO*)user hasTimeFrameView:(BOOL)hasTimeFrameView 
{
	CGRect frame = hasTimeFrameView ? CGRectMake(0.0, 0.0, 290.0, 120.0) : CGRectMake(0.0, 0.0, 290.0, 121.0);
		
    self = [super initWithFrame:frame];
    if (self) {
		
		UIImage* bgImage = hasTimeFrameView ? [[UIImage imageNamed:@"details_middle2"] resizableImageWithCapInsets:UIEdgeInsetsMake(2.0, 2.0, 1.0, 2.0)] : [[UIImage imageNamed:@"details_middle"] resizableImageWithCapInsets:UIEdgeInsetsMake(1.0, 2.0, 1.0, 2.0)];
        
		UIImageView* bgImageView = [[UIImageView alloc] initWithImage:bgImage];
		[bgImageView setFrame:self.frame];
		[self addSubview:bgImageView];
    }
    return self;
}

@end
