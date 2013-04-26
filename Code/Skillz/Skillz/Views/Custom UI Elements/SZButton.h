//
//  SZButton.h
//  Skillz
//
//  Created by Julia Roggatz on 21.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZButton : UIButton

typedef enum {
	SZButtonSizeSmall,
	SZButtonSizeMedium,
	SZButtonSizeLarge,
	SZButtonSizeExtraLarge
} SZButtonSize;

typedef enum {
	SZButtonColorPetrol,
	SZButtonColorOrange
} SZButtonColor;

- (id)initWithColor:(SZButtonColor)color size:(SZButtonSize)size width:(CGFloat)width;
- (void)setMultilineTitle:(NSString*)title font:(UIFont*)font lineSpacing:(CGFloat)lineSpacing;
- (void)changeBackgroundColor:(SZButtonColor)color;

@end
