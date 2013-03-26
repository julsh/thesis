//
//  SZRadioButtonControl.m
//  Skillz
//
//  Created by Julia Roggatz on 25.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZRadioButtonControl.h"
#import "SZUtils.h"

#define BUTTON_WIDTH 44.0
#define LEFT_MARGIN 16.0
#define VERTICAL_SPACING 10.0

@interface SZRadioButtonControl ()

@property (nonatomic, assign) NSInteger choiceCount;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) NSMutableArray* buttons;

@end

@implementation SZRadioButtonControl

@synthesize choiceCount = _choiceCount;
@synthesize selectedIndex = _selectedIndex;
@synthesize buttons = _buttons;

- (id)init
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.choiceCount = 0;
		[self setUserInteractionEnabled:YES];
    }
    return self;
}

- (void)addItemWithView:(UIView*)view {
	
	UIButton* radioButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, self.frame.size.height, 44.0, 44.0)];
	[radioButton setBackgroundImage:[UIImage imageNamed:@"radiobutton"] forState:UIControlStateNormal];
	[radioButton setBackgroundImage:[UIImage imageNamed:@"radiobutton_selected"] forState:UIControlStateDisabled];
	[radioButton setBackgroundImage:[UIImage imageNamed:@"radiobutton_selected"] forState:UIControlStateHighlighted];
	[radioButton setTag:self.choiceCount];
	[radioButton addTarget:self action:@selector(buttonSelected:) forControlEvents:UIControlEventTouchUpInside];
	
	CGRect frame = view.frame;
	frame.origin.x = BUTTON_WIDTH + LEFT_MARGIN;
	frame.origin.y = self.frame.size.height;
	view.frame = frame;
	
	frame = self.frame;
	frame.size.height += MAX(view.frame.size.height, radioButton.frame.size.height) + VERTICAL_SPACING;
	frame.size.width = MAX(BUTTON_WIDTH + LEFT_MARGIN + view.frame.size.width, self.frame.size.width);
	self.frame = frame;
	
	[self addSubview:radioButton];
	[self addSubview:view];
	
	[self.buttons addObject:radioButton];
	
	self.choiceCount++;
}

- (NSMutableArray*)buttons {
	if (_buttons == nil) {
		_buttons = [[NSMutableArray alloc] init];
	}
	return _buttons;
}

- (void)buttonSelected:(UIButton*)sender {
	
	NSInteger tag = sender.tag;
	NSLog(@"button %i selected", tag);
	
	self.selectedIndex = tag;
	for (UIButton* button in self.buttons) {
		if (button.tag != tag) {
			[button setEnabled:YES];
		}
		else {
			[button setEnabled:NO];
		}
	}
	
//	[self.delegate segmentedControlVertical:self didSelectItemAtIndex:self.selectedIndex];
}

@end
