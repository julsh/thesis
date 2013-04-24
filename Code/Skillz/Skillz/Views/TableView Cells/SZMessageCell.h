//
//  SZMessageCell.h
//  Skillz
//
//  Created by Julia Roggatz on 21.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZUserPhotoView.h"

@interface SZMessageCell : UITableViewCell


@property (nonatomic, strong) SZUserPhotoView* userPhoto;
@property (nonatomic, strong) UILabel* userNameLabel;
@property (nonatomic, strong) UILabel* timeLabel;
@property (nonatomic, strong) UILabel* messageTeaserLabel;

@end
