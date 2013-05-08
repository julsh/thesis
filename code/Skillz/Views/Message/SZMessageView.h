//
//  SZMessageView.h
//  Skillz
//
//  Created by Julia Roggatz on 22.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 The SZMessageView represents one message within a message thread. It consists of a photo of the message's sender, a label indicated how long ago the message was sent and a speech-bubble like view containing the actual message. Depending on whether the sender of the message is the current user or a different user, the photo of the sender will be either displayed on the left side of the view or on the right side of the view.
 */

typedef enum {
	SZMessageViewPositionRight,
	SZMessageViewPositionLeft
} SZMessageViewPosition;

@interface SZMessageView : UIView

/** 
 Initializes the message view with a message dictionary, a photo of the message's sender and the specified position.
 @param message An `NSDictionary` representing the message
 @param image A `UIImage` object representing a photo of the message's sender
 @param position Specifies how the message should be positioned. Uses the `SZMessageViewPosition` enumerator. Allowed value are:
 
 - `SZMessageViewPositionRight` <- The sender of the message is another user
 - `SZMessageViewPositionLeft`  <- The sender of the message is the current user
 
 @return An instance of SZMessageView
 */
- (id)initWithMessage:(NSDictionary*)message image:(UIImage*)image position:(SZMessageViewPosition)position;

@end
