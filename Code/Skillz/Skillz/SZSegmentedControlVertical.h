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
@property (nonatomic, assign) NSInteger selectedIndex;

- (id)initWithWidth:(CGFloat)width;
- (void)addItemWithText:(NSString*)text isLast:(BOOL)isLast;
- (void)selectItemWithIndex:(NSInteger)index;

@end

@protocol SZSegmentedControlVerticalDelegate <NSObject>

- (void)segmentedControlVertical:(SZSegmentedControlVertical*)control didSelectItemAtIndex:(NSInteger)index;

@end
