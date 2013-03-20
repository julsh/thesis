//
//  SZForm.m
//  Skillz
//
//  Created by Julia Roggatz on 20.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "SZForm.h"
#import "SZAccessoryArrow.h"

#define FORM_TOP_IMAGE		@"form_top"
#define FORM_MIDDLE_IMAGE	@"form_middle"
#define FORM_BOTTOM_IMAGE	@"form_bottom"
#define FORM_CELL_HEIGHT	40.0

#define TEXTFIELD_FONT_SIZE		18.0
#define TEXTFIELD_SIDE_MARGIN	15.0
#define TEXTFIELD_TOP_MARGIN	 8.0
#define TEXTFIELD_HEIGHT		28.0

@interface SZForm ()

@property (nonatomic, strong) NSMutableDictionary* pickerOptions;

@end

@implementation SZForm

@synthesize userInputs = _userInputs;
@synthesize pickerOptions = _pickerOptions;

- (id)init {
	
	self = [super initWithFrame:CGRectZero];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)addItem:(NSDictionary*)item isLastItem:(BOOL)isLast {
	
	NSAssert(!([self.userInputs count] == 0 && isLast), @"The first item cannot be the last item. The form has to consist of at least two items.");
	
	// setting the background image
	UIImageView* bgImage;
	if ([self.userInputs count] == 0) { // top item
		bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:FORM_TOP_IMAGE]];		
	}
	else {
		if (!isLast) { // middle item
			bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:FORM_MIDDLE_IMAGE]];
		}
		else { // bottom item
			bgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:FORM_BOTTOM_IMAGE]];
		}
	}
	
	// placing the new cell
	CGRect frame;
	frame = bgImage.frame;
	frame.origin.y = [self.userInputs count] * FORM_CELL_HEIGHT;
	bgImage.frame = frame;
	
	// adjusting the form's frame
	frame = self.frame;
	frame.size.height += bgImage.frame.size.height;
	if (bgImage.frame.size.width > frame.size.width) frame.size.width = bgImage.frame.size.width;
	self.frame = frame;
	
	// adding the bgimage to the form
	bgImage.userInteractionEnabled = YES;
	[self addSubview:bgImage];
	
	// setting the textfield
	UITextField* textField = [[UITextField alloc] init];
	[textField setFont:[UIFont fontWithName:FONT_REGULAR size:TEXTFIELD_FONT_SIZE]];
	[textField setPlaceholder:[item valueForKey:FORM_PLACEHOLDER]];
	[textField setDelegate:self];
	textField.layer.shadowOpacity = 1.0;
	textField.layer.shadowRadius = 0.0;
	textField.layer.shadowColor = [UIColor whiteColor].CGColor;
	textField.layer.shadowOffset = CGSizeMake(0.0, 1.0);
	
	// setting the input type
	if ([[item valueForKey:FORM_INPUT_TYPE] intValue] == INPUT_TYPE_PASSWORD) {
		[textField setKeyboardType:UIKeyboardTypeDefault];
		[textField setSecureTextEntry:YES];
	}
	else if ([[item valueForKey:FORM_INPUT_TYPE] intValue] == INPUT_TYPE_PICKER) {
		UIView* arrow = [SZAccessoryArrow largeArrow];
		arrow.center = CGPointMake(bgImage.frame.size.width - arrow.frame.size.width + 5.0, bgImage.frame.size.height / 2);
		[bgImage addSubview:arrow];
		
		UIPickerView* pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 44.0, 320.0, 240.0)];
		pickerView.showsSelectionIndicator = YES;
		pickerView.dataSource = self;
		pickerView.delegate = self;
		pickerView.tag = [self.pickerOptions count];
		[self.pickerOptions setValue:[item valueForKey:PICKER_OPTIONS] forKey:[NSString stringWithFormat:@"%i", pickerView.tag]];
		
		UIActionSheet* inputView = [[UIActionSheet alloc] initWithFrame:CGRectMake(0, 0, 320, 255)];
		UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		doneButton.frame = CGRectMake(320-74, 7, 66, 32);
		[doneButton addTarget:self action:@selector(confirmPicker:) forControlEvents:UIControlEventTouchUpInside];
		
		[inputView addSubview:doneButton];
		[inputView addSubview:pickerView];
		
		
		[textField setInputView:inputView];
																				  
																				  
		
	}
	else {
		[textField setKeyboardType:[[item valueForKey:FORM_INPUT_TYPE] intValue]];
	}
	
	// adjusting the textfield's frame
	frame = textField.frame;
	frame.origin.x = TEXTFIELD_SIDE_MARGIN;
	frame.origin.y = TEXTFIELD_TOP_MARGIN;
	frame.size.width = bgImage.frame.size.width - 2 * TEXTFIELD_SIDE_MARGIN;
	frame.size.height = TEXTFIELD_HEIGHT;
	textField.frame = frame;
	
	// adding the textfield to the cell
	[bgImage addSubview:textField];

	[self.userInputs setValue:@"" forKey:[item valueForKey:FORM_PLACEHOLDER]];
	
}

- (void)showPicker:(id)sender {
	NSLog(@"show picker!");
}

- (NSMutableDictionary*)userInputs {
	if (_userInputs == nil) {
		_userInputs = [[NSMutableDictionary alloc] init];
	}
	return _userInputs;
}

- (NSMutableDictionary*)pickerOptions {
	if (_pickerOptions == nil) {
		_pickerOptions = [[NSMutableDictionary alloc] init];
	}
	return _pickerOptions;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	NSLog(@"begin editing");
}

- (BOOL)textFieldShouldReturn:( UITextField *)textField {
	[textField resignFirstResponder];
	return NO;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	NSString* key = [NSString stringWithFormat:@"%i", pickerView.tag];
	NSArray* options = [self.pickerOptions valueForKey:key];
	return [options count];
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	NSString* key = [NSString stringWithFormat:@"%i", pickerView.tag];
	NSArray* options = [self.pickerOptions valueForKey:key];
	return [options objectAtIndex:row];
}

@end
