//
//  SZTimeFrameView.m
//  Skillz
//
//  Created by Julia Roggatz on 01.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZTimeFrameView.h"
#import "SZUtils.h"

@implementation SZTimeFrameView

- (id)initWithStartDate:(NSDate*)startDate endDate:(NSDate*)endDate {
	
	self = [super initWithFrame:CGRectZero];
	if (self) {
		[self setClipsToBounds:NO];
		
		
		NSString* timeString;
		NSInteger numLines = 1;
		if (startDate != nil && endDate != nil) {
			timeString = [NSString stringWithFormat:@"from %@\nto %@", [SZUtils formattedDateFromDate:startDate], [SZUtils formattedDateFromDate:endDate]];
			numLines = 2;
		}
		else if (startDate != nil && endDate == nil) {
			timeString = [NSString stringWithFormat:@"from %@", [SZUtils formattedDateFromDate:startDate]];
		}
		else if (startDate == nil && endDate != nil) {
			timeString = [NSString stringWithFormat:@"expires %@", [SZUtils formattedDateFromDate:endDate]];
		}
		
		UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 5.0, 290.0, numLines*20.0)];
		[label setTextAlignment:NSTextAlignmentCenter];
		[label setBackgroundColor:[UIColor clearColor]];
		[label setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:15.0]];
		[label setTextColor:[UIColor whiteColor]];
		[label applyBlackShadow];
		if (numLines > 1) {
			[label setLineBreakMode:NSLineBreakByWordWrapping];
			[label setNumberOfLines:numLines];
		}
		[label setText:timeString];
		
		UIView* bgView = [[UIView alloc] initWithFrame:CGRectMake(-5.0, 0.0, 300.0, 10.0 + label.frame.size.height)];
		[bgView setBackgroundColor:[SZGlobalConstants darkPetrol]];
		[self addSubview:bgView];
		
		UIImageView* leftEdge = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"edge_left"]];
		UIImageView* rightEdge = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"edge_right"]];
		[leftEdge setFrame:CGRectMake(-5.0, -5.0, 5.0, 5.0)];
		[rightEdge setFrame:CGRectMake(290.0, -5.0, 5.0, 5.0)];
		
		[self addSubview:leftEdge];
		[self addSubview:rightEdge];
		
		[self addSubview:label];
		
		[self setFrame:CGRectMake(0.0, 0.0, 270.0, 10.0 + label.frame.size.height)];
		
	}
	
	return self;
	
}

@end
