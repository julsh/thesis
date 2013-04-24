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

@interface SZNewMessageVC : UIViewController <SZFormDelegate>

- (id)initWithRecipient:(PFUser*)recipient;
- (id)initWithEntry:(SZEntryObject*)entry;

@end
