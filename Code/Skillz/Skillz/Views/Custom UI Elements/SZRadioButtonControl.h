//
//  SZRadioButtonControl.h
//  Skillz
//
//  Created by Julia Roggatz on 25.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SZRadioButtonControl : UIView

@property (nonatomic, assign) NSInteger selectedIndex;

- (void)addItemWithView:(UIView*)view;
- (void)setSelectedIndex:(NSInteger)selectedIndex;

@end
