//
//  SZEntryCell.m
//  Skillz
//
//  Created by Julia Roggatz on 02.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZEntryCell.h"

@interface SZEntryCell ()

@property (nonatomic, strong) UIImageView* bgImage;
@property (nonatomic, strong) UIImageView* selectedBgImage;

@end

@implementation SZEntryCell

@synthesize activeSwitch = _activeSwitch;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		[self.contentView setBackgroundColor:[UIColor clearColor]];
		
		self.bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(4.0, 2.0, 312.0, 60.0)];
		[self.bgImage setImage:[[UIImage imageNamed:@"entry_cell"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 20.0, 0.0, 20.0)]];
		[self.contentView addSubview:self.bgImage];
		
		self.selectedBgImage = [[UIImageView alloc] initWithFrame:CGRectMake(4.0, 2.0, 312.0, 60.0)];
		[self.selectedBgImage setImage:[[UIImage imageNamed:@"entry_cell_selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 20.0, 0.0, 20.0)]];
		[self.contentView addSubview:self.selectedBgImage];
		
		[self.textLabel setBackgroundColor:[UIColor clearColor]];
		[self.textLabel setLineBreakMode:NSLineBreakByTruncatingTail];
		[self.textLabel setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:16.0]];
		[self.textLabel setTextColor:[SZGlobalConstants darkPetrol]];
		[self.textLabel applyWhiteShadow];
		
		[self.detailTextLabel setBackgroundColor:[UIColor clearColor]];
		[self.detailTextLabel setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:13.0]];
		[self.detailTextLabel setTextColor:[SZGlobalConstants gray]];
		[self.detailTextLabel applyWhiteShadow];
		
		if ([reuseIdentifier isEqualToString:@"myRequestCell"]) {
			[self.contentView addSubview:self.activeSwitch];
		}
		
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
	
	if (selected) {
		[UIView animateWithDuration:0.1 animations:^{
			[self.selectedBgImage setHidden:NO];
			[self.bgImage setHidden:YES];
		}];
	}
	else {
		[UIView animateWithDuration:0.1 animations:^{
			[self.selectedBgImage setHidden:YES];
			[self.bgImage setHidden:NO];
		}];
	}

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
