//
//  SZMessageThreadVC.h
//  Skillz
//
//  Created by Julia Roggatz on 22.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 This class represents a message thread (or "conversation") between the current user and another user. The newest message will be displayed on top. If there is an open deal or a deal proposal between the two users, this will be displayed as well. If the message thread references a specific entry, this entry will be displayed at the very top of the conversation for quick access.
 */
@interface SZMessageThreadVC : SZViewController

/** Creates an SZMessageThreadVC instance with a given message thread.
 @param messageThread An array representing the message thread. Needs to contain the messages in form of `NSDictionary` objects. Should be ordered by date.
 */
- (id)initWithMessageThread:(NSArray*)messageThread;

@end
