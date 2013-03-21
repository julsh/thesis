//
//  SZForm.h
//  Skillz
//
//  Created by Julia Roggatz on 20.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSKeyboardControls.h"

@interface SZForm : UIView <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, BSKeyboardControlsDelegate>

@property (nonatomic, strong) NSMutableDictionary* userInputs;

- (void)addItem:(NSDictionary*)item isLastItem:(BOOL)isLast;
- (void)configureKeyboard;

@end
