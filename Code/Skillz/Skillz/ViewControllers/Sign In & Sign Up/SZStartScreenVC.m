//
//  SZStartScreenVC.m
//  Skillz
//
//  Created by Julia Roggatz on 26.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZStartScreenVC.h"
#import "SZForm.h"
#import "SZFormFieldVO.h"

@interface SZStartScreenVC ()

@end

@implementation SZStartScreenVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	SZForm* form = [[SZForm alloc] initWithWidth:290.0];
	SZFormFieldVO* textField = [SZFormFieldVO formFieldValueObjectForTextWithKey:@"text"
																 placeHolderText:@"Put in some text!" keyboardType:UIKeyboardTypeDefault];
	SZFormFieldVO* numberField = [SZFormFieldVO formFieldValueObjectForTextWithKey:@"number"
																   placeHolderText:@"Put in a number!" keyboardType: UIKeyboardTypeDecimalPad];
	SZFormFieldVO* pickerField = [SZFormFieldVO formFieldValueObjectForPickerWithKey:@"picker"
																	 placeHolderText:@"Pick!" pickerOptions:[NSArray arrayWithObjects:@"A", @"B", @"C", nil]];
	[form addItem: textField showsClearButton:YES isLastItem:NO];
	[form addItem: numberField showsClearButton:YES isLastItem:NO];
	[form addItem: pickerField showsClearButton:YES isLastItem:YES];
	
	[form setCenter:CGPointMake(160.0, 80.0)];
	[form configureKeyboard];
	
	[self.view addSubview:form];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
