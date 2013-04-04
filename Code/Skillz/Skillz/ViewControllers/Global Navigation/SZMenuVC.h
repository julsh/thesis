//
//  SZMenuVC.h
//  Skillz
//
//  Created by Julia Roggatz on 25.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SZMenuVCDelegate;


@interface SZMenuVC : UIViewController <UITableViewDataSource, UITableViewDelegate>

/// The object that acts as the delegate of the receiving left menu.
@property (nonatomic, weak) id <SZMenuVCDelegate> delegate;

/// Returns the number of sections in the table view.  Can also be used to set the number of sections.
@property (nonatomic, assign) NSInteger numberOfSections;

/// The table view used to display the different menu options
@property (nonatomic, strong) UITableView *tableView;

/// Singleton
+(SZMenuVC*)sharedInstance;

/// Adds an item to the tableview in the specified section.
/// @param itemDictionary the item too add to the menu
/// @param sectionIndex the section to which to add the item
- (void)addItem:(NSDictionary *)itemDictionary toSection:(NSInteger)sectionIndex;

/// Sets the title for the specified section.
/// @param sectionTitle the new title for the specified section
/// @param sectionIndex the section for which to set the new title
- (void)setSectionTitle:(NSString *)sectionTitle forSection:(NSInteger)sectionIndex;

/// Returns the item dictionary for the item at the specified section row.
/// @param row the row from which the item dictionary should be retrieved
/// @param sectionIndex the section from which the item dictionary should be retrieved
/// @return the item dictionary for the specified section and row
- (NSDictionary *)dictionaryForRow:(NSInteger) rowIndex inSection:(NSInteger)sectionIndex;

/// Returns the dictionary containing all section titles.
/// @return a dictionary with all section titles
- (NSDictionary *)getSectionTitles;


@end


@protocol SZMenuVCDelegate <NSObject>

/**
 This function must be implemented by the BTLeftMenuViewControllerDelegate to handle the selection of a menu item,
 for example to switch between view controllers
 @param leftMenuViewController the BTLeftMenuViewController from which the user selected an item
 @param title the title of the item which was selected by the user
 */
- (void)menu:(SZMenuVC*)menu switchToViewControllerWithClassName:(NSString*)className;

@end