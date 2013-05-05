//
//  SZMenuVC.h
//  Skillz
//
//  Created by Julia Roggatz on 25.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	SZNavigationMenu,
	SZNavigationSortOrFiler
} SZNavigationType;

@protocol SZMenuVCDelegate;

/** This class represents the menu through which the user can switch between different sections of the app. It is designed as a singleton and instantiated once upon application launch. The configuration of the menu is handled internally. However, the SZMenuVC offers an interface to add an additional right menu to the instance. See <addAdditionalRightMenu:> for details on this.
 */
@interface SZMenuVC : UIViewController <UITableViewDataSource, UITableViewDelegate>

/// The object that acts as the delegate of the menu.
@property (nonatomic, weak) id <SZMenuVCDelegate> delegate;

/// The singleton instance of the menu
+ (SZMenuVC*)sharedInstance;

/// @name Additional menu on the right side

/** This method adds another menu to the right side of the screen. This is used for the <SZSortMenuVC> and the <SZFilterMenuVC> to be handled within the global menu class. When added, the sort or filter menu will be positioned above the global menu to be fully visible when the user wants to access sort or filter functions. However, when the user swipes to the right to access the global menu while another menu is still present, the other menu will be hidden to give full visibility to the global menu.
 @param vc The view controller representing the other hidden menu. Will be either <SZSortMenuVC> or <SZFilterMenuVC> at this point but could theoretically be used for any other view controller as well, leaving the additonal menu functionality fully flexible for further changes.
 */
- (void)addAdditionalRightMenu:(UIViewController*)vc;

/** Removes the additional right menu again 
 */
- (void)removeAdditionalRightMenu;

/** Shows the additional right menu
 */
- (void)showAdditionalRightMenu;

/** Hides the additional right menu
 */
- (void)hideAdditionalRightMenu;
	
@end

/** This protocol defines a method to handle selection of a menu item. It tells the menu's assigned delegate to switch to a view controller with a specified class name. The corresponding class name for each menu item is stored within the private part of the menu. The delegate should implement the <switchToViewControllerWithClassName:> method in order to create an instance of the corresponding vier controller and present it to the user.
 */
@protocol SZMenuVCDelegate <NSObject>

/** Tells the menu's assigned delegate to switch to a view controller with a specified class name.
 @param className The name of the class which should be instantiated and presented to the user.
 */
@required
- (void)switchToViewControllerWithClassName:(NSString*)className;
@end