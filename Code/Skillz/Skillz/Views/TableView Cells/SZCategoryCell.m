//
//  SZCategoryCell.m
//  Skillz
//
//  Created by Julia Roggatz on 05.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZCategoryCell.h"
#import "UILabel+Shadow.h"

@implementation SZCategoryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		
		[self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
		
		UIView* bgView = [[UIView alloc] initWithFrame:self.bounds];
		[bgView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.5]];
		UIView* highlightView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, 1.0)];
		[highlightView setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.9]];
		UIView* separatorView = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.frame.size.height - 1.0, self.frame.size.width, 1.0)];
		[separatorView setBackgroundColor:[SZGlobalConstants lightGray]];
		[bgView addSubview:highlightView];
		[bgView addSubview:separatorView];
		
		UIView* selectedView = [[UIView alloc] initWithFrame:self.bounds];
		[selectedView setBackgroundColor:[SZGlobalConstants darkPetrol]];
		UIView* lowlightView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, 1.0)];
		[lowlightView setBackgroundColor:[UIColor blackColor]];
		[selectedView addSubview:lowlightView];
		
		[self setSelectedBackgroundView:selectedView];
		
		[self.contentView addSubview:bgView];
		
		[self.textLabel setBackgroundColor:[UIColor clearColor]];
		[self.textLabel setLineBreakMode:NSLineBreakByTruncatingTail];
		[self.textLabel setFont:[SZGlobalConstants fontWithFontType:SZFontBold size:16.0]];
		[self.textLabel setTextColor:[SZGlobalConstants darkPetrol]];
		if (self.selected) [self.textLabel applyWhiteShadow];
		else [self.textLabel applyBlackShadow];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
	
	[super setHighlighted:highlighted animated:animated];
	
    if (highlighted) {
		[self.textLabel applyBlackShadow];
	}
	else {
		[self.textLabel applyWhiteShadow];
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    if (selected) {
		[self.textLabel applyBlackShadow];
	}
	else {
		[self.textLabel applyWhiteShadow];
	}
}

@end
