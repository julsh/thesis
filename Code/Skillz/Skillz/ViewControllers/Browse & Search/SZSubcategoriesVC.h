//
//  SZSubcategoriesVC.h
//  Skillz
//
//  Created by Julia Roggatz on 05.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <UIKit/UIKit.h>

/** This class represents a table view controller displaying a list of all available subcategory for a specified category. Used for browsing feature.
 */
@interface SZSubcategoriesVC : SZTableViewController

/** Creates an instance of the SZSubcategoriesVC with a specified category
 @param category The category for which the table view should display the subcategories.
 */
- (id)initWithCategory:(NSString*)category;

@end
