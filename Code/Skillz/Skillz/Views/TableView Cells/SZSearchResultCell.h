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

@interface SZSearchResultCell : UITableViewCell

@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* categoryLabel;
@property (nonatomic, strong) UILabel* pointsLabel;
@property (nonatomic, strong) UILabel* userName;
@property (nonatomic, strong) SZUserPhotoView* userPhoto;
@property (nonatomic, strong) SZStarsView* starsView;

@end
