//
//  SZSegmentedControlHorizontal.h
//  Skillz
//
//  Created by Julia Roggatz on 20.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <UIKit/UIKit.h>

/** This class subclasses the generic UISegmentedControl to match the app's color scheme.
 */
@interface SZSegmentedControlHorizontal : UISegmentedControl

/** Sets a custom font size for an existing SZSegmentedControlHorizontal instance.
 @param fontSize The font size for the items in in the segmented control
 */
- (void)setFontSize:(CGFloat)fontSize;

@end
