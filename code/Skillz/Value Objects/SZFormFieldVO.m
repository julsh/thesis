//
//  SZFormFieldVO.m
//  Skillz
//
//  Created by Julia Roggatz on 30.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZFormFieldVO.h"
#import "SZUtils.h"

@implementation SZFormFieldVO

@synthesize key;
@synthesize placeHolderText;
@synthesize inputType;
@synthesize keyboardType;
@synthesize isPassword;
@synthesize pickerOptions;
@synthesize datePickerMode;
@synthesize datePickerMinuteInterval;
@synthesize datePickerStartDate;

+ (SZFormFieldVO*)formFieldValueObjectForTextWithKey:(NSString*)key placeHolderText:(NSString*)placeHolderText keyboardType:(UIKeyboardType)keyboardType {
	
	SZFormFieldVO* vo = [[SZFormFieldVO alloc] init];
	
	[vo setKey:key];
	[vo setPlaceHolderText:placeHolderText];
	[vo setInputType:SZFormFieldInputTypeKeyboard];
	[vo setKeyboardType:keyboardType];
	
	return vo;
}

+ (SZFormFieldVO*)formFieldValueObjectForPickerWithKey:(NSString*)key placeHolderText:(NSString*)placeHolderText pickerOptions:(NSArray*)pickerOptions {
	
	SZFormFieldVO* vo = [[SZFormFieldVO alloc] init];
	
	[vo setKey:key];
	[vo setPlaceHolderText:placeHolderText];
	[vo setInputType:SZFormFieldInputTypePicker];
	[vo setPickerOptions:pickerOptions];
	
	return vo;
}

+ (SZFormFieldVO*)formFieldValueObjectForDatePickerWithKey:(NSString*)key placeHolderText:(NSString*)placeHolderText datePickerMode:(UIDatePickerMode)datePickerMode {
 
	 SZFormFieldVO* vo = [[SZFormFieldVO alloc] init];
	 
	 [vo setKey:key];
	 [vo setPlaceHolderText:placeHolderText];
	 [vo setInputType:SZFormFieldInputTypeDatePicker];
	 [vo setDatePickerMode:datePickerMode];
	 [vo setDatePickerMinuteInterval:15]; // standard initialization. may be changed manually through public property.
	 [vo setDatePickerStartDate:[SZUtils rightNowRoundedUp]]; // standard initialization. may be changed manually through public property.
	 
	 return vo;
 
 }

@end
