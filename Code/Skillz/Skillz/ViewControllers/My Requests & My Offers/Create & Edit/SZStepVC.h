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

/**
 This class acts as the super class for the view controllers representing the 5 different steps required to create or edit an entry. Since the respective SZEntryStep*VCs share much of the same functionality (for example the "Continue" button at the bottom of the view or the behavior of the scroll view), this class was created to reduce code redundancy.
 */
@interface SZStepVC : SZViewController <SZSegmentedControlVerticalDelegate, UIAlertViewDelegate>

/** The scroll view acting as the root view of all added subviews. Needed because the view controllers that subclass SZStepVC will display one or more <SZForm> objects.
 */
@property (nonatomic, strong) UIScrollView* mainView;

/** A view container that can carry additional information or controls when a user selected a segmented of the <SZSegmentedControlVertical> that many of the view controllers that subclass SZStepVC will use. Will get a fancypants slide-in-slide-out animation. I wonder if anyone will actually read this documentation.
 */
@property (nonatomic, strong) UIView* detailViewContainer;

/** The button that will bring the user to the next step.
 */
@property (nonatomic, strong) SZButton* continueButton;

/** A property indicating whether a view controller is displayed for the first time or whether it has been displayed before. Needed to properly align and layout the subviews and set the correct position of the scroll view.
 */
@property (nonatomic, assign) BOOL firstDisplay;

/** An array holding references to all forms used with in view controller subclassing the SZStepVC. Used to resign whatever form is currently active when a user taps anywhere on the background.
 */
@property (nonatomic, strong) NSMutableArray* forms;

/** Initializes an SZStepVC instance with a specified step number and a number of total steps.
 @param stepNumber The number of the step that the initialized view controller will represent
 @param totalSteps The total number of steps
 @return An instance of whatever SZStepVC-subclass called this method
 */
- (id)initWithStepNumber:(NSInteger)stepNumber totalSteps:(NSInteger)totalSteps;

/** Updates the frame of the scroll view according to its content size.
 @param animated Whether or not this should be animated
 */
- (void)updateBoundsAnimated:(BOOL)animated;

/** Updates the frame of the scroll view according to its content size.
 Does some additional laying out after a new detail view has been added.
 @param animated Whether or not this should be animated
 */
- (void)newDetailViewAddedAnimated:(BOOL)animated;

/** Sets the scroll view height to a specified height. Used to enable proper scrolling when a form is active (showing a keyboard or picker input view).
 @param newHeight The new height that the scroll view should have.
 */
- (void)setScrollViewHeight:(CGFloat)newHeight;

/** Slides out the currently displayed detail view and adds a new detail view with a specified index
 @param index The index of the new detail view to add. Refers to the selected segment index of the SZSegmentedControlVertical that handles the detail view. 
 */
- (void)slideOutDetailViewAndAddNewViewWithIndex:(NSInteger)index;

@end
