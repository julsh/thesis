//
//  SZTitleView.m
//  Skillz
//
//  Created by Julia Roggatz on 01.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZTitleView.h"

#define TITLE_TOP_MARGIN		 15.0
#define TITLE_CATEGORY_SPACING	  5.0
#define CATEGORY_BOTTOM_MARGIN	 15.0

@implementation SZTitleView

- (id)initWithTitle:(NSString*)title category:(NSString*)category {
	self = [super init];
	if (self) {
		
		CGFloat height = TITLE_TOP_MARGIN;
				
		UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, height, 260.0, 1000.0)];
		[titleLabel setNumberOfLines:0];
		[titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
		[titleLabel setFont:[SZGlobalConstants fontWithFontType:SZFontBold size:24.0]];
		[titleLabel setTextColor:[SZGlobalConstants darkPetrol]];
		[titleLabel applyWhiteShadow];
		[titleLabel setText:title];
		[titleLabel sizeToFit];
		
		height += titleLabel.frame.size.height;
		height += TITLE_CATEGORY_SPACING;
		
		UILabel* categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, height, 265.0, 1000.0)];
		[categoryLabel setNumberOfLines:0];
		[categoryLabel setLineBreakMode:NSLineBreakByWordWrapping];
		[categoryLabel setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:16.0]];
		[categoryLabel setTextColor:[SZGlobalConstants gray]];
		[categoryLabel applyWhiteShadow];
		[categoryLabel setText:category];
		[categoryLabel sizeToFit];
		
		height += categoryLabel.frame.size.height;
		height += CATEGORY_BOTTOM_MARGIN;
		
		UIImageView* bgImage = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"details_top"] resizableImageWithCapInsets:UIEdgeInsetsMake(10.0, 20.0, 10.0, 20.0)]];
		[bgImage setFrame:CGRectMake(0.0, 0.0, 290.0, height)];
		[self setFrame:bgImage.frame];
		
		[self addSubview:bgImage];
		[self addSubview:titleLabel];
		[self addSubview:categoryLabel];
	}
	return self;
}

@end
