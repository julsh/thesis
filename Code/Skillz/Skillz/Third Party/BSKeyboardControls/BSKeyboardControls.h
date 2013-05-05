//
//  BSKeyboardControls.h
//  Example
//
//  Created by Simon B. Støvring on 11/01/13.
//  Copyright (c) 2013 simonbs. All rights reserved.
//
//
// Copyright (c) 2012 Simon B. Støvring. Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <UIKit/UIKit.h>

/*
 *  Available controls.
 */
typedef enum
{
    BSKeyboardControlPreviousNext = 1 << 0,
    BSKeyboardControlDone = 1 << 1
} BSKeyboardControl;

/*
 *  Directions in which the fields can be selected.
 *  These are relative to the active field.
 */
typedef enum
{
    BSKeyboardControlsDirectionPrevious = 0,
    BSKeyboardControlsDirectionNext
} BSKeyboardControlsDirection;

@protocol BSKeyboardControlsDelegate;

@interface BSKeyboardControls : UIView

/*
 *  Delegate to send callbacks to.
 */
@property (nonatomic, weak) id <BSKeyboardControlsDelegate> delegate;

/*
 *  Visible controls. Use a bitmask to show multiple controls.
 */
@property (nonatomic, assign) BSKeyboardControl visibleControls;

/*
 *  Fields which the controls should handle.
 *  The order of the fields is important as this determines which text field
 *  is the previous and which is the next.
 *  All fields will automatically have the input accessory view set to
 *  the instance of the controls.
 */
@property (nonatomic, strong) NSArray *fields;

/*
 *  The active text field.
 *  This should be set when the user begins editing a text field or a text view
 *  and it is automatically set when selecting the previous or the next field.
 */
@property (nonatomic, strong) UIView *activeField;

/*
 *  Style of the toolbar.
 */
@property (nonatomic, assign) UIBarStyle barStyle;

/*
 *  Tint color of the toolbar.
 */
@property (nonatomic, strong) UIColor *barTintColor;

/*
 *  Tint color of the segmented control.
 */
@property (nonatomic, strong) UIColor *segmentedControlTintControl;

/*
 *  Title of the previous button. If this is not set, a default localized title will be used.
 */
@property (nonatomic, strong) NSString *previousTitle;

/*
 *  Title of the next button. If this is not set, a default localized title will be used.
 */
@property (nonatomic, strong) NSString *nextTitle;

/*
 *  Title of the done button. If this is not set, a default localized title will be used.
 */
@property (nonatomic, strong) NSString *doneTitle;

/*
 *  Tint color of the done button.
 */
@property (nonatomic, strong) UIColor *doneTintColor;

/*
 *  Initialize keyboard controls.
 *  @param fields Fields which the controls should handle.
 *  @return Initialized keyboard controls.
 */
- (id)initWithFields:(NSArray *)fields;

@end

@protocol BSKeyboardControlsDelegate <NSObject>
@optional
/*
 *  Called when a field was selected by going to the previous or the next field.
 *  The implementation of this method should scroll to the view.
 *  @param keyboardControls The instance of keyboard controls.
 *  @param field The selected field.
 *  @param direction Direction in which the field was selected.
 */
- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction;

/*
 *  Called when the done button was pressed.
 *  @param keyboardControls The instance of keyboard controls.
 */
- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls;
@end