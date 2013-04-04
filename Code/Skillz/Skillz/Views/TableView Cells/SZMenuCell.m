//
//  SZMenuCell.m
//  Skillz
//
//  Created by Julia Roggatz on 25.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZMenuCell.h"
#import "UILabel+Shadow.h"

@implementation SZMenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier width:(CGFloat)width height:(CGFloat)height
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView setBackgroundColor:[SZGlobalConstants menuCellColor]];
		[self.imageView setBackgroundColor:[SZGlobalConstants menuCellColor]];
		
		[self.textLabel setBackgroundColor:[UIColor clearColor]];
		[self.textLabel setFont:[SZGlobalConstants fontWithFontType:SZFontBold size:15.0]];
		[self.textLabel setTextColor:[SZGlobalConstants menuCellTextColor]];
		[self.textLabel setHighlightedTextColor:[SZGlobalConstants menuCellTextSelectedColor]];
		[self.textLabel applyBlackShadow];
		
		// Add separators
		UIView* topSeparator = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, width, 1.0)];
		[topSeparator setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.08]];
		
		UIView* bottomSeparator = [[UIView alloc] initWithFrame:CGRectMake(0.0, height - 1.0, width, 1.0)];
		[bottomSeparator setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]];
		
		[self.contentView addSubview: topSeparator];
		[self.contentView addSubview: bottomSeparator];
		
		UIView* selectedView = [[UIView alloc] initWithFrame:self.frame];
		[selectedView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3]];
		self.selectedBackgroundView = selectedView;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:NO];
}

@end
