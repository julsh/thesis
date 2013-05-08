//
//  SZOpenDealCell.m
//  Skillz
//
//  Created by Julia Roggatz on 05.05.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZOpenDealCell.h"
#import "SZButton.h"

@interface SZOpenDealCell ()

@property (nonatomic, strong) UIImageView* bgImage;
@property (nonatomic, strong) UIImageView* pointsIcon;
@property (nonatomic, strong) SZButton* reportButton;
@property (nonatomic, strong) SZButton* cancelButton;
@property (nonatomic, strong) SZButton* doneButton;
@property (nonatomic, strong) UILabel* userNameLabel;
@property (nonatomic, strong) UILabel* priceLabel;

@end

@implementation SZOpenDealCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
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
		
		
		// user photo
		self.userPhoto = [SZUserPhotoView emptyUserPhotoViewWithSize:SZUserPhotoViewSizeSmall];
		[self.userPhoto setFrame:CGRectMake(14.0, 14.0, self.userPhoto.frame.size.width, self.userPhoto.frame.size.height)];
		[self.contentView addSubview:self.userPhoto];
		
		//whose request or offer
		self.whoseEntryLabel = [[UILabel alloc] initWithFrame:CGRectMake(75.0, 15.0, 200.0, 15.0)];
		[self.whoseEntryLabel setBackgroundColor:[UIColor clearColor]];
		[self.whoseEntryLabel setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:13.0]];
		[self.whoseEntryLabel setTextColor:[SZGlobalConstants gray]];
		[self.whoseEntryLabel setHighlightedTextColor:[SZGlobalConstants gray]];
		[self.whoseEntryLabel applyWhiteShadow];
		[self.contentView addSubview:self.whoseEntryLabel];
		
		// request or offer title
		self.entryTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(75.0, 35.0, 200.0, 17.0)];
		[self.entryTitleLabel setBackgroundColor:[UIColor clearColor]];
		[self.entryTitleLabel setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:15.0]];
		[self.entryTitleLabel setTextColor:[SZGlobalConstants darkPetrol]];
		[self.entryTitleLabel setHighlightedTextColor:[SZGlobalConstants darkPetrol]];
		[self.entryTitleLabel applyWhiteShadow];
		[self.contentView addSubview:self.entryTitleLabel];
		
		// userName (pays your or gets paid from you)
		self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(75.0, 56.0, 200.0, 30.0)];
		[self.userNameLabel setBackgroundColor:[UIColor clearColor]];
		[self.userNameLabel setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:13.0]];
		[self.userNameLabel setTextColor:[SZGlobalConstants gray]];
		[self.userNameLabel setHighlightedTextColor:[SZGlobalConstants gray]];
		[self.userNameLabel applyWhiteShadow];
		[self.contentView addSubview:self.userNameLabel];
		
		// how much will be paid
		self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(200.0, 56.0, 200.0, 30.0)];
		[self.priceLabel setBackgroundColor:[UIColor clearColor]];
		[self.priceLabel setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:13.0]];
		[self.priceLabel setTextColor:[SZGlobalConstants gray]];
		[self.priceLabel setHighlightedTextColor:[SZGlobalConstants gray]];
		[self.priceLabel applyWhiteShadow];
		[self.contentView addSubview:self.priceLabel];
		
		self.pointsIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"skillpoints_small"]];
		[self.pointsIcon setFrame:CGRectMake(150.0, 55.0, self.pointsIcon.frame.size.width, self.pointsIcon.frame.size.height)];
		[self.contentView addSubview:self.pointsIcon];
		
		self.reportButton = [SZButton buttonWithColor:SZButtonColorOrange size:SZButtonSizeSmall width:110.0];
		[self.reportButton setTitle:@"Report a Problem" forState:UIControlStateNormal];
		
		self.cancelButton = [SZButton buttonWithColor:SZButtonColorOrange size:SZButtonSizeSmall width:80.0];
		[self.cancelButton setTitle:@"Cancel Deal" forState:UIControlStateNormal];
		
		self.doneButton = [SZButton buttonWithColor:SZButtonColorPetrol size:SZButtonSizeSmall width:95.0];
		[self.doneButton setTitle:@"Mark as Done" forState:UIControlStateNormal];
		
		CGRect frame = self.reportButton.frame;
		frame.origin.x = 13.0;
		frame.origin.y = 83.0;
		self.reportButton.frame = frame;
		
		frame = self.cancelButton.frame;
		frame.origin.x = 128.0;
		frame.origin.y = 83.0;
		self.cancelButton.frame = frame;
		
		frame = self.doneButton.frame;
		frame.origin.x = 213.0;
		frame.origin.y = 83.0;
		self.doneButton.frame = frame;
		
		[self.contentView addSubview:self.reportButton];
		[self.contentView addSubview:self.cancelButton];
		[self.contentView addSubview:self.doneButton];
		
		
		UIImageView* arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accessory_arrow"]];
		arrow.center = CGPointMake(300.0, 57.0);
		[self.contentView addSubview:arrow];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//	if (selected) [self.bgImage setHidden:YES];
//	else [self.bgImage setHidden:NO];
	
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
//    [super setHighlighted:highlighted animated:animated];
//	if (highlighted) [self.bgImage setHidden:YES];
//	else [self.bgImage setHidden:NO];
}

- (void)setDealPartnerName:(NSString*)userName dealPrice:(NSString*)dealPrice {
	
	self.userNameLabel.text = userName;
	self.priceLabel.text = dealPrice;
	
	[self.userNameLabel sizeToFit];
	[self.priceLabel sizeToFit];
	
	CGRect frame = self.pointsIcon.frame;
	frame.origin.x = self.userNameLabel.frame.origin.x + self.userNameLabel.frame.size.width + 5.0;
	self.pointsIcon.frame = frame;
	
	frame = self.priceLabel.frame;
	frame.origin.x = self.userNameLabel.frame.origin.x + self.userNameLabel.frame.size.width + 28.0;
	self.priceLabel.frame = frame;
}

@end
