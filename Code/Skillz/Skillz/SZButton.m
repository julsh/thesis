//
//  SZButton.m
//  Skillz
//
//  Created by Julia Roggatz on 21.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZButton.h"
#import "SZUtils.h"

@implementation SZButton

- (id)initWithColor:(SZButtonColor)color size:(SZButtonSize)size width:(CGFloat)width {
	
	NSString* prefix;
	switch (color) {
		case SZButtonColorPetrol:
			prefix = @"button_petrol";
			break;
		case SZButtonColorOrange:
			prefix = @"button_orange";
		default:
			break;
	}
	
	NSString* suffix;
	CGFloat height = 0.0;
	CGFloat fontSize = 0.0;
	switch (size) {
		case SZButtonSizeExtraLarge:
			suffix = @"_extra_large";
			height = 52.0;
			fontSize = 18.0;
			break;
		case SZButtonSizeLarge:
			suffix = @"_large";
			height = 40.0;
			fontSize = 18.0;
			break;
		case SZButtonSizeMedium:
			suffix = @"_medium";
			height = 32.0;
			fontSize = 14.0;
			break;
		case SZButtonSizeSmall:
			suffix = @"_small";
			height = 24.0;
			fontSize = 10.0;
			break;
		default:
			break;
	}
	
	UIImage* bgImage = [[UIImage imageNamed:[NSString stringWithFormat:@"%@%@", prefix, suffix]] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 30.0, 0.0, 30.0)];
	UIImage* selectedImage = [[UIImage imageNamed:[NSString stringWithFormat:@"%@%@%@", prefix, suffix, @"_down"]] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 30.0, 0.0, 30.0)];;
	
	self = [super initWithFrame:CGRectMake(0.0, 0.0, width, height)];
    if (self) {
        [self setBackgroundImage:bgImage forState:UIControlStateNormal];
		[self setBackgroundImage:selectedImage forState:UIControlStateHighlighted];
		
		[self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[self setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.8] forState:UIControlStateHighlighted];
		[self.titleLabel setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:fontSize]];
		[self.titleLabel setShadowColor:[UIColor blackColor]];
		[self.titleLabel setShadowOffset:CGSizeMake(0.0, -1.0)];
    }
    return self;
}

- (void)setMultilineTitle:(NSString*)title font:(UIFont*)font lineSpacing:(CGFloat)lineSpacing {
	
	[self.titleLabel setFont:font];
	[self.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
	NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
	[paragraphStyle setLineSpacing:lineSpacing];
	[paragraphStyle setMaximumLineHeight:font.capHeight+font.xHeight];
	[paragraphStyle setAlignment:NSTextAlignmentCenter];
	
	NSDictionary *attributtes = @{NSParagraphStyleAttributeName : paragraphStyle,
								 NSForegroundColorAttributeName : [UIColor whiteColor]};
	[self setAttributedTitle:[[NSAttributedString alloc] initWithString:title attributes:attributtes] forState:UIControlStateNormal];

}

// override to fix vertical label position for multiline labels
- (void)setNeedsLayout {
	[super setNeedsLayout];
	if (self.titleLabel.lineBreakMode == NSLineBreakByWordWrapping) {
		CGRect frame = self.titleLabel.frame;
		frame.origin.y += 2.5;
		self.titleLabel.frame = frame;
	}
}

@end
