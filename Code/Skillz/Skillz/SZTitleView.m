//
//  SZTitleView.m
//  Skillz
//
//  Created by Julia Roggatz on 01.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZTitleView.h"

#define TITLE_TOP_MARGIN		 5.0
#define TITLE_CATEGORY_SPACING	 5.0
#define CATEGORY_BOTTOM_MARGIN	10.0

@implementation SZTitleView

- (id)initWithTitle:(NSString*)title category:(NSString*)category {
	self = [super init];
	if (self) {
		
		CGSize titleSize = [title sizeWithFont:[SZGlobalConstants fontWithFontType:SZFontBold size:28.0] constrainedToSize:CGSizeMake(265.0, 1000.0)];
		CGSize categorySize = [category sizeWithFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:16.0] constrainedToSize:CGSizeMake(260.0, 1000.0)];
		
		CGFloat sectionHeight = TITLE_TOP_MARGIN + titleSize.height + TITLE_CATEGORY_SPACING + categorySize.height + CATEGORY_BOTTOM_MARGIN;
		
		UIImageView* bgImage = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"details_top"] resizableImageWithCapInsets:UIEdgeInsetsMake(10.0, 20.0, 10.0, 20.0)]];
		[bgImage setFrame:CGRectMake(0.0, 0.0, 290.0, sectionHeight)];
		[self setFrame:bgImage.frame];
		
		UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, TITLE_TOP_MARGIN, 260.0, titleSize.height)];
		[titleLabel setNumberOfLines:0];
		[titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
		[titleLabel setFont:[SZGlobalConstants fontWithFontType:SZFontBold size:24.0]];
		[titleLabel setTextColor:[SZGlobalConstants darkPetrol]];
		[titleLabel applyWhiteShadow];
		[titleLabel setText:title];
		
		UILabel* categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, TITLE_TOP_MARGIN + titleSize.height + TITLE_CATEGORY_SPACING, 265.0, categorySize.height)];
		[categoryLabel setNumberOfLines:0];
		[categoryLabel setLineBreakMode:NSLineBreakByWordWrapping];
		[categoryLabel setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:16.0]];
		[categoryLabel setTextColor:[SZGlobalConstants darkGray]];
		[categoryLabel applyWhiteShadow];
		[categoryLabel setText:category];
		
		[self addSubview:bgImage];
		[self addSubview:titleLabel];
		[self addSubview:categoryLabel];
	}
	return self;
}

@end
