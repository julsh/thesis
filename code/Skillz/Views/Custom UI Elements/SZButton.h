//
//  SZButton.h
//  Skillz
//
//  Created by Julia Roggatz on 21.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <UIKit/UIKit.h>

/** This class subclasses `UIButton` to create custom buttons that match the app's color scheme. 
 To assign the desired color, the `SZButtonColor` enumerator is used. Buttons come in two different colors:
 
- orange: `SZButtonColorPetrol`
- petrol: `SZButtonColorOrange`
 
 Buttons can have 4 different heights and their width is generally flexible. For the height, the `SZButtonSize` enumerator is used. Available heights are:

- 24px: `SZButtonSizeSmall`
- 32px: `SZButtonSizeMedium`
- 40px: `SZButtonSizeLarge`
- 52px: `SZButtonSizeExtraLarge`
 
 */
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

/** Creates and returns an instance of `SZButton` with a specified color, size and width
 @param color The desired color. Uses the `SZButtonColor` enumerator. Allowed values are:
 
 - `SZButtonColorPetrol`
 - `SZButtonColorOrange`
 
 @param size The desired size (or height) of the button. Uses the `SZButtonSize` enumerator. Allowed values are:
 
 - `SZButtonSizeSmall`
 - `SZButtonSizeMedium`
 - `SZButtonSizeLarge`
 - `SZButtonSizeExtraLarge`
 
 @param width The desired width of the button
 @return A configures instance of the `SZButton`
 */
+ (SZButton*)buttonWithColor:(SZButtonColor)color size:(SZButtonSize)size width:(CGFloat)width;

/** Configures an existing `SZButton` instance to display a multiline title.
 @param title The title which to diplay on the button
 @param font The font which to use for the title
 @param lineSpacing The line spacing to be applied to the title label
 */
- (void)setMultilineTitle:(NSString*)title font:(UIFont*)font lineSpacing:(CGFloat)lineSpacing;

/** Changes the background color of an existing `SZButton` instance
 @param color The new color for the button
 */
- (void)changeBackgroundColor:(SZButtonColor)color;

@end
