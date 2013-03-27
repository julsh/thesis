//
//  SZStepVC.h
//  Skillz
//
//  Created by Julia Roggatz on 25.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZButton.h"

@interface SZStepVC : UIViewController

@property (nonatomic, strong) UIScrollView* mainView;
@property (nonatomic, strong) UIView* detailViewContainer;
@property (nonatomic, strong) SZButton* continueButton;

- (id)initWithStepNumber:(NSInteger)stepNumber totalSteps:(NSInteger)totalSteps;
- (void)updateBounds;
- (void)newDetailViewAdded;
- (void)setScrollViewHeight:(CGFloat)newHeight;

@end
