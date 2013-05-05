//
//  SZViewController.h
//  Skillz
//
//  Created by Julia Roggatz on 05.05.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <UIKit/UIKit.h>

/** This class simply subclasses UIViewController and overrides its `viewDidLoad` method to set the view's background to the background pattern that is used throughout the app. This way the background can quickly be exchanged with just changing one line of code (well, actually two. See <SZTableViewController>) instead of going through every single class that uses the background. The SZViewController also sets the label of the back button item to read "Back" by default.
 
 If a class subclassing SZViewController wants to act as a root view controller (meaning it will be on the root of a navigation hierarchy and display a menu button on the top left), it simply needs to call the <addMenuButton> method in its individual `viewDidLoad` method.
 */
@interface SZViewController : UIViewController

/**
 Adds a menu button to the top left of the navigation bar.
 */
- (void)addMenuButton;

@end
