//
//  SZSegmentedControlVertical.h
//  Skillz
//
//  Created by Julia Roggatz on 25.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SZSegmentedControlVerticalDelegate;

/** This class takes care of configuring and laying out a segmented control in which the different options are arranged vertically (on top of each other). The user may chose one of the provided options.
 */
@interface SZSegmentedControlVertical : UIView

/// @name Assign the delegate

/// The object that acts as the delegate of the control.
@property (nonatomic, weak) id <SZSegmentedControlVerticalDelegate> delegate;

/// @name Get the selected index

/// The currently selected index of the control
@property (nonatomic, assign) NSInteger selectedIndex;

/// The title of the control's currently selected index
@property (nonatomic, assign) NSString* selectedIndexTitle;

/// @name Initialize

/** Initializes an SZSegmentedControlVertical instance with the specified width.
 @param width The width for the control.
 */
- (id)initWithWidth:(CGFloat)width;

/// @name Configure

/** Adds an option to the control.
 @param text The text of the option which to add to the control
 @param isLast Whether or not the item to add is the last element. This is needed because the last element will have rounded colors at the bottom
 */
- (void)addItemWithText:(NSString*)text isLast:(BOOL)isLast;

@end

/** This protocol defines a method that any object acting as a delegate for an <SZSegmentedControlVertical> instance may implement to be informed when a segment of the control was selected by the user. 
 */
@protocol SZSegmentedControlVerticalDelegate <NSObject>

/** Tells the delegate when a segment of the control was selected by the user.
 @param control The control that was received the event
 @param index The index that was selected
 */
- (void)segmentedControlVertical:(SZSegmentedControlVertical*)control didSelectItemAtIndex:(NSInteger)index;

@end
