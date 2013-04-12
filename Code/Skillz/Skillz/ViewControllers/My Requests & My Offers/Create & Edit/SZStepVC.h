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
#import "UILabel+Shadow.h"

@interface SZStepVC : UIViewController <SZSegmentedControlVerticalDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) UIScrollView* mainView;
@property (nonatomic, strong) UIView* detailViewContainer;
@property (nonatomic, strong) UIView* buttonArea;
@property (nonatomic, strong) SZButton* continueButton;
@property (nonatomic, strong) SZButton* saveAndCloseButton;
@property (nonatomic, assign) BOOL editTaskFirstDisplay;
@property (nonatomic, strong) NSMutableArray* forms;

- (id)initWithStepNumber:(NSInteger)stepNumber totalSteps:(NSInteger)totalSteps;
- (void)updateBoundsAnimated:(BOOL)animated;
- (void)newDetailViewAddedAnimated:(BOOL)animated;
- (void)setScrollViewHeight:(CGFloat)newHeight;
- (void)slideOutDetailViewAndAddNewViewWithIndex:(NSInteger)index;

@end
