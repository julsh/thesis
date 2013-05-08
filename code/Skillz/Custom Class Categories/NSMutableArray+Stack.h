//
//  NSMutableArray+Stack.h
//  Skillz
//
//  Created by Julia Roggatz on 31.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <Foundation/Foundation.h>

/** This class category adds additional functionality to a regular NSMutableArray object so it can be used as a stack. 
 */

@interface NSMutableArray (Stack)

/** Pushes and item onto the stack
 @param item The object which to push onto the stack
 */
- (void)push:(id)item;

/** Pops (= removes and returns) an item from the stack
 @return The item that was popped from the stack
 */
- (id)pop;

@end
