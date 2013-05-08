//
//  UITextView+Shadow.h
//  Skillz
//
//  Created by Julia Roggatz on 23.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * This class category supplements the regular UITextView class with the option to conveniently apply a black or white shadow using only one line of coe.
 */

@interface UITextView (Shadow)

/// Applies a white shadow to the UITextView instance that the function is called on
- (void) applyWhiteShadow;

/// Applies a black shadow to the UITextView instance that the function is called on
- (void) applyBlackShadow;

@end
