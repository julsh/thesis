//
//  SZEntryCell.m
//  Skillz
//
//  Created by Julia Roggatz on 02.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZEntryCell.h"
#import "UILabel+Shadow.h"

@interface SZEntryCell ()

@property (nonatomic, strong) UIImageView* bgImage;

@end

@implementation SZEntryCell

@synthesize activeSwitch = _activeSwitch;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		
		[self.contentView setBackgroundColor:[UIColor clearColor]];
		
		self.bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(4.0, 4.0, 312.0, 60.0)];
		[self.bgImage setImage:[[UIImage imageNamed:@"entry_cell"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 20.0, 0.0, 20.0)]];
		[self.contentView addSubview:self.bgImage];
		[self.contentView addSubview:self.activeSwitch];
	
		
		UIView* bgView = [[UIView alloc] initWithFrame:self.bounds];
		UIImageView* selectedBgImage = [[UIImageView alloc] initWithFrame:CGRectMake(4.0, 4.0, 312.0, 60.0)];
		[selectedBgImage setImage:[[UIImage imageNamed:@"entry_cell_selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 20.0, 0.0, 20.0)]];
		[bgView addSubview:selectedBgImage];
		[self setSelectedBackgroundView:bgView];
		
		[self.textLabel setBackgroundColor:[UIColor clearColor]];
		[self.textLabel setLineBreakMode:NSLineBreakByTruncatingTail];
		[self.textLabel setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:16.0]];
		[self.textLabel setTextColor:[SZGlobalConstants darkPetrol]];
		[self.textLabel setHighlightedTextColor:[SZGlobalConstants darkPetrol]];
		[self.textLabel applyWhiteShadow];
		
		[self.detailTextLabel setBackgroundColor:[UIColor clearColor]];
		[self.detailTextLabel setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:13.0]];
		[self.detailTextLabel setTextColor:[SZGlobalConstants gray]];
		[self.detailTextLabel setHighlightedTextColor:[SZGlobalConstants gray]];
		[self.detailTextLabel applyWhiteShadow];
		
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
	if (selected) [self.bgImage setHidden:YES];
	else [self.bgImage setHidden:NO];

}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
	if (highlighted) [self.bgImage setHidden:YES];
	else [self.bgImage setHidden:NO];
}

- (void)layoutSubviews {
	
	[super layoutSubviews];
	
	CGRect frame;
	frame = self.textLabel.frame;
	frame.origin.x = 15.0;
	frame.size.width = 210.0;
	self.textLabel.frame = frame;
	
	frame = self.detailTextLabel.frame;
	frame.origin.x = 15.0;
	frame.size.width = 210.0;
	self.detailTextLabel.frame = frame;
	
}

- (UISwitch*)activeSwitch {
	if (_activeSwitch == nil) {
		_activeSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(228.0, 20.0, 40.0, 40.0)];
		[_activeSwitch setOnTintColor:[SZGlobalConstants orange]];
	}
	return _activeSwitch;
}

@end
