//
//  SZEntryView.h
//  Skillz
//
//  Created by Julia Roggatz on 31.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZEntryObject.h"

@interface SZEntryView : UIView

@property (nonatomic, strong) SZEntryObject* entry;

- (id)initWithEntry:(SZEntryObject*)entry;

@end
