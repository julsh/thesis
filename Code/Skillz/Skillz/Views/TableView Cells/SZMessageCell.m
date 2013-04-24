//
//  SZMessageCell.m
//  Skillz
//
//  Created by Julia Roggatz on 21.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZMessageCell.h"

@interface SZMessageCell ()

@property (nonatomic, strong) UIImageView* bgImage;

@end

@implementation SZMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
		// regular background
		[self.contentView setBackgroundColor:[UIColor clearColor]];
		self.bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(4.0, 4.0, 312.0, 100.0)];
		[self.bgImage setImage:[[UIImage imageNamed:@"message_cell"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 20.0, 0.0, 20.0)]];
		[self.contentView addSubview:self.bgImage];
		
		// seleted background
		UIView* bgView = [[UIView alloc] initWithFrame:self.bounds];
		UIImageView* selectedBgImage = [[UIImageView alloc] initWithFrame:CGRectMake(4.0, 4.0, 312.0, 100.0)];
		[selectedBgImage setImage:[[UIImage imageNamed:@"message_cell_selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 20.0, 0.0, 20.0)]];
		[bgView addSubview:selectedBgImage];
		[self setSelectedBackgroundView:bgView];
		
		// user photo
		self.userPhoto = [SZUserPhotoView emptyUserPhotoWithSize:SZUserPhotoViewSizeMedium];
		[self.userPhoto setFrame:CGRectMake(14.0, 14.0, self.userPhoto.frame.size.width, self.userPhoto.frame.size.height)];
		[self.contentView addSubview:self.userPhoto];
		
		// user name
		self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(105.0, 19.0, 200.0, 18.0)];
		[self.userNameLabel setBackgroundColor:[UIColor clearColor]];
		[self.userNameLabel setFont:[SZGlobalConstants fontWithFontType:SZFontBold size:14.0]];
		[self.userNameLabel setTextColor:[SZGlobalConstants darkPetrol]];
		[self.userNameLabel setHighlightedTextColor:[SZGlobalConstants darkPetrol]];
		[self.userNameLabel applyWhiteShadow];
		[self.contentView addSubview:self.userNameLabel];
		
		// time ago
		self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(105.0, 40.0, 200.0, 15.0)];
		[self.timeLabel setBackgroundColor:[UIColor clearColor]];
		[self.timeLabel setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBoldItalic size:11.0]];
		[self.timeLabel setTextColor:[SZGlobalConstants gray]];
		[self.timeLabel setHighlightedTextColor:[SZGlobalConstants gray]];
		[self.timeLabel applyWhiteShadow];
		[self.contentView addSubview:self.timeLabel];
		
		// message
		self.messageTeaserLabel = [[UILabel alloc] initWithFrame:CGRectMake(105.0, 60.0, 190.0, 40.0)];
		[self.messageTeaserLabel setBackgroundColor:[UIColor clearColor]];
		[self.messageTeaserLabel setNumberOfLines:2];
		[self.messageTeaserLabel setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:12.0]];
		[self.messageTeaserLabel setTextColor:[SZGlobalConstants gray]];
		[self.messageTeaserLabel setHighlightedTextColor:[SZGlobalConstants gray]];
		[self.messageTeaserLabel applyWhiteShadow];
		[self.contentView addSubview:self.messageTeaserLabel];
		
		UIImageView* accessoryArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accessory_arrow"]];
		[accessoryArrow setFrame:CGRectMake(290.0, 44.0, accessoryArrow.frame.size.width, accessoryArrow.frame.size.height)];
		[self.contentView addSubview:accessoryArrow];
		
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
	if (selected) [self.bgImage setHidden:YES];
	else [self.bgImage setHidden:NO];
	
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
	if (highlighted) [self.bgImage setHidden:YES];
	else [self.bgImage setHidden:NO];
}

@end
