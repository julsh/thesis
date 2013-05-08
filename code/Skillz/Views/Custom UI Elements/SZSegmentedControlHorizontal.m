//
//  SZSegmentedControlHorizontal.m
//  Skillz
//
//  Created by Julia Roggatz on 20.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZSegmentedControlHorizontal.h"

@implementation SZSegmentedControlHorizontal

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundImage:[[UIImage imageNamed:@"segmented_control_deselected"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 25.0, 0.0, 25.0)]
									  forState:UIControlStateNormal
									barMetrics:UIBarMetricsDefault];
		
		[self setBackgroundImage:[[UIImage imageNamed:@"segmented_control_selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 25.0, 0.0, 25.0)]
									  forState:UIControlStateSelected
									barMetrics:UIBarMetricsDefault];
		
		[self setDividerImage:[UIImage imageNamed:@"segmented_control_left_selected"]
						forLeftSegmentState:UIControlStateSelected
						  rightSegmentState:UIControlStateNormal
								 barMetrics:UIBarMetricsDefault];
		[self setDividerImage:[UIImage imageNamed:@"segmented_control_right_selected"]
						forLeftSegmentState:UIControlStateNormal
						  rightSegmentState:UIControlStateSelected
								 barMetrics:UIBarMetricsDefault];
		
		[self setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
													[SZGlobalConstants gray], UITextAttributeTextColor,
													[UIColor whiteColor], UITextAttributeTextShadowColor,
													[NSValue valueWithUIOffset:UIOffsetMake(0.0, 1.0)], UITextAttributeTextShadowOffset,
													[SZGlobalConstants fontWithFontType:SZFontBold size:18.0], UITextAttributeFont, nil]
										  forState:UIControlStateNormal];
		
		[self setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
													[UIColor whiteColor], UITextAttributeTextColor,
													[UIColor blackColor], UITextAttributeTextShadowColor,
													[NSValue valueWithUIOffset:UIOffsetMake(0.0, -1.0)], UITextAttributeTextShadowOffset,
													[SZGlobalConstants fontWithFontType:SZFontBold size:18.0], UITextAttributeFont, nil]
										  forState:UIControlStateSelected];
    }
    return self;
}

- (void)setFontSize:(CGFloat)fontSize {
	
	[self setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
								  [SZGlobalConstants gray], UITextAttributeTextColor,
								  [UIColor whiteColor], UITextAttributeTextShadowColor,
								  [NSValue valueWithUIOffset:UIOffsetMake(0.0, 1.0)], UITextAttributeTextShadowOffset,
								  [SZGlobalConstants fontWithFontType:SZFontBold size:fontSize], UITextAttributeFont, nil]
						forState:UIControlStateNormal];
	
	[self setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
								  [UIColor whiteColor], UITextAttributeTextColor,
								  [UIColor blackColor], UITextAttributeTextShadowColor,
								  [NSValue valueWithUIOffset:UIOffsetMake(0.0, -1.0)], UITextAttributeTextShadowOffset,
								  [SZGlobalConstants fontWithFontType:SZFontBold size:fontSize], UITextAttributeFont, nil]
						forState:UIControlStateSelected];
}


@end
