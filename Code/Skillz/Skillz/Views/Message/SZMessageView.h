//
//  SZMessageView.h
//  Skillz
//
//  Created by Julia Roggatz on 22.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	SZMessageViewPositionRight,
	SZMessageViewPositionLeft
} SZMessageViewPosition;

@interface SZMessageView : UIView

- (id)initWithMessage:(NSDictionary*)message image:(UIImage*)image position:(SZMessageViewPosition)position;

@end
