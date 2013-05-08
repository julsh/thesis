//
//  SZRootViewController.h
//  Skillz
//
//  Created by Julia Roggatz on 21.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZMenuVC.h"

/** This class serves as the application's main navigation controller. All view controllers will be handled within this navigation controller. The SZNavigationController is also used to present modal view controllers. It acts as the delegate for the <SZMenuVC> and instantiates and presents new root view controllers if the user tapped a section of the menu.
 */
@interface SZNavigationController : UIViewController <SZMenuVCDelegate>

/** Initializes an SZNavigationController with a specified root view controller.
 @param rootViewController The UIViewController that will be the root of the view hierachy.
 */
- (id)initWithRootViewController:(UIViewController *)rootViewController;

@end
