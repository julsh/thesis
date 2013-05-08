//
//  SZMenuCell.h
//  Skillz
//
//  Created by Julia Roggatz on 25.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MENU_WIDTH		   240.0
#define MENU_CELL_HEIGHT    40.0

/**
 This class representes a cell in the global menu. Used within the table view that belongs to the <SZMenuVC> singleton instance.
 */
@interface SZMenuCell : UITableViewCell

/**
 Creates an instance of the SZMenuCell
 @param reuseIdentifier The identifier for reusing the cell object (instead of having to instanciate it completely new for every cell in the table view).
 @return An instance of the SZMenuCell
 */
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
