//
//  UILabel+Shadow.h
//  Skillz
//
//  Created by Julia Roggatz on 21.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * This class category supplements the regular UILabel class with the option to conveniently apply a black or white shadow using only one line of coe.
*/

@interface UILabel (Shadow)

/// Applies a white shadow to the UILabel instance that the function is called on
- (void) applyWhiteShadow;

/// Applies a black shadow to the UILabel instance that the function is called on
- (void) applyBlackShadow;

@end
