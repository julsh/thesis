//
//  SZFormFieldVO.h
//  Skillz
//
//  Created by Julia Roggatz on 30.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

/** The SZFormFieldVO is a value object used to customized the appearance and behavior of a single field with an SZForm view. Each field in a form is assigned an SZFormFieldVO instance that specifies its input type (keyboard, regular picker or date picker) as well as some additional properties that may be required to properly configure the field. 
 *
 */

#import <Foundation/Foundation.h>

typedef enum {
	SZFormFieldInputTypeKeyboard,
	SZFormFieldInputTypePicker,
	SZFormFieldInputTypeDatePicker
} SZFormFieldInputType;

@interface SZFormFieldVO : NSObject

/** @name Properties */

/// The key through which the user input stored for the specific field may be accessed from outside
@property (nonatomic, strong) NSString* key;

/// The placeholder text that will be displayed within the form's respective text field if no input has been made
@property (nonatomic, strong) NSString* placeHolderText;


/** Specifies how the keyboard will be displayed. Besides the standard keyboard layout, this could for example be a number/decimal pad or a keyboard optimized for email address input. 
 
 This property Uses the `UIKeyboardType` enumerator. Allowed values are:
 
- `UIKeyboardTypeDefault`
- `UIKeyboardTypeASCIICapable`
- `UIKeyboardTypeNumbersAndPunctuation`
- `UIKeyboardTypeURL`
- `UIKeyboardTypeNumberPad`
- `UIKeyboardTypePhonePad`
- `UIKeyboardTypeNamePhonePad`
- `UIKeyboardTypeEmailAddress`
- `UIKeyboardTypeDecimalPad`
- `UIKeyboardTypeTwitter`
- `UIKeyboardTypeAlphabet`
 
 */
@property (nonatomic, assign) UIKeyboardType keyboardType;

/** Specifies the input type of the form field. 
 
 This property uses the `SZFormFieldInputType` enumerator. Allowed values are:
 
- `SZFormFieldInputTypeKeyboard`
- `SZFormFieldInputTypePicker`
- `SZFormFieldInputTypeDatePicker`
 
 */
@property (nonatomic, assign) SZFormFieldInputType inputType;

/// Specifies if the input should be displayed as a password (in that case the input will be hidden by dot symbols). The default is `NO`.
@property (nonatomic, assign) BOOL isPassword;

/// If the field uses a regular UIPickerView as its input type, this property provides the options that the picker will offer to the user.
@property (nonatomic, strong) NSArray* pickerOptions;

/** If the field uses a UIDatePicker as its input type, this property is used to specify the date picker mode. 
 
This property uses the `UIDatePicker` enumerator. Allowed values are:
 
- `UIDatePickerModeTime`
- `UIDatePickerModeDate`
- `UIDatePickerModeDateAndTime`
- `UIDatePickerModeCountDownTimer`
 
 */
@property (nonatomic, assign) UIDatePickerMode datePickerMode;

/// If the field uses a UIDatePicker as its input type and the date picker lets the user choose a time as well, this property is used to specify the date picker minute interval. Default is 15 minutes interval.
@property (nonatomic, assign) NSInteger datePickerMinuteInterval;

/// If the field uses a UIDatePicker as its input type , this property specfies the date that is initially set within the picker. Default is the current time, rounded up to the next 15 minutes. (See <[SZUtils rightNowRoundedUp]> for details on this)
@property (nonatomic, strong) NSDate* datePickerStartDate;

/** @name Obtaining a configured instance */

/** Creates and returns an SZFormFieldVO configured for regular text input
 @param key The key through which the user input stored in the corresponding SZForm instance can be accessed from outside
 @param placeHolderText The placeholder text displayed within the text field when no input has been made
 @param keyboardType The keyboard layout to use for input
 @return A configured SZFormFieldVO instance
 */
+ (SZFormFieldVO*)formFieldValueObjectForTextWithKey:(NSString*)key placeHolderText:(NSString*)placeHolderText keyboardType:(UIKeyboardType)keyboardType;

/** Creates and returns an SZFormFieldVO configured for input through a UIPickerView
 @param key The key through which the user input stored in the corresponding SZForm instance can be accessed from outside
 @param placeHolderText The placeholder text displayed within the text field when no input has been made
 @param pickerOptions An array containing string representations of the options that a user may choose from in the input picker
 @return A configured SZFormFieldVO instance
 */
+ (SZFormFieldVO*)formFieldValueObjectForPickerWithKey:(NSString*)key placeHolderText:(NSString*)placeHolderText pickerOptions:(NSArray*)pickerOptions;

/** Creates and returns an SZFormFieldVO configured for input through a UIDatePicker
 @param key The key through which the user input stored in the corresponding SZForm instance can be accessed from outside
 @param placeHolderText The placeholder text displayed within the text field when no input has been made
 @param datePickerMode The mode that the UIDatePicker will be presented in. Uses the `UIDatePicker` enumerator. Allowed values are:
 
 - `UIDatePickerModeTime`
 - `UIDatePickerModeDate`
 - `UIDatePickerModeDateAndTime`
 - `UIDatePickerModeCountDownTimer`
 
 @return A configured SZFormFieldVO instance
 */
+ (SZFormFieldVO*)formFieldValueObjectForDatePickerWithKey:(NSString*)key placeHolderText:(NSString*)placeHolderText datePickerMode:(UIDatePickerMode)datePickerMode;

@end
