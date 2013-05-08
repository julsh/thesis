//
//  SZForm.h
//  Skillz
//
//  Created by Julia Roggatz on 20.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSKeyboardControls.h"
#import "SZFormFieldVO.h"

#define FORM_PLACEHOLDER @"Placeholder"
#define FORM_INPUT_TYPE @"InputType"
#define INPUT_TYPE_PICKER 1001
#define INPUT_TYPE_PASSWORD 1002
#define PICKER_OPTIONS @"PickerOptions"

@protocol SZFormDelegate;

/** This class is a custom UIView that provides a convenient interface for user to enter differnt kind of data. After the SZForm has been instantiated, any desired number of form fields can be added by calling the <addItem:showsClearButton:isLastItem:> method. Optionally, a toolbar for the keyboard that shows "Previous" and "Next" buttons to switch between fields (only if the form contains more than one field) as well as a "Done" button to dismiss the keyboard can be added by calling the <addKeyboardToolbar> method.

 The SZForm may be assigned a <delegate> object that will be informed about certain events, provided it implements the corresponding methods defined in the <SZFormDelegate> protocol.
 
 _Important:_ 
 SZForms should only be used within a surrounding UIScrollView to avoid unexpected behavior. The SZForm internally takes care about scrolling the scroll view to a certain point in case the field that is currently edited would otherwise be hidden by the keyboard (or picker input view). It will also resize the scroll view's content size according to whether or not the keyboard (or picker input view) is visible to enable proper scrolling functionality at all times. The scroll view doesn't need to be the direct superview of the form, but the form needs to be somehow contained within that scroll view. Set the <scrollContainer> property to the UIScrollView object that contains the form.
 
 */
@interface SZForm : UIView <UITextFieldDelegate, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, BSKeyboardControlsDelegate>

/// @name Properties

/** A dictionary used to store and access the user's inputs. They are stored and retrieved using the key provided by the respective <SZFormFieldVO>s.
 */
@property (nonatomic, strong) NSMutableDictionary* userInputs;

/** The UIScrollView object containing the form. Used to ensure proper scrolling behavior and let the form handle setting scroll view's the content offset in case the field that is currently edited would otherwise be hidden by the keyboard (or picker input view).
 */
@property (nonatomic, strong) UIScrollView* scrollContainer;

/** The object acting as the delegate for the SZForm. Must conform to the <SZFormDelegate> protocol.
 */
@property (nonatomic, weak) id <SZFormDelegate> delegate;

/**
 Indicates whether or not the user is currently using the form.
 */
@property (nonatomic, assign) BOOL isActive;

/// @name Initialization

/**
 Initializes an empty instance of the SZForm with a given width
 @param width The width that the form should have
 @return An empty instance of the SZForm
 */
- (id)initWithWidth:(CGFloat)width;

/**
 Initializes a form object representing a text view (used to input longer texts, for example a message or an entry description.
 @param item The <SZFormFieldVO> representing the text view's properties.
 @param width The desired width for the text view
 @param height The desired height for the text view
 @return An instance of the SZForm, configured with a text view
 */
- (id)initForTextViewWithItem:(SZFormFieldVO*)item width:(CGFloat)width height:(CGFloat)height;

/// @name Configuration

/**
 Adds a field to an existing SZForm instance
 @param item The <SZFormFieldVO> representing the field's properties.
 @param showsClearButton Whether or not the text field should display a button to erase all input
 @param isLast Whether or not the added item is the last item in the form. The form needs to know this because the bottom item will have rounded corners.
 */
- (void)addItem:(SZFormFieldVO*)item showsClearButton:(BOOL)showsClearButton isLastItem:(BOOL)isLast;

/**
 Adds a toolbar to the keyboard that shows "Previous" and "Next" buttons to switch between fields (only if the form contains more than one field) as well as a "Done" button to dismiss the keyboard
 */
- (void)addKeyboardToolbar;

/// @name Accessing and modifying the fields

/**
 Gets the text in a field specified by the index property
 @param index The index of the field from which the text should be retrieved
 @return The text in the field
 */
- (NSString*)textForFieldAtIndex:(NSInteger)index;

/**
 Sets the text for a field specified by the index property
 @param text The text which to apply to the field
 @param index The index of the field to which to apply the text
 */
- (void)setText:(NSString*)text forFieldAtIndex:(NSInteger)index;

/**
 Used to manually change the default width and placement of the text field within the form.
 @param width The new width which to apply to the text field
 @param xInset The new margin between the beginning of the text field and the left edge of the form view
 @param index The index of the field to which the new width and inset should be applied
 */
- (void)setTextFieldWidth:(CGFloat)width xInset:(CGFloat)xInset forFieldAtIndex:(NSInteger)index;

/**
 Used to manually change the height of the text view on a specified index. Can be animated.
 @param height The new height which to apply to the text view
 @param index The index of the field to which the new height should be applied
 @param animated Whether or not the height change should be animated
 */
- (void)setTextViewHeight:(CGFloat)height forTextViewAtIndex:(NSInteger)index animated:(BOOL)animated;

/// @name Updating picker input views

/**
 Updates the selected option in the UIPicker used as the input view of a field with the specified index according to the content of its corresponding text field.
 @param index The index of the UIPicker that should update itself
 */
- (void)updatePickerAtIndex:(NSInteger)index;

/**
 Assigns a new set of options to the UIPicker used as the input view of a field with the specified index
 @param options An array containing the new options
 @param index The index of the UIPicker that the new options should be assigned to
 */
- (void)updatePickerOptions:(NSArray*)options forPickerAtIndex:(NSInteger)index;

/**
 Selects a specified date in the UIDatePicker at the specified index
 @param date The new date that the UIDatePicker should select
 @param index The index of the UIPicker that the new options should be assigned to
 */
- (void)updateDatePickerAtIndex:(NSInteger)index withDate:(NSDate*)date;

/// @name Resigning first responder

/**
 Resigns the current input view (keyboard or picker) and dispatches a completion block when finished
 @param firstResponder The current first responder
 @param completion The block of code which to dispatch when the first responder susccessfully resigned
 */
- (void)resign:(UIView*)firstResponder completion:(void(^)(BOOL finished))completion;

/// @name Convenience functions for address forms

/**
 Creates an SZForm instance that is readily configured for address input
 @param width The width that the form should have
 */
+ (SZForm*)addressFormWithWidth:(CGFloat)width;

/**
 Creates a dictionary from an address form that stores the form's inputs, ready to be saved on the device or sent to the server
 @param addressForm The form from which to retrieve and store the address
 @return A dictionary containing the address that was entered into the form
 */
+ (NSDictionary*)addressDictFromAddressForm:(SZForm*)addressForm;
/**
 Sets the input values on an existing SZForm instance (configured for address input) according to the provided address dictionary.
 @param address A dictionary containing the address that should be set on the form
 */
- (void)setAddress:(NSDictionary*)address;

@end

/** This protocol defines a set of methods that any object acting as a delegate for an <SZForm> instance may implement to receive information about certain events. All of its defined methods are optional, so the delegate is not required to implement any of them, although in that case there would be no point in being a delegate after all :-) Generally, the delegate will want to implement at least one of the defined methods.
 */
@protocol SZFormDelegate <NSObject>

/**
 Tells the delegate that the user confirmed the value of a UIDatePicker input view. The delegate may check if the input is valid and return `YES` or `NO` to tell the <SZForm> instance whether or not the input was accepted
 @param form The <SZForm> instance that sent the event to the delegate
 @param datePicker The UIDatePicker which the user attempts to resign
 */
@optional
- (BOOL)form:(SZForm*)form didConfirmDatePicker:(UIDatePicker*)datePicker;

/**
 Tells the delegate that the user confirmed the value of a UIPicker input view. 
 @param form The <SZForm> instance that sent the event to the delegate
 @param picker The UIPickerView which the user resigned
 */
@optional
- (void)form:(SZForm*)form didConfirmPicker:(UIPickerView*)picker;

/**
 Tells the delegate that the user began editing a form
 @param form The <SZForm> instance which the user activated 
 */
@optional
- (void)formDidBeginEditing:(SZForm*)form;

/**
 Tells the delegate that the user ended editing a form
 @param form The <SZForm> instance which the user resigned from editing
 */
@optional
- (void)formDidEndEditing:(SZForm*)form;

/**
 Tells the delegate that form resigned being the first responder and the input view (keyboard or picker) disappeard from the screen. This is different to the <formDidEndEditing:> function because the <formDidEndEditing:> function is called as soon as the user hits the "Done" button (or taps anywhere on the screen to resign the form), while this function is called only after the input view disappeard from the screen.
 @param form The <SZForm> instance which the user resigned from editing
 */
@optional
- (void)formDidResignFirstResponder:(SZForm *)form;

/**
 Tells the delegate that the value in a certain text field did change
 @param textField The textfield that was changed
 */
@optional
- (void)formInputDidChange:(UITextField*)textField;

@end