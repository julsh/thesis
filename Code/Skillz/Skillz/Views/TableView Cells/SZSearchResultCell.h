//
//  SZSearchResultCell.h
//  Skillz
//
//  Created by Julia Roggatz on 05.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZUserPhotoView.h"
#import "SZStarsView.h"

/**
 This class representes an entry cell displayed within a search result view view. It is used within the table view inside the <SZSearchResultsVC>.
 */
@interface SZSearchResultCell : UITableViewCell

/**
 The title label that displays the entry's title
 */
@property (nonatomic, strong) UILabel* titleLabel;

/**
 The category label that displays the entry's category (and subcategory, if specified)
 */
@property (nonatomic, strong) UILabel* categoryLabel;

/**
 The label that display's the entries price, if specified, or indicates that the price is negotiable otherwise.
 */
@property (nonatomic, strong) UILabel* priceLabel;

/**
 The label that display's the distance between the entry's location and the user's current location (if specified).
 */
@property (nonatomic, strong) UILabel* distanceLabel;

/**
 An icon that will be displayed next to the distance label. Public because it will be hidden if there's no distance.
 */
@property (nonatomic, strong) UIImageView* distanceIcon;

/**
 The label that display's the name of the user who owns the entry.
 */
@property (nonatomic, strong) UILabel* userName;

/**
 The <SZUserPhotoView> of the user who owns the entry.
 */
@property (nonatomic, strong) SZUserPhotoView* userPhoto;

/**
 The <SZStarsView> representing the average review rating of the user who owns the entry.
 */
@property (nonatomic, strong) SZStarsView* starsView;

@end
