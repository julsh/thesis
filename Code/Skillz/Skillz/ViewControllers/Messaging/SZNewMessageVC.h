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


@interface SZNewMessageVC : UIViewController <SZFormDelegate>

- (id)initWithRecipient:(PFUser*)recipient;
- (id)initWithEntry:(SZEntryObject*)entry;

@property (nonatomic, assign) SZMessageType messageType;

@end
