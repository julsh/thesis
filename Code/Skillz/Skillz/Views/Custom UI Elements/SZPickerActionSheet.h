//
//  SZPickerActionSheet.h
//  Skillz
//
//  Created by Julia Roggatz on 20.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZPickerActionSheet : UIActionSheet <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) NSString* choice;

- (id)initWithChoices:(NSArray*)choices;
- (void)scrollToIndex:(NSInteger)index;

@end
