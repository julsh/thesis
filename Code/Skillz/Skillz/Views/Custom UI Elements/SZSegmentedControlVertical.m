//
//  SZSegmentedControlVertical.m
//  Skillz
//
//  Created by Julia Roggatz on 25.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZSegmentedControlVertical.h"
#import "SZUtils.h"

//#define SEGMENT_HEIGHT 37.0

@interface SZSegmentedControlVertical ()

@property (nonatomic, assign) NSInteger segmentCount;

@end

@implementation SZSegmentedControlVertical

@synthesize segmentCount = _segmentCount;
@synthesize selectedIndex = _selectedIndex;

- (id)initWithWidth:(CGFloat)width
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
		self.segmentCount = 0;
		self.selectedIndex = -1;
        CGRect frame = self.frame;
		frame.size.width = width;
		self.frame = frame;
    }
    return self;
}

- (void)addItemWithText:(NSString*)text isLast:(BOOL)isLast {
	
	UIImage* bgImage;
	UIImage* selectedImage;
	
	if (self.segmentCount == 0) { // top item
		bgImage = [[UIImage imageNamed:@"segmented_control_top"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 25.0, 0.0, 25.0)];
		selectedImage = [[UIImage imageNamed:@"segmented_control_top_selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 25.0, 0.0, 25.0)];
	}
	else {
		if (!isLast) {  // middle item
			bgImage = [[UIImage imageNamed:@"segmented_control_middle"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 25.0, 0.0, 25.0)];
			selectedImage = [[UIImage imageNamed:@"segmented_control_middle_selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 25.0, 0.0, 25.0)];
		}
		else {  // bottom item
			bgImage = [[UIImage imageNamed:@"segmented_control_bottom"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 25.0, 0.0, 25.0)];
			selectedImage = [[UIImage imageNamed:@"segmented_control_bottom_selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 25.0, 0.0, 25.0)];
		}
	}

	UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
	[button setTag:self.segmentCount];
	
	CGFloat segmentHeight;
	if (self.segmentCount == 0) {
		segmentHeight = 39.0;
	}
	else {
		if (isLast) {
			segmentHeight = 40.0;
		}
		else {
			segmentHeight = 37.0;
		}
	}
	
	CGRect frame = button.frame;
	frame.origin.y = self.frame.size.height;
	if (isLast && self.segmentCount == 1) frame.origin.y -= 1.0;	// fixes case where 2-segment control separator line appears too thick
	frame.size.width = self.frame.size.width;
	frame.size.height = segmentHeight;
	button.frame = frame;
	
	frame = self.frame;
	frame.size.height += button.frame.size.height;
	self.frame = frame;
	
	[button setBackgroundImage:bgImage forState:UIControlStateNormal];
	[button setBackgroundImage:selectedImage forState:UIControlStateHighlighted];
	[button setBackgroundImage:selectedImage forState:UIControlStateDisabled];
	
	[button setTitle:text forState:UIControlStateNormal];
	[button.titleLabel setTextAlignment:NSTextAlignmentLeft];
	[button.titleLabel setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:15.0]];
	[button.titleLabel setShadowOffset:CGSizeMake(0.0, 1.0)];
	[button setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[button setTitleColor:[SZGlobalConstants gray] forState:UIControlStateNormal];
	
	NSShadow* shadow = [[NSShadow alloc] init];
	[shadow setShadowOffset:CGSizeMake(0.0, -1.0)];
	[shadow setShadowColor:[UIColor blackColor]];
	
	NSDictionary *attributtes = @{NSShadowAttributeName : shadow,
							   NSForegroundColorAttributeName : [UIColor whiteColor]};
	[button setAttributedTitle:[[NSAttributedString alloc] initWithString:text attributes:attributtes] forState:UIControlStateDisabled];
	[button setAttributedTitle:[[NSAttributedString alloc] initWithString:text attributes:attributtes] forState:UIControlStateHighlighted];

	[button addTarget:self action:@selector(segmentTapped:) forControlEvents:UIControlEventTouchDown];
	[self addSubview:button];
	
	self.segmentCount++;
}

- (void)segmentTapped:(id)sender {
	UIButton* button = (UIButton*)sender;
	[button setHighlighted:YES];
	[self selectItemWithIndex:button.tag];
}

- (void)selectItemWithIndex:(NSInteger)index {
	self.selectedIndex = index;
	for (UIButton* button in [self subviews]) {
		if (button.tag != index) {
			[button setEnabled:YES];
		}
		else {
			[button setEnabled:NO];
		}
	}
	
	if (self.delegate && [self.delegate respondsToSelector:@selector(segmentedControlVertical:didSelectItemAtIndex:)]) {
		[self.delegate segmentedControlVertical:self didSelectItemAtIndex:self.selectedIndex];
	}
}

@end
