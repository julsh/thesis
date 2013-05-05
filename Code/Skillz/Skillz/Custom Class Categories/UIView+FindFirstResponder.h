//
//  UIView+FindFirstResponder.h
//  Skillz
//
//  Created by Julia Roggatz on 21.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <UIKit/UIKit.h>

/** This class category supplements a regular UIView object with the option of checking if one of its contained subviews is currently the first responder (which means that is being edited and shows a keyboard, picker or custom input view). It recursively traverses all contained subviews and return whichever subview is the first responder, or `nil` if no subview is the first responder.
 */

@interface UIView (FindFirstResponder)

/* Recursive method to find the first responder within the subviews of a UIView instance.
 @ return The view that is the current first responder, or `nil` if none of the subviews is the current first responder.
 */
- (UIView *)findFirstResponder;

@end
