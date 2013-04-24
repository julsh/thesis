//
//  SZDeal.m
//  Skillz
//
//  Created by Julia Roggatz on 21.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZDealView.h"

@implementation SZDealView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (UIView*)dealBadgeForDealAccepted:(BOOL)accepted {
	UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 72.0, 47.0)];
	UIImageView* bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"deal_badge"]];
	UIImageView* imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:accepted ? @"hands_shaken_27" : @"hand_stretched_27"]];
	
	if (accepted) {
		[imgView setCenter:CGPointMake(35.0, 17.0)];
		UILabel* acceptedLabel = [[UILabel alloc] initWithFrame:CGRectMake(4.0, 32.0, 62.0, 14.0)];
		[acceptedLabel setTextColor:[UIColor whiteColor]];
		[acceptedLabel setFont:[SZGlobalConstants fontWithFontType:SZFontBold size:10.0]];
		[acceptedLabel applyBlackShadow];
		[acceptedLabel setTextAlignment:NSTextAlignmentCenter];
		[acceptedLabel setText:@"Deal Sealed"];
		[bgView addSubview:acceptedLabel];
	}
	else {
		[imgView setCenter:CGPointMake(48.0, 17.0)];
		UILabel* proposedLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 15.0, 62.0, 28.0)];
		[proposedLabel setTextColor:[UIColor whiteColor]];
		[proposedLabel setFont:[SZGlobalConstants fontWithFontType:SZFontBold size:10.0]];
		[proposedLabel applyBlackShadow];
		[proposedLabel setNumberOfLines:0];
		[proposedLabel setText:@"Deal\nProposed"];
		[bgView addSubview:proposedLabel];
	}
	
	[view addSubview:bgView];
	[view addSubview:imgView];
	
	return view;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
