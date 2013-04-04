//
//  NSMutableArray+Stack.h
//  Skillz
//
//  Created by Julia Roggatz on 31.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Stack)

- (void)push:(id)item;
- (id)pop;

@end
