//
//  SZFormFieldVO.h
//  Skillz
//
//  Created by Julia Roggatz on 30.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZFormFieldVO : NSObject

@property (nonatomic, strong) NSString* key;
@property (nonatomic, strong) NSString* placeHolderText;
@property (nonatomic, assign) SZFormFieldInputType inputType;
@property (nonatomic, assign) UIKeyboardType keyboardType;
@property (nonatomic, assign) BOOL isPassword;
@property (nonatomic, strong) NSArray* pickerOptions;
@property (nonatomic, assign) NSInteger pickerOptionsSelectedIndex;
@property (nonatomic, assign) UIDatePickerMode datePickerMode;
@property (nonatomic, assign) NSInteger datePickerMinuteInterval;
@property (nonatomic, strong) NSDate* datePickerStartDate;

+ (SZFormFieldVO*)formFieldValueObjectForTextWithKey:(NSString*)key placeHolderText:(NSString*)placeHolderText keyboardType:(UIKeyboardType)keyboardType;

+ (SZFormFieldVO*)formFieldValueObjectForPickerWithKey:(NSString*)key placeHolderText:(NSString*)placeHolderText pickerOptions:(NSArray*)pickerOptions;

+ (SZFormFieldVO*)formFieldValueObjectForDatePickerWithKey:(NSString*)key placeHolderText:(NSString*)placeHolderText datePickerMode:(UIDatePickerMode)datePickerMode;

@end
