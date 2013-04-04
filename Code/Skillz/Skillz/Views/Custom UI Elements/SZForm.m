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
#import "SZAddressVO.h"

#define FORM_TOP_IMAGE			@"form_top"
#define FORM_MIDDLE_IMAGE		@"form_middle"
#define FORM_BOTTOM_IMAGE		@"form_bottom"
#define FORM_ONE_FIELD_IMAGE	@"form_oneField"
#define FORM_CELL_HEIGHT		40.0

#define TEXTFIELD_FONT_SIZE		18.0
#define TEXTFIELD_SIDE_MARGIN	15.0
#define TEXTFIELD_TOP_MARGIN	 8.0
#define TEXTFIELD_HEIGHT		28.0

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
		
		[self configureKeyboard];
		
	}
	return self;
}

- (void)addItem:(SZFormFieldVO*)item isLastItem:(BOOL)isLast {
	
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
	[textField setTag:[self.userInputs count]];
	[textField setFont:[SZGlobalConstants fontWithFontType:SZFontRegular size:TEXTFIELD_FONT_SIZE]];
	[textField setPlaceholder:item.placeHolderText];
	[textField setDelegate:self];
	textField.layer.shadowOpacity = 1.0;
	textField.layer.shadowRadius = 0.0;
	textField.layer.shadowColor = [UIColor whiteColor].CGColor;
	textField.layer.shadowOffset = CGSizeMake(0.0, 1.0);
	
	// if theres only one field, "return" should be "done" since we don't need the toolbar above the keyboard
	if ([self.userInputs count] == 0 && isLast) {
		[textField setReturnKeyType:UIReturnKeyDone];
	}
	
	
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
		
		[self addAccessoryArrowToBackgroundImage:bgImage];
		[self.userInputs setValue:@"" forKey:item.key];
	}
	else if (item.inputType == SZFormFieldInputTypeDatePicker) {
		UIDatePicker* datePicker = [[UIDatePicker alloc] init];
		[datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
		[datePicker setDatePickerMode:item.datePickerMode];
		[datePicker setMinuteInterval:item.datePickerMinuteInterval];
		[datePicker setDate:item.datePickerStartDate];
		[datePicker setTag:textField.tag];
		[textField setInputView:datePicker];
		
		[self addAccessoryArrowToBackgroundImage:bgImage];
		[self.userInputs setValue:[NSNull null] forKey:item.key];
	}

	// saving the texfield views and the corresponding VOs
	[self.fieldViews addObject:textField];
	[self.fieldVOs addObject:item];

	// adjusting the textfield's frame
	frame = textField.frame;
	frame.origin.x = TEXTFIELD_SIDE_MARGIN;
	frame.origin.y = TEXTFIELD_TOP_MARGIN;
	frame.size.width = bgImage.frame.size.width - 2 * TEXTFIELD_SIDE_MARGIN;
	frame.size.height = TEXTFIELD_HEIGHT;
	textField.frame = frame;

	bgImage.userInteractionEnabled = YES;
	[bgImage addSubview:textField];
	[self addSubview:bgImage];
	
}

- (void)configureKeyboard {
	[self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:self.fieldViews]];
    [self.keyboardControls setDelegate:self];
}

- (void)addAccessoryArrowToBackgroundImage:(UIImageView*)bgImage {
	
	UIView* arrow = [SZAccessoryArrow largeArrow];
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

- (void)setText:(NSString*)text forFieldAtIndex:(NSInteger)index {
	UIView* field = [self.fieldViews objectAtIndex:index];
	if ([field isKindOfClass:[UITextField class]]) {
		[(UITextField *)field setText:text];
	}
	else if ([field isKindOfClass:[UITextView class]]) {
		[(UITextView *)field setText:text];
	}
}

#pragma mark - Text View Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
	
	[self.keyboardControls setActiveField:textView];
	CGPoint globalPosition = [textView.superview convertPoint:textView.frame.origin toView:self.scrollContainer];
	
	[UIView animateWithDuration:0.2 animations:^{
			CGRect frame = self.scrollContainer.frame;
			frame.origin.y = - globalPosition.y + 12.0;
			self.scrollContainer.frame = frame;
	}];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
	SZFormFieldVO* fieldVO = [self.fieldVOs objectAtIndex:textView.tag];
	[self.userInputs setValue:textView.text forKey:fieldVO.key];
}

#pragma mark - Text Field Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	if ([self.delegate respondsToSelector:@selector(formDidBeginEditing:)]) {
		[self.delegate formDidBeginEditing:self];
	}
	
    [self.keyboardControls setActiveField:textField];
	CGPoint globalPosition = [textField convertPoint:textField.frame.origin toView:self.scrollContainer];
	
	// check if we have to scroll the view in order to keep the field visible when the keyboard appears
	if (118 - globalPosition.y < 0) {
		[UIView animateWithDuration:0.2 animations:^{
			CGRect frame = self.scrollContainer.frame; 
			frame.origin.y =  118 - globalPosition.y;
			self.scrollContainer.frame = frame;
		}];
	}
	else {
		if (self.scrollContainer.frame.origin.y < 0.0) {
			[UIView animateWithDuration:0.2 animations:^{
				CGRect frame = self.scrollContainer.frame;
				frame.origin.y = 0.0;
				self.scrollContainer.frame = frame;
			}];
		}
	}
	
	SZFormFieldVO* fieldVO = [self.fieldVOs objectAtIndex:textField.tag];
	
	// check if input view is picker, set textfield to the first possible choice
	if ([textField.inputView isKindOfClass:[UIPickerView class]]) {
		UIPickerView* pickerView = (UIPickerView*)textField.inputView;
		[self pickerView:pickerView didSelectRow:[pickerView selectedRowInComponent:0] inComponent:0];
	}
	else if ([textField.inputView isKindOfClass:[UIDatePicker class]]) {
		UIDatePicker* datePicker = (UIDatePicker*)textField.inputView;
		if ([[self.userInputs valueForKey:fieldVO.key] isKindOfClass:[NSDate class]]) {
			[datePicker setDate:[self.userInputs valueForKey:fieldVO.key] animated:NO];
		}
		else {
			[datePicker setDate:[SZUtils rightNowRoundedUp] animated:NO];
		}
		[self datePickerValueChanged:datePicker];
	}
}

- (BOOL)textFieldShouldReturn:( UITextField *)textField {
	[textField resignFirstResponder];
	[self checkForScrollUp];
	return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	
	SZFormFieldVO* fieldVO = [self.fieldVOs objectAtIndex:textField.tag];
	
	if ([textField.inputView isKindOfClass:[UIDatePicker class]]) {
		[self.userInputs setValue:[((UIDatePicker*)textField.inputView) date] forKey:fieldVO.key];
	}
	else if ([textField.inputView isKindOfClass:[UIPickerView class]]) {
		
		NSString* oldInput = [self.userInputs valueForKey:fieldVO.key];
		
		[self.userInputs setValue:textField.text forKey:fieldVO.key];
		
		if (![oldInput isEqualToString:textField.text] && self.delegate && [self.delegate respondsToSelector:@selector(form:didConfirmPicker:)]) {
			[self.delegate form:self didConfirmPicker:(UIPickerView*)textField.inputView];
		}
	}
	else {
		[self.userInputs setValue:textField.text forKey:fieldVO.key];
	}
			
}

- (void)checkForScrollUp {
	if (self.scrollContainer.frame.origin.y < 0.0) {
		[UIView animateWithDuration:0.2 animations:^{
			CGRect frame = self.scrollContainer.frame;
			frame.origin.y = 0.0;
			self.scrollContainer.frame = frame;
		}];
	}
}

#pragma mark - Keyboard Controls Delegate


- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls
{
	BOOL isValid = YES;
	
	if ([keyboardControls.activeField.inputView isKindOfClass:[UIDatePicker class]]) {
		if (self.delegate && [self.delegate respondsToSelector:@selector(form:didConfirmDatePicker:)]) {
			isValid = [self.delegate form:self didConfirmDatePicker:(UIDatePicker*)keyboardControls.activeField.inputView];
		}
	}
	if (isValid) {
		[keyboardControls.activeField resignFirstResponder];
		[self checkForScrollUp];
	}
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
	if ([text isEqualToString:@"(no subcategory)"]) text = @"";
	[textField setText:text];
}

- (void)updatePickerAtIndex:(NSInteger)index {
	SZFormFieldVO* fieldVO = [self.fieldVOs objectAtIndex:index];
	UITextField* textField = [self.fieldViews objectAtIndex:index];
	UIPickerView* picker = (UIPickerView*)textField.inputView;
	int optionIndex = [fieldVO.pickerOptions indexOfObject:textField.text];
	if (optionIndex != NSNotFound && optionIndex < [picker numberOfRowsInComponent:0]) [picker selectRow:optionIndex inComponent:0 animated:NO];
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
																	  pickerOptions:[NSArray arrayWithObjects:@"California", @"Texas", @"Florida", @"Oregon", nil]]; // TODO real states
	[addressForm  addItem:streetField isLastItem:NO];
	[addressForm  addItem:cityField isLastItem:NO];
	[addressForm  addItem:zipCodeField isLastItem:NO];
	[addressForm  addItem:stateField isLastItem:YES];
	[addressForm  configureKeyboard];
	
	return addressForm;
}

+ (SZAddressVO*)addressVOfromAddressForm:(SZForm*)addressForm {
	SZAddressVO* address = [[SZAddressVO alloc] init];
	address.streetAddress = [addressForm.userInputs valueForKey:@"streetAddress"];
	address.city = [addressForm.userInputs valueForKey:@"city"];
	address.zipCode = [addressForm.userInputs valueForKey:@"zipCode"];
	address.state = [addressForm.userInputs valueForKey:@"state"];
	return address;
}

@end
