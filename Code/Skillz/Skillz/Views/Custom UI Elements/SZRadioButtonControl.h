//
//  SZRadioButtonControl.h
//  Skillz
//
//  Created by Julia Roggatz on 25.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <UIKit/UIKit.h>

/** This class takes care of layouting and configuring a view in which the user can select from different options by tapping one of the provided radio buttons. Only one option can be selected.
 */
@interface SZRadioButtonControl : UIView

/** The currently selected index of the radio button control
 */
@property (nonatomic, assign) NSInteger selectedIndex;

/** Adds a view representing one distinct option to an exisiting SZRadioButtonControl instance
 @param view The view representing the option which to add to the control
 */
- (void)addItemWithView:(UIView*)view;

/** Selects one of the radio buttons according to the provided index
 @param selectedIndex The index which to select
 */
- (void)setSelectedIndex:(NSInteger)selectedIndex;

@end
