//
//  SZForm.m
//  Skillz
//
//  Created by Julia Roggatz on 20.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "SZForm.h"
#import "SZUtils.h"

#define FORM_TOP_IMAGE			@"form_top"
#define FORM_MIDDLE_IMAGE		@"form_middle"
#define FORM_BOTTOM_IMAGE		@"form_bottom"
#define FORM_ONE_FIELD_IMAGE	@"form_oneField"
#define FORM_CELL_HEIGHT		40.0

#define TEXTFIELD_FONT_SIZE		18.0
#define TEXTFIELD_LEFT_MARGIN	15.0
#define TEXTFIELD_RIGHT_MARGIN   5.0
#define TEXTFIELD_TOP_MARGIN	 8.0
#define TEXTFIELD_HEIGHT		28.0

#define ACCESSORY_ARROW_TAG_BASE 100

@interface SZForm ()

@property (nonatomic, strong) NSMutableArray* fieldVOs;
@property (nonatomic, strong) NSMutableArray* fieldViews;
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;
@property (nonatomic, assign) CGFloat width;

@end

@implementation SZForm

@synthesize userInputs = _userInputs;
@synthesize fieldVOs = _fieldVOs;
@synthesize fieldViews = _fieldViews;
@synthesize width = _width;
@synthesize scrollContainer = _scrollContainer;

- (id)initWithWidth:(CGFloat)width {
	
	self = [super initWithFrame:CGRectZero];
    if (self) {
        self.userInteractionEnabled = YES;
		self.width = width;
		
		CGRect frame = self.frame;
		frame.size.width = width;
		self.frame = frame;
    }
    return self;
}

- (id)initForTextViewWithItem:(SZFormFieldVO*)item width:(CGFloat)width height:(CGFloat)height {
	self = [super initWithFrame:CGRectMake(0.0, 0.0, width, height)];
	if (self) {
		self.userInteractionEnabled = YES;
		self.width = width;
		
		UIImage* bgImage = [[UIImage imageNamed:@"form_textfield"] resizableImageWithCapInsets:UIEdgeInsetsMake(15.0, 15.0, 15.0, 15.0)];
		UIImageView* bgImgView = [[UIImageView alloc] initWithFrame:self.frame];
		[bgImgView setImage:bgImage];
		
		UITextView* textView = [[UITextView alloc] initWithFrame:CGRectMake(self.frame.origin.x + 1.0, self.frame.origin.y + 3.0, self.frame.size.width - 2.0, self.frame.size.height - 6.0)];
		[textView setTag:[self.userInputs count]];
		[textView setSpellCheckingType:UITextSpellCheckingTypeNo];
		[textView setFont:[SZGlobalConstants fontWithFontType:SZFontRegular size:14.0]];
		[textView setTextColor:[SZGlobalConstants darkGray]];
		[textView setBackgroundColor:[UIColor clearColor]];
		[textView setDelegate:self];
		
		[self.fieldViews addObject:textView];
		[self.fieldVOs addObject:item];
		[self.userInputs setValue:@"" forKey:item.key];
		
		[self addSubview:bgImgView];
		[self addSubview:textView];
		
		[self addKeyboardToolbar];
		
	}
	return self;
}

- (void)addItem:(SZFormFieldVO*)item showsClearButton:(BOOL)showsClearButton isLastItem:(BOOL)isLast {
	
	// setting the background image
	UIImageView* bgImage;
	if ([self.userInputs count] == 0) { // top item
		if (!isLast) {
			bgImage = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:FORM_TOP_IMAGE] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 30.0, 0.0, 30.0)]];
		}
		else {
			bgImage = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:FORM_ONE_FIELD_IMAGE] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 30.0, 0.0, 30.0)]];
		}
	}
	else {
		if (!isLast) { // middle item
			bgImage = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:FORM_MIDDLE_IMAGE] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 30.0, 0.0, 30.0)]];
		}
		else { // bottom item
			bgImage = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:FORM_BOTTOM_IMAGE] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 30.0, 0.0, 30.0)]];
		}
	}
	
	// placing the new cell
	CGRect frame;
	frame = bgImage.frame;
	frame.size.width = self.width;
	frame.origin.y = [self.userInputs count] * FORM_CELL_HEIGHT;
	bgImage.frame = frame;
	
	// adjusting the form's frame
	frame = self.frame;
	frame.size.height += bgImage.frame.size.height;
	self.frame = frame;
	
	// setting the textfield
	UITextField* textField = [[UITextField alloc] init];
	[textField setAutocorrectionType:UITextAutocorrectionTypeNo];
	[textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	[textField setTag:[self.userInputs count]];
	[textField setFont:[SZGlobalConstants fontWithFontType:SZFontRegular size:TEXTFIELD_FONT_SIZE]];
	[textField setPlaceholder:item.placeHolderText];
	[textField setDelegate:self];
	[textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
	textField.layer.shadowOpacity = 1.0;
	textField.layer.shadowRadius = 0.0;
	textField.layer.shadowColor = [UIColor whiteColor].CGColor;
	textField.layer.shadowOffset = CGSizeMake(0.0, 1.0);
	
	// if theres only one field, "return" should be "done" since we don't need the toolbar above the keyboard
	if ([self.userInputs count] == 0 && isLast) {
		[textField setReturnKeyType:UIReturnKeyDone];
	}
	
	
	// setting input type
	if (item.inputType == SZFormFieldInputTypeKeyboard) {
		[textField setKeyboardType:item.keyboardType];
		if (item.isPassword) {
			[textField setSecureTextEntry:YES];
		}
		[self.userInputs setValue:@"" forKey:item.key];
	}
	else if (item.inputType == SZFormFieldInputTypePicker) {
		UIPickerView* pickerView = [[UIPickerView alloc] init];
		[pickerView setDelegate:self];
		[pickerView setShowsSelectionIndicator:YES];
		[textField setInputView:pickerView];
		[pickerView setTag:textField.tag];
		
		[self addAccessoryArrowToBackgroundImage:bgImage forTextFieldTag:textField.tag];
		[self.userInputs setValue:@"" forKey:item.key];
		[textField setClearButtonMode:UITextFieldViewModeWhileEditing];
	}
	else if (item.inputType == SZFormFieldInputTypeDatePicker) {
		UIDatePicker* datePicker = [[UIDatePicker alloc] init];
		[datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
		[datePicker setDatePickerMode:item.datePickerMode];
		[datePicker setMinuteInterval:item.datePickerMinuteInterval];
		[datePicker setDate:item.datePickerStartDate];
		[datePicker setTag:textField.tag];
		[textField setInputView:datePicker];		
		[self addAccessoryArrowToBackgroundImage:bgImage forTextFieldTag:textField.tag];
		[self.userInputs setValue:[NSNull null] forKey:item.key];
	}

	if (showsClearButton) {
		[textField setClearButtonMode:UITextFieldViewModeWhileEditing];
	}
	
	// saving the texfield views and the corresponding VOs
	[self.fieldViews addObject:textField];
	[self.fieldVOs addObject:item];

	// adjusting the textfield's frame
	frame = textField.frame;
	frame.origin.x = TEXTFIELD_LEFT_MARGIN;
	frame.origin.y = TEXTFIELD_TOP_MARGIN;
	frame.size.width = bgImage.frame.size.width - TEXTFIELD_LEFT_MARGIN - TEXTFIELD_RIGHT_MARGIN;
	frame.size.height = TEXTFIELD_HEIGHT;
	textField.frame = frame;

	bgImage.userInteractionEnabled = YES;
	[bgImage addSubview:textField];
	[self addSubview:bgImage];
	
}

- (void)addKeyboardToolbar {
	[self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:self.fieldViews]];
    [self.keyboardControls setDelegate:self];
}

- (void)addAccessoryArrowToBackgroundImage:(UIImageView*)bgImage forTextFieldTag:(NSInteger)tag; {
	
	UIImageView* arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accessory_arrow"]];
	arrow.tag = ACCESSORY_ARROW_TAG_BASE + tag;
	arrow.center = CGPointMake(bgImage.frame.size.width - arrow.frame.size.width + 5.0, bgImage.frame.size.height / 2);
	[bgImage addSubview:arrow];
}

- (NSMutableDictionary*)userInputs {
	if (_userInputs == nil) {
		_userInputs = [[NSMutableDictionary alloc] init];
	}
	return _userInputs;
}

- (NSMutableArray*)fieldVOs {
	if (_fieldVOs == nil) {
		_fieldVOs = [[NSMutableArray alloc] init];
	}
	return _fieldVOs;
}

- (NSMutableArray*)fieldViews {
	if (_fieldViews == nil) {
		_fieldViews = [[NSMutableArray alloc] init];
	}
	return _fieldViews;
}

- (NSString*)textForFieldAtIndex:(NSInteger)index; {
	UIView* field = [self.fieldViews objectAtIndex:index];
	if ([field isKindOfClass:[UITextField class]]) {
		return ((UITextField *)field).text;
	}
	else return @"";
}

- (void)setText:(NSString*)text forFieldAtIndex:(NSInteger)index {
	UIView* field = [self.fieldViews objectAtIndex:index];
	if ([field isKindOfClass:[UITextField class]]) {
		[(UITextField *)field setText:text];
	}
	else if ([field isKindOfClass:[UITextView class]]) {
		[(UITextView *)field setText:text];
	}
}

- (void)setTextFieldWidth:(CGFloat)width xInset:(CGFloat)xInset forFieldAtIndex:(NSInteger)index {
	UIView* field = [self.fieldViews objectAtIndex:index];
	CGRect frame = field.frame;
	frame.origin.x -= xInset;
	frame.size.width = width;
	field.frame = frame;
}

- (void)setTextViewHeight:(CGFloat)height forTextViewAtIndex:(NSInteger)index animated:(BOOL)animated {
	UIView* field = [self.fieldViews objectAtIndex:index];
	if ([field isKindOfClass:[UITextView class]]) {
		UIView* parentView = [field superview];
		UIView* backgroundView = [[parentView subviews] objectAtIndex:0];
		if (!animated) {
			[backgroundView setFrame:CGRectMake(backgroundView.frame.origin.x,
												backgroundView.frame.origin.y,
												backgroundView.frame.size.width,
												height)];
			[field setFrame:CGRectMake(field.frame.origin.x,
									   field.frame.origin.y,
									   field.frame.size.width,
									   height - 6.0)];
		}
		else {
			[UIView animateWithDuration:0.3 animations:^{
				[backgroundView setFrame:CGRectMake(backgroundView.frame.origin.x,
													backgroundView.frame.origin.y,
													backgroundView.frame.size.width,
													height)];
				[field setFrame:CGRectMake(field.frame.origin.x,
										   field.frame.origin.y,
										   field.frame.size.width,
										   height - 6.0)];
			} completion:nil];
		}
	}
}

- (void)resign:(UIView*)firstResponder completion:(void(^)(BOOL finished))completionBlock {
	
	self.isActive = NO;
		
	if (firstResponder) {
		[firstResponder resignFirstResponder];
	}
	else {
		for (UIView* subview in [self fieldViews]) {
			if (subview.isFirstResponder) {
				[subview resignFirstResponder];
			}
		}
	}
	[UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		[self.scrollContainer setContentOffset:CGPointMake(0.0, self.scrollContainer.contentSize.height - 416.0)];
	} completion:^(BOOL finished) {
		[self.scrollContainer setFrame:CGRectMake(self.scrollContainer.frame.origin.x, self.scrollContainer.frame.origin.y, 320.0, 416.0)];
		
		if (completionBlock) {
			dispatch_async(dispatch_get_main_queue(), ^{
				completionBlock(YES);
			});
		}
		
		if (self.delegate && [self.delegate respondsToSelector:@selector(formDidResignFirstResponder:)]) {
			[self.delegate formDidResignFirstResponder:self];
		}
	}];
}

#pragma mark - Text View Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
	
	if (!self.isActive) {
		self.isActive = YES;
		
		if ([self.delegate respondsToSelector:@selector(formDidBeginEditing:)]) {
			[self.delegate formDidBeginEditing:self];
		}
		
		CGFloat viewSize = self.keyboardControls ? 160.0 : 204.0;
		
		CGPoint globalPosition = [textView convertPoint:textView.frame.origin toView:self.scrollContainer];
		[UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
			[self.scrollContainer setContentOffset:CGPointMake(0.0, globalPosition.y - 15.0)];
		} completion:^(BOOL finished) {
			[self.scrollContainer setFrame:CGRectMake(self.scrollContainer.frame.origin.x, self.scrollContainer.frame.origin.y, 320.0, viewSize)];
		}];
	}
	
	[self.keyboardControls setActiveField:textView];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
	if ([self.delegate respondsToSelector:@selector(formDidEndEditing:)]) {
		[self.delegate formDidEndEditing:self];
	}
	
	SZFormFieldVO* fieldVO = [self.fieldVOs objectAtIndex:textView.tag];
	[self.userInputs setValue:textView.text forKey:fieldVO.key];
}

#pragma mark - Text Field Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	
	if (!self.isActive) {
		self.isActive = YES;
		
		if ([self.delegate respondsToSelector:@selector(formDidBeginEditing:)]) {
			[self.delegate formDidBeginEditing:self];
		}
		
		CGFloat threshold = 120.0;
		CGFloat viewSize = self.keyboardControls ? 160.0 : 204.0;
		
		CGPoint globalPosition = [textField convertPoint:textField.frame.origin toView:self.scrollContainer];
		[UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
			if (globalPosition.y > self.scrollContainer.contentOffset.y + threshold) {
				[self.scrollContainer setContentOffset:CGPointMake(0.0, globalPosition.y - threshold)];
			}
		} completion:^(BOOL finished) {
			[self.scrollContainer setFrame:CGRectMake(self.scrollContainer.frame.origin.x, self.scrollContainer.frame.origin.y, 320.0, viewSize)];
		}];
	}
	
    [self.keyboardControls setActiveField:textField];

	
	SZFormFieldVO* fieldVO = [self.fieldVOs objectAtIndex:textField.tag];
	
	// check if input view is picker, set textfield to the first possible choice
	if ([textField.inputView isKindOfClass:[UIPickerView class]]) {
		[self updatePickerAtIndex:textField.tag];
		UIView* arrow = [self viewWithTag:ACCESSORY_ARROW_TAG_BASE + textField.tag];
		[arrow setHidden:YES];
		
	}
	else if ([textField.inputView isKindOfClass:[UIDatePicker class]]) {
		UIDatePicker* datePicker = (UIDatePicker*)textField.inputView;
		if ([[self.userInputs valueForKey:fieldVO.key] isKindOfClass:[NSDate class]]) {
			NSLog(@"date aready there");
			[datePicker setDate:[self.userInputs valueForKey:fieldVO.key] animated:NO];
		}
		else {
			NSLog(@"setting date new");
			[datePicker setDate:[SZUtils rightNowRoundedUp] animated:NO];
		}
		[self datePickerValueChanged:datePicker];
		
		UIView* arrow = [self viewWithTag:ACCESSORY_ARROW_TAG_BASE + textField.tag];
		[arrow setHidden:YES];
	}
}

- (BOOL)textFieldShouldReturn:( UITextField *)textField {
	
	[self resign:textField completion:nil];
	return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	
	
	SZFormFieldVO* fieldVO = [self.fieldVOs objectAtIndex:textField.tag];
	
	if ([textField.inputView isKindOfClass:[UIDatePicker class]]) {
		
		if (![textField.text isEqualToString:@""]) {
			[self.userInputs setValue:[((UIDatePicker*)textField.inputView) date] forKey:fieldVO.key];
		}
		UIView* arrow = [self viewWithTag:ACCESSORY_ARROW_TAG_BASE + textField.tag];
		[arrow setHidden:NO];
	}
	else if ([textField.inputView isKindOfClass:[UIPickerView class]]) {
		
		NSString* oldInput = [self.userInputs valueForKey:fieldVO.key];
		
		[self.userInputs setValue:textField.text forKey:fieldVO.key];
		
		if (![oldInput isEqualToString:textField.text] && self.delegate && [self.delegate respondsToSelector:@selector(form:didConfirmPicker:)]) {
			[self.delegate form:self didConfirmPicker:(UIPickerView*)textField.inputView];
		}
		
		UIView* arrow = [self viewWithTag:ACCESSORY_ARROW_TAG_BASE + textField.tag];
		[arrow setHidden:NO];
	}
	else {
		[self.userInputs setValue:textField.text forKey:fieldVO.key];
	}
			
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
	
	
	if ([textField.inputView isKindOfClass:[UIDatePicker class]]) {
		
		UIDatePicker* datePicker = (UIDatePicker*)textField.inputView;
		SZFormFieldVO* fieldVO = [self.fieldVOs objectAtIndex:datePicker.tag];
		[self.userInputs setValue:[NSNull null] forKey:fieldVO.key];
		[textField setText:@""];
		[self keyboardControlsDonePressed:self.keyboardControls];
		return NO;
	}
	else if ([textField.inputView isKindOfClass:[UIPickerView class]]) {
		
		UIPickerView* pickerView = (UIPickerView*)textField.inputView;
		[pickerView selectRow:0 inComponent:0 animated:NO];
		SZFormFieldVO* fieldVO = [self.fieldVOs objectAtIndex:pickerView.tag];
		[self.userInputs setValue:@"" forKey:fieldVO.key];
		[textField setText:@""];
		[self keyboardControlsDonePressed:self.keyboardControls];
		return NO;
	}
	return YES;
}

- (void)textFieldDidChange:(UITextField*)textField {
	if ([self.delegate respondsToSelector:@selector(formInputDidChange:)]) {
		[self.delegate performSelector:@selector(formInputDidChange:) withObject:textField];
	}
}

#pragma mark - Keyboard Controls Delegate


- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls
{
//	BOOL isValid = YES;
//	
//	if ([keyboardControls.activeField.inputView isKindOfClass:[UIDatePicker class]]) {
//		if (self.delegate && [self.delegate respondsToSelector:@selector(form:didConfirmDatePicker:)]) {
//			isValid = [self.delegate form:self didConfirmDatePicker:(UIDatePicker*)keyboardControls.activeField.inputView];
//		}
//	}
//	if (isValid) {
		
		[self resign:keyboardControls.activeField completion:nil];
		
//	}
}


#pragma mark - Picker View Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	SZFormFieldVO* fieldVO = [self.fieldVOs objectAtIndex:pickerView.tag];
	return [fieldVO.pickerOptions count];
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	SZFormFieldVO* fieldVO = [self.fieldVOs objectAtIndex:pickerView.tag];
	return [fieldVO.pickerOptions objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	UITextField* textField = [self.fieldViews objectAtIndex:pickerView.tag];
	SZFormFieldVO* fieldVO = [self.fieldVOs objectAtIndex:pickerView.tag];
	NSString* text = [fieldVO.pickerOptions objectAtIndex:row];
	[textField setText:text];
}

- (void)updatePickerAtIndex:(NSInteger)index {
	SZFormFieldVO* fieldVO = [self.fieldVOs objectAtIndex:index];
	UITextField* textField = [self.fieldViews objectAtIndex:index];
	UIPickerView* picker = (UIPickerView*)textField.inputView;
	int optionIndex = [fieldVO.pickerOptions indexOfObject:textField.text];
	if (optionIndex != NSNotFound && optionIndex < [picker numberOfRowsInComponent:0]) {
		[picker selectRow:optionIndex inComponent:0 animated:NO];
	}
	else {
		[picker selectRow:0 inComponent:0 animated:NO];
		[self pickerView:picker didSelectRow:0 inComponent:0];
	}
}

- (void)updatePickerOptions:(NSArray*)options forPickerAtIndex:(NSInteger)index {
	SZFormFieldVO* fieldVO = [self.fieldVOs objectAtIndex:index];
	UITextField* textField = [self.fieldViews objectAtIndex:index];
	UIPickerView* picker = (UIPickerView*)textField.inputView;
	fieldVO.pickerOptions = options;
	[textField setText:@""];
	[picker selectRow:0 inComponent:0 animated:NO];
	[picker reloadComponent:0];
}

#pragma mark - Date Picker events

- (void)datePickerValueChanged:(UIDatePicker*)datePicker {
	
	UITextField* textField = [self.fieldViews objectAtIndex:datePicker.tag];
	[textField setText:[SZUtils formattedDateFromDate:[datePicker date]]];
}

- (void)updateDatePickerAtIndex:(NSInteger)index withDate:(NSDate*)date {
	UITextField* textField = [self.fieldViews objectAtIndex:index];
	UIDatePicker* datePicker = (UIDatePicker*)textField.inputView;
	[datePicker setDate:date];
	[self datePickerValueChanged:datePicker];
}

#pragma mark - convenience methods for commonly used form compositions

+ (SZForm*)addressFormWithWidth:(CGFloat)width {
	SZForm* addressForm = [[SZForm alloc] initWithWidth:width];
	SZFormFieldVO* streetField = [SZFormFieldVO formFieldValueObjectForTextWithKey:@"streetAddress"
																   placeHolderText:@"Street Address"
																	  keyboardType:UIKeyboardTypeDefault];
	SZFormFieldVO* cityField = [SZFormFieldVO formFieldValueObjectForTextWithKey:@"city"
																 placeHolderText:@"City"
																	keyboardType:UIKeyboardTypeDefault];
	SZFormFieldVO* zipCodeField = [SZFormFieldVO formFieldValueObjectForTextWithKey:@"zipCode"
																	placeHolderText:@"ZIP code"
																	   keyboardType:UIKeyboardTypeNumbersAndPunctuation];
	SZFormFieldVO* stateField = [SZFormFieldVO formFieldValueObjectForPickerWithKey:@"state"
																	placeHolderText:@"State"
																	  pickerOptions:[SZGlobalConstants statesArray]];
	[addressForm  addItem:streetField showsClearButton:YES isLastItem:NO];
	[addressForm  addItem:cityField showsClearButton:YES isLastItem:NO];
	[addressForm  addItem:zipCodeField showsClearButton:YES isLastItem:NO];
	[addressForm  addItem:stateField showsClearButton:YES isLastItem:YES];
	[addressForm  addKeyboardToolbar];
	
	return addressForm;
}

+ (NSDictionary*)addressDictFromAddressForm:(SZForm*)addressForm {
	NSMutableDictionary* address = [[NSMutableDictionary alloc] init];
	[address setValue:[addressForm.userInputs valueForKey:@"streetAddress"] forKey:@"streetAddress"];
	[address setValue:[addressForm.userInputs valueForKey:@"city"] forKey:@"city"];
	[address setValue:[addressForm.userInputs valueForKey:@"zipCode"] forKey:@"zipCode"];
	[address setValue:[addressForm.userInputs valueForKey:@"state"] forKey:@"state"];
	return address;
}

- (void)setAddress:(NSDictionary*)address {
	[self.userInputs setValue:[address valueForKey:@"streetAddress"] forKey:@"streetAddress"];
	[self.userInputs setValue:[address valueForKey:@"city"] forKey:@"city"];
	[self.userInputs setValue:[address valueForKey:@"zipCode"] forKey:@"zipCode"];
	[self.userInputs setValue:[address valueForKey:@"state"] forKey:@"state"];
	[self setText:[address valueForKey:@"streetAddress"] forFieldAtIndex:0];
	[self setText:[address valueForKey:@"city"] forFieldAtIndex:1];
	[self setText:[address valueForKey:@"zipCode"] forFieldAtIndex:2];
	[self setText:[address valueForKey:@"state"] forFieldAtIndex:3];
}

@end
