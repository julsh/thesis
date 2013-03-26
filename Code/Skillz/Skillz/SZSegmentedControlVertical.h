//
//  SZSegmentedControlVertical.h
//  Skillz
//
//  Created by Julia Roggatz on 25.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SZSegmentedControlVerticalDelegate;

@interface SZSegmentedControlVertical : UIView


/// The object that acts as the delegate of the receiving control.
@property (nonatomic, weak) id <SZSegmentedControlVerticalDelegate> delegate;

- (id)initWithWidth:(CGFloat)width;
- (void)addItemWithText:(NSString*)text isLast:(BOOL)isLast;

@end

@protocol SZSegmentedControlVerticalDelegate <NSObject>

- (void)segmentedControlVertical:(SZSegmentedControlVertical*)control didSelectItemAtIndex:(NSInteger)index;

@end
