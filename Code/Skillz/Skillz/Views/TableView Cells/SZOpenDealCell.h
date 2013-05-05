//
//  SZOpenDealCell.h
//  Skillz
//
//  Created by Julia Roggatz on 05.05.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZUserPhotoView.h"

@interface SZOpenDealCell : UITableViewCell

/**
 The title label that indicates whose entry is references, and what kind of entry it is (request or offer)
 */
@property (nonatomic, strong) UILabel* whoseEntryLabel;

/**
 The label that show's the title of the entry that is references
 */
@property (nonatomic, strong) UILabel* entryTitleLabel;

/**
 The photo of the deal partner
 */
@property (nonatomic, strong) SZUserPhotoView* userPhoto;

/**
 Sets the text that indicates who gets paid how much for the deal an positions the coin icon accordingly
 @param userName The name of the deal partner and whethert they get paid or have to pay
 @param dealPrice How much gets paid for the deal (and if it's hour based for how many hours)
 */
- (void)setDealPartnerName:(NSString*)userName dealPrice:(NSString*)dealPrice;

@end
