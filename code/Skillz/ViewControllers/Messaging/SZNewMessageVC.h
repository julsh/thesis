//
//  SZNewMessageVC.h
//  Skillz
//
//  Created by Julia Roggatz on 20.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <Parse/Parse.h>
#import <UIKit/UIKit.h>
#import "SZForm.h"
#import "SZEntryObject.h"

typedef enum {
	SZMessageTypeFirstContact,
	SZMessageTypeReply
} SZMessageType;

/**
 This class represents a view that lets the user write and send a message to a specific recipient. The message can have a deal proposal attached to it.
 */
@interface SZNewMessageVC : SZViewController <SZFormDelegate>

/**
 Creates and SZNewMessageVC instance for a message with a specified recipient.
 @param recipient The recepient of the message
 @return An instance of SZNewMessageVC
 */
- (id)initWithRecipient:(PFUser*)recipient;

/**
 Creates and SZNewMessageVC instance for a message that refers to a specific entry.
 The message recipient will automatically be the owner of that entry.
 @param entry The <SZEntryObject> that the message refers to
 @return An instance of SZNewMessageVC
 */
- (id)initWithEntry:(SZEntryObject*)entry;

@property (nonatomic, assign) SZMessageType messageType;

@end
