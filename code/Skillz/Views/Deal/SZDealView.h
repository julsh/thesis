//
//  SZDeal.h
//  Skillz
//
//  Created by Julia Roggatz on 21.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	SZDealOfferedToOtherUser,
	SZDealOfferedFromOtherUser,
	SZDealSealed
} SZDealType;

@interface SZDealView : UIView

+ (UIView*)dealBadgeForDealType:(SZDealType)dealType;

@end
