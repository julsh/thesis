//
//  SZUserPhotoView.m
//  Skillz
//
//  Created by Julia Roggatz on 06.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZUserPhotoView.h"

@implementation SZUserPhotoView

- (id)initWithSize:(SZUserPhotoViewSize)size
{
	NSString* appendix;
	CGSize viewSize;
	switch (size) {
		case SZUserPhotoViewSizeLarge:
			appendix = @"_large";
			viewSize = CGSizeMake(300.0, 309.0);
			break;
		case SZUserPhotoViewSizeMedium:
			appendix = @"_medium";
			viewSize = CGSizeMake(80.0, 83.0);
			break;
		case SZUserPhotoViewSizeSmall:
			appendix = @"_small";
			viewSize = CGSizeMake(54.0, 56.0);
			break;
	}
	
    self = [super initWithFrame:CGRectMake(0.0, 0.0, viewSize.width, viewSize.height)];
    if (self) {
		
		self.photo = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, viewSize.width, viewSize.width)];
		[self.photo setContentMode:UIViewContentModeScaleAspectFill];
		[self.photo setClipsToBounds:YES];
		[self.photo setImage:[UIImage imageNamed:[NSString stringWithFormat:@"photo_empty%@", appendix]]];
		[self addSubview:self.photo];
		
		UIImageView* frameView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"photo_frame%@", appendix]]];
		[self addSubview:frameView];
		
    }
    return self;
}

+ (SZUserPhotoView*)emptyUserPhotoWithSize:(SZUserPhotoViewSize)size {
	return [[SZUserPhotoView alloc] initWithSize:size];
}


@end
