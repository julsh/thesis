//
//  SZUserPhotoView.m
//  Skillz
//
//  Created by Julia Roggatz on 06.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZUserPhotoView.h"

@interface SZUserPhotoView ()

@property (nonatomic, strong) UIImageView* imgView;

@end

@implementation SZUserPhotoView

@synthesize photo = _photo;

- (id)initWithSize:(SZUserPhotoViewSize)size {
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
		
		self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, viewSize.width, viewSize.width)];
		[self.imgView setContentMode:UIViewContentModeScaleAspectFill];
		[self.imgView setClipsToBounds:YES];
		[self.imgView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"photo_empty%@", appendix]]];
		[self addSubview:self.imgView];
		
		UIImageView* frameView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"photo_frame%@", appendix]]];
		[self addSubview:frameView];
		
    }
    return self;
}

- (void)setPhoto:(UIImage *)photo {
	_photo = photo;
	[self.imgView setImage:photo];
}

+ (SZUserPhotoView*)emptyUserPhotoViewWithSize:(SZUserPhotoViewSize)size {
	return [[SZUserPhotoView alloc] initWithSize:size];
}

+ (SZUserPhotoView*)userPhotoViewWithSize:(SZUserPhotoViewSize)size photo:(UIImage*)photo  {
	SZUserPhotoView* view = [[SZUserPhotoView alloc] initWithSize:size];
	view.photo = photo;
	return view;
}

+ (SZUserPhotoView*)userPhotoViewWithSize:(SZUserPhotoViewSize)size fileReference:(PFFile*)file {
	SZUserPhotoView* view = [[SZUserPhotoView alloc] initWithSize:size];
	[file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
		if (data) {
			UIImage* photo = [UIImage imageWithData:data];
			[view setPhoto:photo];
		}
		else if (error) {
			NSLog(@"error %@", error);
		}
	}];
	return view;
}


@end
