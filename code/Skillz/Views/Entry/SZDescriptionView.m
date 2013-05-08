//
//  SZDescriptionView.m
//  Skillz
//
//  Created by Julia Roggatz on 01.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZDescriptionView.h"
#import "UITextView+Shadow.h"

@implementation SZDescriptionView

- (id)initWithDescription:(NSString*)description {
    self = [super initWithFrame:CGRectZero];
    if (self) {
		
		UITextView* textView = [[UITextView alloc] initWithFrame:CGRectMake(10.0, 10.0, 270.0, 10000)];
		[textView setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:12.0]];
		[textView setTextColor:[UIColor darkGrayColor]];
		[textView applyWhiteShadow];
		[textView setText:description];
		[textView setUserInteractionEnabled:NO];
		[textView sizeToFit];
		
		UIImageView* bgImage = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"details_middle2"] resizableImageWithCapInsets:UIEdgeInsetsMake(2.0, 2.0, 1.0, 2.0)]];
		[bgImage setFrame:CGRectMake(0.0, 0.0, 290.0, textView.frame.size.height + 20.0)];
		[self setFrame:bgImage.frame];
		
		[self addSubview:bgImage];
		[self addSubview:textView];
    }
    return self;
	
}


@end
