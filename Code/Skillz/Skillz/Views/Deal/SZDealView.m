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

+ (UIView*)dealBadgeForDealType:(SZDealType)dealType {
	UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 46.0, 30.0)];
	UIImageView* bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"deal_badge"]];
	UIImageView* imgView;
	
	switch (dealType) {
		case SZDealSealed:
			imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hands_shaken_27"]];
			break;
		case SZDealOfferedFromOtherUser:
			imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hand_stretched_right_27"]];
			break;
		case SZDealOfferedToOtherUser:
			imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hand_stretched_left_27"]];
			break;
		default:
			break;
	}
	
	[imgView setCenter:CGPointMake(22.0, 15.0)];
	
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
