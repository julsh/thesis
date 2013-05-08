//
//  SZStarsView.m
//  Skillz
//
//  Created by Julia Roggatz on 07.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZStarsView.h"
#import "SZUtils.h"

@interface SZStarsView ()

@property (nonatomic, assign) SZStarViewSize size;

@end

@implementation SZStarsView

- (id)initWithSize:(SZStarViewSize)size {
	self.size = size;
	
	CGSize viewSize;
	CGFloat spacing;
	NSString* appendix = @"";
	switch (size) {
		case SZStarViewSizeSmall:
			viewSize = CGSizeMake(50.0, 10.0);
			spacing = 10.0;
			appendix = @"_small";
			break;
		case SZStarViewSizeMedium:
			viewSize = CGSizeMake(100.0, 20.0);
			spacing = 20.0;
			break;
	}
	
	self = [super initWithFrame:CGRectMake(0.0, 0.0, viewSize.width, viewSize.height)];
	if (self) {
		
		for (int i = 0; i < 5; i++) {
			UIImageView* fullStar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"star_full%@", appendix]]];
			fullStar.tag = 10+i; // starting with 10 to make sure no other views will accidentally be accessed
			[fullStar setFrame:CGRectMake(i * spacing, 0.0, fullStar.frame.size.width, fullStar.frame.size.height)];
			[self addSubview:fullStar];
		}
		
	}
	
	return self;
}

- (void)setStarsForReviewsArray:(NSArray*)reviews {
	
	CGFloat average = [SZUtils getAverageValueOfNumberArray:reviews];
	
	NSInteger fullStars = floorf(average);
	NSInteger halfStars = 0;
	if ((average - fullStars) >= 0.25 && (average - fullStars) <= 0.75) halfStars = 1;
	else if ((average - fullStars) > 0.75) fullStars++;
	NSInteger emptyStars = 5 - fullStars - halfStars;
	
	NSString* appendix = self.size == SZStarViewSizeSmall ? @"_small" : @"";
	
	UIImage* fullStar = [UIImage imageNamed:[NSString stringWithFormat:@"star_full%@", appendix]];
	UIImage* halfStar = [UIImage imageNamed:[NSString stringWithFormat:@"star_half%@", appendix]];
	UIImage* emptyStar = [UIImage imageNamed:[NSString stringWithFormat:@"star_empty%@", appendix]];
	
	int tagPos = 10; // starting with 10 to make sure no other views will accidentally be accessed
	
	for (int i = 0; i < fullStars; i++) {
		UIImageView* star = (UIImageView*)[self viewWithTag:tagPos];
		[star setImage:fullStar];
		tagPos++;
	}
	for (int i = 0; i < halfStars; i++) {
		UIImageView* star = (UIImageView*)[self viewWithTag:tagPos];
		[star setImage:halfStar];
		tagPos++;
	}
	for (int i = 0; i < emptyStars; i++) {
		UIImageView* star = (UIImageView*)[self viewWithTag:tagPos];
		[star setImage:emptyStar];
		tagPos++;
	}
	
}

@end
