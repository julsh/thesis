//
//  SZCheckBox.h
//  Skillz
//
//  Created by Julia Roggatz on 20.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <UIKit/UIKit.h>

/** This class subclasses `UIButton` to create a button that behaves like a checkbox.
 */

@interface SZCheckBox : UIButton

/** Indicates whether or not the checkbox is checked.
 */
@property (nonatomic, assign) BOOL isChecked;

@end
