//
//  SZMyRequestVC.h
//  Skillz
//
//  Created by Julia Roggatz on 02.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZEntryVO.h"

@interface SZMyRequestVC : UIViewController <UIAlertViewDelegate>

- (id)initWithRequest:(SZEntryVO*)request;

@end
