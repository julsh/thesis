//
//  SZSortFilterMenu.h
//  Skillz
//
//  Created by Julia Roggatz on 18.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 This class acts as the super class for the <SZSortMenuVC> and <SZFilterMenuVC>. Since the two classes share some of the same behavior and layout, the SZSortFilterMenu was created to reduce code redundancy.
 */
@interface SZSortFilterMenu : SZViewController

/** Indicates whether or not the menu is currently shown.
 */
@property (nonatomic, assign) BOOL isShowing;

/** The scroll view acting as the root view of all added subviews. Needed because the both <SZSortMenuVC> and <SZFilterMenuVC> will display an <SZForm> object.
 */
@property (nonatomic, strong) UIScrollView* scrollView;

/** Shows or hides the <SZSortMenuVC> or <SZFilterMenuVC>
 */
- (void)toggle;

@end
