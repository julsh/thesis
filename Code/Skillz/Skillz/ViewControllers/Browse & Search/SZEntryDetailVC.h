//
//  SZEntryDetailVC.h
//  Skillz
//
//  Created by Julia Roggatz on 07.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZEntryVO.h"

@interface SZEntryDetailVC : UIViewController

- (id)initWithEntry:(SZEntryVO*)entry type:(SZEntryType)type;

@end
