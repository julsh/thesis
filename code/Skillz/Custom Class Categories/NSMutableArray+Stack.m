//
//  NSMutableArray+Stack.m
//  Skillz
//
//  Created by Julia Roggatz on 31.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "NSMutableArray+Stack.h"

@implementation NSMutableArray (Stack)

- (void)push:(id)item {
    [self addObject:item];
}

- (id)pop {
    id item = nil;
    if ([self count] != 0) {
        item = [self lastObject];
        [self removeLastObject];
    }
    return item;
}

@end
