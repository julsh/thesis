//
//  SZForm.h
//  Skillz
//
//  Created by Julia Roggatz on 20.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSKeyboardControls.h"
#import "SZFormFieldVO.h"

@protocol SZFormDelegate;

@interface SZForm : UIView <UITextFieldDelegate, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, BSKeyboardControlsDelegate>

@property (nonatomic, strong) NSMutableDictionary* userInputs;
@property (nonatomic, strong) UIView* scrollContainer;
@property (nonatomic, weak) id <SZFormDelegate> delegate;

- (id)initWithWidth:(CGFloat)width;
- (id)initForTextViewWithItem:(SZFormFieldVO*)item width:(CGFloat)width height:(CGFloat)height;
- (void)addItem:(SZFormFieldVO*)item isLastItem:(BOOL)isLast;
- (void)configureKeyboard;
- (void)setText:(NSString*)text forFieldAtIndex:(NSInteger)index;
- (void)updatePickerAtIndex:(NSInteger)index;
- (void)updatePickerOptions:(NSArray*)options forPickerAtIndex:(NSInteger)index;
- (void)updateDatePickerAtIndex:(NSInteger)index withDate:(NSDate*)date;


+ (SZForm*)addressFormWithWidth:(CGFloat)width;
+ (NSDictionary*)addressDictfromAddressForm:(SZForm*)addressForm;

@end


@protocol SZFormDelegate <NSObject>

@optional
- (BOOL)form:(SZForm*)form didConfirmDatePicker:(UIDatePicker*)datePicker;

@optional
- (void)formDidBeginEditing:(SZForm*)form;

@optional
- (void)form:(SZForm*)form didConfirmPicker:(UIPickerView*)picker;

@end