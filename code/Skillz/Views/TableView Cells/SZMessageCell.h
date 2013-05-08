//
//  SZMessageCell.h
//  Skillz
//
//  Created by Julia Roggatz on 21.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZUserPhotoView.h"

/**
 This class representes a message cell in the "Messages" view. It is used within the table view that belongs to the <SZMyMessagesVC>
 */
@interface SZMessageCell : UITableViewCell

/**
 The <SZUserPhotoView> displaying the conversation partner's photo.
 */
@property (nonatomic, strong) SZUserPhotoView* userPhoto;

/**
 A label displaying the conversation partner's name.
 */
@property (nonatomic, strong) UILabel* userNameLabel;

/**
 A label indicating how long ago the message was received.
 */
@property (nonatomic, strong) UILabel* timeLabel;

/**
 A label showing displaying the beginning of the message text.
 */
@property (nonatomic, strong) UILabel* messageTeaserLabel;

@end
