//
//  SZStepVC.h
//  Skillz
//
//  Created by Julia Roggatz on 25.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZButton.h"
#import "SZSegmentedControlVertical.h"
#import "SZDataManager.h"

@interface SZStepVC : UIViewController <SZSegmentedControlVerticalDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) UIScrollView* mainView;
@property (nonatomic, strong) UIView* detailViewContainer;
@property (nonatomic, strong) SZButton* continueButton;
@property (nonatomic, assign) BOOL editTaskFirstDisplay;

- (id)initWithStepNumber:(NSInteger)stepNumber totalSteps:(NSInteger)totalSteps;
- (void)updateBoundsAnimated:(BOOL)animated;
- (void)newDetailViewAddedAnimated:(BOOL)animated;
- (void)setScrollViewHeight:(CGFloat)newHeight;

@end
