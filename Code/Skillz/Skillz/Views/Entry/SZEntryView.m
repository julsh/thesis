//
//  SZEntryView.m
//  Skillz
//
//  Created by Julia Roggatz on 31.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZEntryView.h"
#import "UILabel+Shadow.h"
#import "SZTitleView.h"
#import "SZTimeFrameView.h"
#import "SZUserAreaView.h"
#import "SZDescriptionView.h"
#import "SZUtils.h"
#import "SZDataManager.h"
#import "SZButton.h"

@interface SZEntryView ()

@property (nonatomic, strong) SZTitleView* titleSection;
@property (nonatomic, strong) SZTimeFrameView* timeFrameSection;
@property (nonatomic, strong) SZUserAreaView* userSection;
@property (nonatomic, strong) SZDescriptionView* descriptionSection;
@property (nonatomic, strong) UIView* footerView;
@property (nonatomic, strong) UIView* priceView;
@property (nonatomic, strong) UIView* locationView;

@property (nonatomic, assign) CGFloat contentHeight;

@end

@implementation SZEntryView

@synthesize entry = _entry;
@synthesize titleSection = _titleSection;
@synthesize timeFrameSection = _timeFrameSection;
@synthesize userSection = _userSection;
@synthesize descriptionSection = _descriptionSection;
@synthesize footerView = _footerView;
@synthesize priceView = _priceView;
@synthesize contentHeight = _contentHeight;

- (id)initWithEntry:(SZEntryVO*)entry
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.entry = entry;
		[self addSubview:self.titleSection];
		if (self.entry.hasTimeFrame) [self addSubview:[self timeFrameSection]];
		[self addSubview:self.userSection];
		[self addSubview:self.descriptionSection];
		[self addSubview:self.footerView];
		[self.footerView addSubview:self.priceView];
		[self.footerView addSubview:self.locationView];
		
		[self setFrame:CGRectMake(0.0, 0.0, 320.0, self.contentHeight)];
    }
    return self;
}

- (SZTitleView*)titleSection {
	
	if (_titleSection == nil) {
		NSString* categoriesString = self.entry.category;
		if (self.entry.subcategory != nil) {
			categoriesString = [categoriesString stringByAppendingFormat:@" > %@", self.entry.subcategory];
		}
		
		_titleSection = [[SZTitleView alloc] initWithTitle:self.entry.title category:categoriesString];
		
		self.contentHeight += _titleSection.frame.size.height;
	}
	
	return _titleSection;
}

- (SZTimeFrameView*)timeFrameSection {
	if (_timeFrameSection == nil) {
		_timeFrameSection = [[SZTimeFrameView alloc] initWithStartDate:self.entry.startTime endDate:self.entry.endTime];
		[_timeFrameSection setFrame:CGRectMake(10.0, self.contentHeight, _timeFrameSection.frame.size.width, _timeFrameSection.frame.size.height)];
		
		self.contentHeight += _timeFrameSection.frame.size.height;
	}
	
	return _timeFrameSection;
}

- (SZUserAreaView*)userSection {
	if (_userSection == nil) {
		_userSection = [[SZUserAreaView alloc] initWithUser:nil hasTimeFrameView:self.entry.hasTimeFrame];
		[_userSection setFrame:CGRectMake(0.0, self.contentHeight, _userSection.frame.size.width, _userSection.frame.size.height)];
		
		self.contentHeight += _userSection.frame.size.height;
	}
	return _userSection;
}

- (SZDescriptionView*)descriptionSection {
	if (_descriptionSection == nil) {
		_descriptionSection = [[SZDescriptionView alloc] initWithDescription:self.entry.description];
		[_descriptionSection setFrame:CGRectMake(0.0, self.contentHeight, _descriptionSection.frame.size.width, _descriptionSection.frame.size.height)];
		
		self.contentHeight += _descriptionSection.frame.size.height;
	}
	return _descriptionSection;
}

- (UIView*)footerView {
	if (_footerView == nil) {
		_footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.contentHeight, 290.0, 85.0)];
		UIImageView* bgImage = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"details_bottom"] resizableImageWithCapInsets:UIEdgeInsetsMake(10.0, 20.0, 10.0, 20.0)]];
		[bgImage setFrame:_footerView.bounds];
		[_footerView addSubview:bgImage];
		
		UIView* separatorView = [SZUtils separatorViewWithHeight:_footerView.frame.size.height - 2.0];
		[separatorView setFrame:CGRectMake(self.priceView.frame.size.width - 2.0, 1.0, separatorView.frame.size.width, separatorView.frame.size.height)];
		[_footerView addSubview:separatorView];
		
		self.contentHeight += _footerView.frame.size.height;
	}
	return _footerView;
}

- (UIView*)priceView {
	
	if (_priceView == nil) {
		
		_priceView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 120.0, self.footerView.frame.size.height)];
		if (self.entry.priceIsFixedPerHour || self.entry.priceIsFixedPerJob) {
			
			UILabel* pointsLabel = [self boldPetrolLabelWithSize:30.0];
			[pointsLabel setFrame:CGRectMake(0.0, 5.0, _priceView.frame.size.width, 32.0)];
			[pointsLabel setText:[self.entry.price stringValue]];
			[_priceView addSubview:pointsLabel];
			
			UILabel* perLabel = [self semiBoldGrayLabelWithSize:14.0];
			[perLabel setFrame:CGRectMake(0.0, 37.0, _priceView.frame.size.width, 40.0)];
			[perLabel setLineBreakMode:NSLineBreakByWordWrapping];
			[perLabel setNumberOfLines:2];
			[perLabel setText:self.entry.priceIsFixedPerHour ? @"Skillpoints\nper hour" : @"Skillpoints\nper job"];
			[_priceView addSubview:perLabel];
		}
		else {
			
			UILabel* skillpointsLabel = [self semiBoldGrayLabelWithSize:16.0];
			[skillpointsLabel setFrame:CGRectMake(0.0, 23.0, _priceView.frame.size.width, 20.0)];
			[skillpointsLabel setText:@"Skillpoints"];
			[_priceView addSubview:skillpointsLabel];
			
			UILabel* negotiableLabel = [self boldPetrolLabelWithSize:16.0];
			[negotiableLabel setFrame:CGRectMake(0.0, 43.0, _priceView.frame.size.width, 20.0)];
			[negotiableLabel setText:@"negotiable"];
			[_priceView addSubview:negotiableLabel];
		}
	}
	return _priceView;
}

- (UIView*)locationView {
	if (_locationView == nil) {
		_locationView = [[UIView alloc] initWithFrame:CGRectMake(self.priceView.frame.size.width, 0.0, self.footerView.frame.size.width - self.priceView.frame.size.width, self.footerView.frame.size.height)];
		
		if (self.entry.locationIsRemote) {
			UILabel* canBeDoneLabel = [self semiBoldGrayLabelWithSize:16.0];
			[canBeDoneLabel setFrame:CGRectMake(0.0, 23.0, _locationView.frame.size.width, 20.0)];
			[canBeDoneLabel setText:@"This can be done"];
			[_locationView addSubview:canBeDoneLabel];
			
			UILabel* remotelyLabel = [self boldPetrolLabelWithSize:16.0];
			[remotelyLabel setFrame:CGRectMake(0.0, 43.0, _locationView.frame.size.width, 20.0)];
			[remotelyLabel setText:@"remotely"];
			[_locationView addSubview:remotelyLabel];
		}
		else if (self.entry.locationWillGoSomewhere) {
			if (self.entry.withinZipCode) {
				if ([[SZDataManager sharedInstance].currentUser.zipCode isEqualToString:self.entry.user.zipCode]) { // xy will come to you
					UILabel* label1 = [self semiBoldGrayLabelWithSize:15.0];
					[label1 setFrame:CGRectMake(0.0, 8.0, _locationView.frame.size.width, 20.0)];
					[label1 setText:self.entry.user.firstName];
					[_locationView addSubview:label1];
					
					UILabel* label2 = [self semiBoldGrayLabelWithSize:15.0];
					[label2 setFrame:CGRectMake(0.0, 28.0, _locationView.frame.size.width, 20.0)];
					[label2 setText:@"will come to you"];
					[_locationView addSubview:label2];
					
					SZButton* locationButton = [self locationButtonWithTitle:@"See area"];
					[_locationView addSubview:locationButton];
				}
				else {
					UILabel* label1 = [self semiBoldGrayLabelWithSize:15.0]; // you're outside of xy's area
					[label1 setFrame:CGRectMake(0.0, 8.0, _locationView.frame.size.width, 20.0)];
					[label1 setText:@"You're outside of"];
					[_locationView addSubview:label1];
					
					UILabel* label2 = [self semiBoldGrayLabelWithSize:15.0];
					[label2 setFrame:CGRectMake(0.0, 28.0, _locationView.frame.size.width, 20.0)];
					[label2 setText:[NSString stringWithFormat:@"%@'s area.", self.entry.user.firstName]];
					[_locationView addSubview:label2];
					
					SZButton* locationButton = [self locationButtonWithTitle:@"See area"];
					[_locationView addSubview:locationButton];
				}
			}
			else if (self.entry.withinSpecifiedArea) {
				if ([SZDataManager sharedInstance].currentUser.hasFullAddress) {
					if ([[SZDataManager sharedInstance].currentUser isWithinDistance:self.entry.distance ofAddress:self.entry.address]) { // xy will come to you
						UILabel* label1 = [self semiBoldGrayLabelWithSize:15.0];
						[label1 setFrame:CGRectMake(0.0, 8.0, _locationView.frame.size.width, 20.0)];
						[label1 setText:self.entry.user.firstName];
						[_locationView addSubview:label1];
						
						UILabel* label2 = [self semiBoldGrayLabelWithSize:15.0];
						[label2 setFrame:CGRectMake(0.0, 28.0, _locationView.frame.size.width, 20.0)];
						[label2 setText:@"will come to you"];
						[_locationView addSubview:label2];
						
						SZButton* locationButton = [self locationButtonWithTitle:@"See area"];
						[_locationView addSubview:locationButton];
					}
					else { // you're outside of xy's area
						UILabel* label1 = [self semiBoldGrayLabelWithSize:15.0]; // you're outside of xy's area
						[label1 setFrame:CGRectMake(0.0, 8.0, _locationView.frame.size.width, 20.0)];
						[label1 setText:@"You're outside of"];
						[_locationView addSubview:label1];
						
						UILabel* label2 = [self semiBoldGrayLabelWithSize:15.0];
						[label2 setFrame:CGRectMake(0.0, 28.0, _locationView.frame.size.width, 20.0)];
						[label2 setText:[NSString stringWithFormat:@"%@'s area.", self.entry.user.firstName]];
						[_locationView addSubview:label2];
						
						SZButton* locationButton = [self locationButtonWithTitle:@"See area"];
						[_locationView addSubview:locationButton];
					}
				}
				else {
					UILabel* label1 = [self semiBoldGrayLabelWithSize:15.0];
					[label1 setFrame:CGRectMake(0.0, 8.0, _locationView.frame.size.width, 20.0)];
					[label1 setText:self.entry.user.firstName];
					[_locationView addSubview:label1];
					
					UILabel* label2 = [self semiBoldGrayLabelWithSize:15.0];
					[label2 setFrame:CGRectMake(0.0, 28.0, _locationView.frame.size.width, 20.0)];
					[label2 setText:@"might come to you"];
					[_locationView addSubview:label2];
					
					SZButton* locationButton = [self locationButtonWithTitle:@"See area"];
					[_locationView addSubview:locationButton];
				}
			}
			else if (self.entry.withinNegotiableArea) { // xy might come to you
				UILabel* label1 = [self semiBoldGrayLabelWithSize:15.0];
				[label1 setFrame:CGRectMake(0.0, 10.0, _locationView.frame.size.width, 20.0)];
				[label1 setText:self.entry.user.firstName];
				[_locationView addSubview:label1];
				
				UILabel* label2 = [self semiBoldGrayLabelWithSize:15.0];
				[label2 setFrame:CGRectMake(0.0, 28.0, _locationView.frame.size.width, 20.0)];
				[label2 setText:@"might come to you"];
				[_locationView addSubview:label2];
				
				UILabel* label3 = [self boldPetrolLabelWithSize:15.0];
				[label3 setFrame:CGRectMake(0.0, 52.0, _locationView.frame.size.width, 20.0)];
				[label3 setText:@"(distance negotiable)"];
				[_locationView addSubview:label3];
			}
		}
		else { // you have to go to xy's
			UILabel* label1 = [self semiBoldGrayLabelWithSize:15.0];
			[label1 setFrame:CGRectMake(0.0, 8.0, _locationView.frame.size.width, 20.0)];
			[label1 setText:@"You have to go to"];
			[_locationView addSubview:label1];
			
			UILabel* label2 = [self semiBoldGrayLabelWithSize:15.0];
			[label2 setFrame:CGRectMake(0.0, 28.0, _locationView.frame.size.width, 20.0)];
			[label2 setText:[NSString stringWithFormat:@"%@'s.", self.entry.user.firstName]];
			[_locationView addSubview:label2];
			
			SZButton* locationButton = [self locationButtonWithTitle:@"See location"];
			[_locationView addSubview:locationButton];
		}
	}
	return _locationView;
}

- (UILabel*)boldPetrolLabelWithSize:(CGFloat)size {
	UILabel* label = [[UILabel alloc] init];
	[label setBackgroundColor:[UIColor clearColor]];
	[label setFont:[SZGlobalConstants fontWithFontType:SZFontBold size:size]];
	[label setTextColor:[SZGlobalConstants darkPetrol]];
	[label applyWhiteShadow];
	[label setTextAlignment:NSTextAlignmentCenter];
	return label;
}

- (UILabel*)semiBoldGrayLabelWithSize:(CGFloat)size {
	UILabel* label = [[UILabel alloc] init];
	[label setBackgroundColor:[UIColor clearColor]];
	[label setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:size]];
	[label setTextColor:[SZGlobalConstants gray]];
	[label applyWhiteShadow];
	[label setTextAlignment:NSTextAlignmentCenter];
	return label;
}

- (SZButton*)locationButtonWithTitle:(NSString*)title {
	SZButton* button = [[SZButton alloc] initWithColor:SZButtonColorPetrol size:SZButtonSizeSmall width:120.0];
	[button setTitle:title forState:UIControlStateNormal];
	[button setCenter:CGPointMake(self.locationView.frame.size.width/2, self.locationView.frame.size.height - 8.0 - button.frame.size.height/2)];
	return button;
}


@end
