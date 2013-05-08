//
//  SZMyMessagesVC.h
//  Skillz
//
//  Created by Julia Roggatz on 21.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 This class represents a list of all message threads that a user has. Message threads will be grouped by conversation partner with the latest message being the one that is displayed as a teaser within this view.
 */
@interface SZMyMessagesVC : SZViewController <UITableViewDelegate, UITableViewDataSource>

@end
