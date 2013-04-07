//
//  SZStarsView.h
//  Skillz
//
//  Created by Julia Roggatz on 07.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZStarsView : UIView

- (id)initWithSize:(SZStarViewSize)size;
- (void)setStarsForReviewsArray:(NSArray*)reviews;

@end
