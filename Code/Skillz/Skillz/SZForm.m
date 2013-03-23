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
#import "SZUtils.h"

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
@property (nonatomic, strong) NSMutableArray* textFields;
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;

@end

@implementation SZForm

@synthesize userInputs = _userInputs;
@synthesize pickerOptions = _pickerOptions;
@synthesize textFields = _textFields;

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
	[textField setTag:[self.userInputs count]];
	[textField setFont:[SZGlobalConstants fontWithFontType:SZFontRegular size:TEXTFIELD_FONT_SIZE]];
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
		
		// save the array with picker choices in a dictionary
		[self.pickerOptions setValue:[item valueForKey:PICKER_OPTIONS] forKey:[NSString stringWithFormat:@"%i", textField.tag]];
		
		// display a little arrow on the cell
		UIView* arrow = [SZAccessoryArrow largeArrow];
		arrow.center = CGPointMake(bgImage.frame.size.width - arrow.frame.size.width + 5.0, bgImage.frame.size.height / 2);
		[bgImage addSubview:arrow];
		
		UIPickerView* pickerView = [[UIPickerView alloc] init];
		[pickerView setTag:textField.tag];
		[pickerView setDelegate:self];
		
		[textField setInputView:pickerView];
		[pickerView setShowsSelectionIndicator:YES];
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

	[self.textFields addObject:textField];
	[self.userInputs setValue:@"" forKey:[item valueForKey:FORM_PLACEHOLDER]];
	
}

- (void)configureKeyboard {
	[self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:self.textFields]];
    [self.keyboardControls setDelegate:self];
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

- (NSMutableArray*)textFields {
	if (_textFields == nil) {
		_textFields = [[NSMutableArray alloc] init];
	}
	return _textFields;
}


#pragma mark -
#pragma mark Text Field Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.keyboardControls setActiveField:textField];
	CGPoint globalPosition = [textField convertPoint:textField.frame.origin toView:self.superview];
	
	// check if we have to scroll the view in order to keep the field visible when the keyboard appears
	if (118 - globalPosition.y < 0) {
		[UIView animateWithDuration:0.2 animations:^{
			CGRect frame = self.superview.frame; 
			frame.origin.y =  118 - globalPosition.y;
			self.superview.frame = frame;
		}];
	}
	else {
		if (self.superview.frame.origin.y < 0.0) {
			[UIView animateWithDuration:0.2 animations:^{
				CGRect frame = self.superview.frame;
				frame.origin.y = 0.0;
				self.superview.frame = frame;
			}];
		}
	}
	
	// check if input view is picker, set textfield to the first possible choice
	if ([textField.inputView isKindOfClass:[UIPickerView class]]) {
		UIPickerView* pickerView = (UIPickerView*)textField.inputView;
		[self pickerView:pickerView didSelectRow:[pickerView selectedRowInComponent:0] inComponent:0];
	}
}

- (BOOL)textFieldShouldReturn:( UITextField *)textField {
	[textField resignFirstResponder];
	return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	[self.userInputs setValue:textField.text forKey:textField.placeholder];
}

#pragma mark - Keyboard Controls Delegate


- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls
{
    [keyboardControls.activeField resignFirstResponder];
	if (self.superview.frame.origin.y < 0.0) {
		[UIView animateWithDuration:0.2 animations:^{
			CGRect frame = self.superview.frame;
			frame.origin.y = 0.0;
			self.superview.frame = frame;
		}];
	}
}

#pragma mark - Picker View Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	NSArray* options = [self.pickerOptions valueForKey:[NSString stringWithFormat:@"%i", pickerView.tag]];
	return [options count];
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	NSArray* options = [self.pickerOptions valueForKey:[NSString stringWithFormat:@"%i", pickerView.tag]];
	return [options objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	UITextField* textField = [self.textFields objectAtIndex:pickerView.tag];
	NSArray* options = [self.pickerOptions valueForKey:[NSString stringWithFormat:@"%i", pickerView.tag]];
	[textField setText:[options objectAtIndex:row]];
}



@end
