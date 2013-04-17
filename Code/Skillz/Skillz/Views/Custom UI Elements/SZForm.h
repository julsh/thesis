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
@property (nonatomic, strong) UIScrollView* scrollContainer;
@property (nonatomic, weak) id <SZFormDelegate> delegate;
@property (nonatomic, assign) BOOL isActive;

- (id)initWithWidth:(CGFloat)width;
- (id)initForTextViewWithItem:(SZFormFieldVO*)item width:(CGFloat)width height:(CGFloat)height;
- (void)addItem:(SZFormFieldVO*)item showsClearButton:(BOOL)showsClearButton isLastItem:(BOOL)isLast;
- (void)configureKeyboard;
- (void)setText:(NSString*)text forFieldAtIndex:(NSInteger)index;
- (void)setTextFieldWidth:(CGFloat)width forFieldAtIndex:(NSInteger)index;
- (void)updatePickerAtIndex:(NSInteger)index;
- (void)updatePickerOptions:(NSArray*)options forPickerAtIndex:(NSInteger)index;
- (void)updateDatePickerAtIndex:(NSInteger)index withDate:(NSDate*)date;
- (void)resign:(UIView*)firstResponder completion:(void(^)(BOOL finished))completion;

+ (SZForm*)addressFormWithWidth:(CGFloat)width;
+ (NSDictionary*)addressDictfromAddressForm:(SZForm*)addressForm;
- (void)setAddress:(NSDictionary*)address;

@end


@protocol SZFormDelegate <NSObject>

@optional
- (BOOL)form:(SZForm*)form didConfirmDatePicker:(UIDatePicker*)datePicker;

@optional
- (void)formDidBeginEditing:(SZForm*)form;

@optional
- (void)formDidEndEditing:(SZForm*)form;

@optional
- (void)form:(SZForm*)form didConfirmPicker:(UIPickerView*)picker;

@optional
- (void)formDidResignFirstResponder:(SZForm *)form;

@end