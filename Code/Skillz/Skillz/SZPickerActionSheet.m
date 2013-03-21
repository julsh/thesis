//
//  SZPickerActionSheet.m
//  Skillz
//
//  Created by Julia Roggatz on 20.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZPickerActionSheet.h"

@interface SZPickerActionSheet ()

@property (nonatomic, strong) NSArray* choices;
@property (nonatomic, strong) UIPickerView* pickerView;

@end

@implementation SZPickerActionSheet

@synthesize choices = _choices;
@synthesize pickerView = _pickerView;
@synthesize choice = _choice;

- (id)initWithChoices:(NSArray*)choices {
	
	self = [super initWithTitle:nil delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
	if (self) {
        self.choices = choices;
		
		UIView *masterView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 284.0)];
		
		UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 44.0)];
		UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
		UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(confirmPicker:)];
		[pickerToolbar setBarStyle:UIBarStyleBlackTranslucent];
		[pickerToolbar setItems:[NSArray arrayWithObjects:flexSpace, doneButton, nil]];
		
		[masterView addSubview:pickerToolbar];
		[masterView addSubview:self.pickerView];
		
		[self setActionSheetStyle:UIActionSheetStyleAutomatic];
		[self addSubview:masterView];
    }
    return self;
}

- (UIPickerView*)pickerView {
	if (_pickerView == nil) {
		_pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 40.0, 320.0, 240.0)];
		_pickerView.showsSelectionIndicator = YES;
		_pickerView.dataSource = self;
		_pickerView.delegate = self;
	}
	return _pickerView;
}

- (void)confirmPicker:(id)sender {
	int selectedRow = [self.pickerView selectedRowInComponent:0];
	self.choice = [self.choices objectAtIndex:selectedRow];
	[self dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)scrollToIndex:(NSInteger)index {
	[self.pickerView selectRow:index inComponent:0 animated:NO];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return [self.choices count];
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [self.choices objectAtIndex:row];
}


@end
