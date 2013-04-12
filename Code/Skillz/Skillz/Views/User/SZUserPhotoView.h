//
//  SZUserPhotoView.h
//  Skillz
//
//  Created by Julia Roggatz on 06.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZUserPhotoView : UIView

@property (nonatomic, strong) UIImageView* photo;

+ (SZUserPhotoView*)emptyUserPhotoWithSize:(SZUserPhotoViewSize)size;

@end
