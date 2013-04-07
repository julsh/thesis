//
//  SZSearchResultCell.m
//  Skillz
//
//  Created by Julia Roggatz on 05.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZSearchResultCell.h"
#import "UILabel+Shadow.h"

#define TITLE_CATEGORY_SPACING 8.0

@interface SZSearchResultCell ()

@property (nonatomic, strong) UIImageView* bgImage;

@end

@implementation SZSearchResultCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		
		// regular background
		[self.contentView setBackgroundColor:[UIColor clearColor]];
		self.bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(4.0, 4.0, 312.0, 110.0)];
			[self.bgImage setImage:[[UIImage imageNamed:@"result_cell"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 20.0, 0.0, 20.0)]];
		[self.contentView addSubview:self.bgImage];
			
		// seleted background
		UIView* bgView = [[UIView alloc] initWithFrame:self.bounds];
		UIImageView* selectedBgImage = [[UIImageView alloc] initWithFrame:CGRectMake(4.0, 4.0, 312.0, 110.0)];
		[selectedBgImage setImage:[[UIImage imageNamed:@"result_cell_selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 20.0, 0.0, 20.0)]];
		[bgView addSubview:selectedBgImage];
		[self setSelectedBackgroundView:bgView];
		
		// title
		self.userName = [[UILabel alloc] initWithFrame:CGRectMake(238.0, 14.0, 65.0, 15.0)];
		[self.userName setBackgroundColor:[UIColor clearColor]];
		[self.userName setNumberOfLines:1];
		[self.userName setMinimumScaleFactor:0.8];
		[self.userName setAdjustsFontSizeToFitWidth:YES];
		[self.userName setTextAlignment:NSTextAlignmentRight];
		[self.userName setLineBreakMode:NSLineBreakByTruncatingTail];
		[self.userName setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:12.0]];
		[self.userName setTextColor:[SZGlobalConstants darkPetrol]];
		[self.userName setHighlightedTextColor:[SZGlobalConstants darkPetrol]];
		[self.userName applyWhiteShadow];
		[self.contentView addSubview:self.userName];
		
		// user photo
		self.userPhoto = [SZUserPhotoView emptyUserPhotoWithSize:SZUserPhotoViewSizeSmall];
		[self.userPhoto setFrame:CGRectMake(250.0, 31.0, self.userPhoto.frame.size.width, self.userPhoto.frame.size.height)];
		[self.contentView addSubview:self.userPhoto];
		
		// stars view
		self.starsView = [[SZStarsView alloc] initWithSize:SZStarViewSizeSmall];
		[self.starsView setFrame:CGRectMake(252.0, 92.0, self.starsView.frame.size.width, self.starsView.frame.size.height)];
		[self.contentView addSubview:self.starsView];
		
		// title
		self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 12.0, 220.0, 50.0)];
		[self.titleLabel setBackgroundColor:[UIColor clearColor]];
		[self.titleLabel setNumberOfLines:0];
		[self.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
		[self.titleLabel setFont:[SZGlobalConstants fontWithFontType:SZFontBold size:16.0]];
		[self.titleLabel setTextColor:[SZGlobalConstants darkPetrol]];
		[self.titleLabel setHighlightedTextColor:[SZGlobalConstants darkPetrol]];
		[self.titleLabel applyWhiteShadow];
		[self.contentView addSubview:self.titleLabel];
		
		// cateogry
		self.categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(15.0, 65.0, 220.0, 15.0)];
		[self.categoryLabel setBackgroundColor:[UIColor clearColor]];
		[self.categoryLabel setNumberOfLines:1];
		[self.categoryLabel setLineBreakMode:NSLineBreakByTruncatingTail];
		[self.categoryLabel setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:13.0]];
		[self.categoryLabel setTextColor:[SZGlobalConstants gray]];
		[self.categoryLabel setHighlightedTextColor:[SZGlobalConstants gray]];
		[self.categoryLabel applyWhiteShadow];
		[self.contentView addSubview:self.categoryLabel];
		
		// points view
		UIImageView* pointsIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"skillpoints_small"]];
		[pointsIcon setFrame:CGRectMake(15.0, 85.0, pointsIcon.frame.size.width, pointsIcon.frame.size.height)];
		[self.contentView addSubview:pointsIcon];
		
		self.pointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(42.0, 88.0, 90.0, 17.0)];
		[self.pointsLabel setBackgroundColor:[UIColor clearColor]];
		[self.pointsLabel setNumberOfLines:1];
		[self.pointsLabel setLineBreakMode:NSLineBreakByTruncatingTail];
		[self.pointsLabel setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:14.0]];
		[self.pointsLabel setTextColor:[SZGlobalConstants darkPetrol]];
		[self.pointsLabel setHighlightedTextColor:[SZGlobalConstants darkPetrol]];
		[self.pointsLabel applyWhiteShadow];
		[self.contentView addSubview:self.pointsLabel];
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

- (void)layoutSubviews {
	
	[super layoutSubviews];
	
	NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
	[paragraphStyle setLineSpacing:-4.0];
	NSDictionary *attributtes = @{NSParagraphStyleAttributeName : paragraphStyle};
	[self.titleLabel setAttributedText:[[NSAttributedString alloc] initWithString:self.titleLabel.text attributes:attributtes]];
}

@end
