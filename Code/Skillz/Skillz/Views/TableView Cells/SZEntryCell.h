//
//  SZEntryCell.h
//  Skillz
//
//  Created by Julia Roggatz on 02.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 This class representes an entry cell displayed within the "My Offers" or "My Requests" view. It is used within the table view inside the <SZMyEntriesVC>.
 */
@interface SZEntryCell : UITableViewCell

/**
 The switch used to activate or deactive an entry.
 */
@property (nonatomic, strong) UISwitch* activeSwitch;

@end
