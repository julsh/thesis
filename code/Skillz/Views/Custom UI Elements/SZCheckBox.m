//
//  SZCheckBox.m
//  Skillz
//
//  Created by Julia Roggatz on 20.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZCheckBox.h"

@implementation SZCheckBox

@synthesize isChecked = _isChecked;

- (id)init {
	
	self = [super initWithFrame:CGRectMake(0.0, 0.0, 44.0, 44.0)];
    if (self) {
		[self setBackgroundImage:[UIImage imageNamed:@"checkbox_unchecked"] forState:UIControlStateNormal];
		[self setBackgroundImage:[UIImage imageNamed:@"checkbox_checked"] forState:UIControlStateSelected];
		[self setShowsTouchWhenHighlighted:YES];
		[self addTarget:self action:@selector(toggle:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void) toggle:(id)sender {
	self.selected = !self.selected;
}

- (BOOL)isChecked {
	return self.selected;
}

@end
