//
//  SZTestVC.m
//  Skillz
//
//  Created by Julia Roggatz on 19.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <Parse/Parse.h>

#import "SZTestVC.h"
#import "SZTestNC.h"
#import "SZCheckBox.h"
#import "SZForm.h"

@interface SZTestVC ()

@property (nonatomic, strong) UITextField* titleField;
@property (nonatomic, strong) UITextView* descriptionField;
@property (nonatomic, strong) SZCheckBox* checkBox;

@end

@implementation SZTestVC

@synthesize titleField = _titleField;
@synthesize descriptionField = _descriptionField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
	
    [super viewDidLoad];
	
	[self.view setBackgroundColor:[UIColor lightGrayColor]];
	
//	UIButton* postButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//	[postButton setTitle:@"Post this shit!" forState:UIControlStateNormal];
//	[postButton setFrame:CGRectMake(10.0, 400.0, 300.0, 40.0)];
//	[postButton addTarget:self action:@selector(postThisShit:) forControlEvents:UIControlEventTouchUpInside];
//	
//	[self.view addSubview:self.titleField];
//	[self.view addSubview:self.descriptionField];
//	[self.view addSubview:postButton];
//
//	self.checkBox = [[SZCheckBox alloc] init];
//	self.checkBox.center = CGPointMake(30.0, 250.0);
//	[self.view addSubview:self.checkBox];
	
	SZForm* form = [[SZForm alloc] init];
	
	NSDictionary* dict;
	dict = [NSDictionary dictionaryWithObjects:
			[NSArray arrayWithObjects:@"First Name", [NSNumber numberWithInt:UIKeyboardTypeDefault], nil] forKeys:
			[NSArray arrayWithObjects:FORM_PLACEHOLDER, FORM_INPUT_TYPE, nil]];
	[form addItem:dict isLastItem:NO];
	
	dict = [NSDictionary dictionaryWithObjects:
			[NSArray arrayWithObjects:@"Last Name", [NSNumber numberWithInt:UIKeyboardTypeDefault], nil] forKeys:
			[NSArray arrayWithObjects:FORM_PLACEHOLDER, FORM_INPUT_TYPE, nil]];
	[form addItem:dict isLastItem:NO];
	
	dict = [NSDictionary dictionaryWithObjects:
			[NSArray arrayWithObjects:@"ZIP code", [NSNumber numberWithInt:UIKeyboardTypeDecimalPad], nil] forKeys:
			[NSArray arrayWithObjects:FORM_PLACEHOLDER, FORM_INPUT_TYPE, nil]];
	[form addItem:dict isLastItem:NO];
	
	NSArray* states = [NSArray arrayWithObjects:@"California", @"Texas", @"Florida", @"Oregon", nil];
	dict = [NSDictionary dictionaryWithObjects:
			[NSArray arrayWithObjects:@"State", [NSNumber numberWithInt:INPUT_TYPE_PICKER], states, nil] forKeys:
			[NSArray arrayWithObjects:FORM_PLACEHOLDER, FORM_INPUT_TYPE, PICKER_OPTIONS, nil]];
	[form addItem:dict isLastItem:NO];
	
	dict = [NSDictionary dictionaryWithObjects:
			[NSArray arrayWithObjects:@"Email", [NSNumber numberWithInt:UIKeyboardTypeEmailAddress], nil] forKeys:
			[NSArray arrayWithObjects:FORM_PLACEHOLDER, FORM_INPUT_TYPE, nil]];
	[form addItem:dict isLastItem:NO];
	
	dict = [NSDictionary dictionaryWithObjects:
			[NSArray arrayWithObjects:@"Password", [NSNumber numberWithInt:INPUT_TYPE_PASSWORD], nil] forKeys:
			[NSArray arrayWithObjects:FORM_PLACEHOLDER, FORM_INPUT_TYPE, nil]];
	[form addItem:dict isLastItem:NO];
	
	dict = [NSDictionary dictionaryWithObjects:
			[NSArray arrayWithObjects:@"Confirm Password", [NSNumber numberWithInt:INPUT_TYPE_PASSWORD], nil] forKeys:
			[NSArray arrayWithObjects:FORM_PLACEHOLDER, FORM_INPUT_TYPE, nil]];
	[form addItem:dict isLastItem:YES];
	
//	CGRect frame = form.frame;
//	frame.origin.x = 10;
//	frame.origin.y = -20;
//	form.frame = frame;
	
	[self.view addSubview:form];
	NSLog(@"form frame: %@", NSStringFromCGRect(form.frame));
}

- (UITextField*)titleField {
	if (_titleField == nil) {
		_titleField = [[UITextField alloc] initWithFrame:CGRectMake(10.0, 20.0, 300.0, 30.0)];
		[_titleField setDelegate:self];
		[_titleField setReturnKeyType:UIReturnKeyDone];
		[_titleField setBorderStyle:UITextBorderStyleRoundedRect];
	}
	return _titleField;
}

- (UITextView*)descriptionField {
	if (_descriptionField == nil) {
		_descriptionField = [[UITextView alloc] initWithFrame:CGRectMake(10.0, 70.0, 300.0, 200.0)];
		[_descriptionField setDelegate:self];
		_descriptionField.layer.cornerRadius = 5;
		_descriptionField.layer.borderColor = [UIColor blackColor].CGColor;
		_descriptionField.layer.borderWidth = 2.0;
		_descriptionField.clipsToBounds = NO;
		
		UIButton* doneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[doneButton setTitle:@"Done!" forState:UIControlStateNormal];
		[doneButton setFrame:CGRectMake(0.0, 0.0, 60.0, 30.0)];
		[doneButton addTarget:self action:@selector(doneButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
		[_descriptionField setInputAccessoryView:doneButton];
	}
	return _descriptionField;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doneButtonTapped:(id)sender {
	[_descriptionField resignFirstResponder];
}

- (void)postThisShit:(id)sender {
//	PFObject *request = [PFObject objectWithClassName:@"Request"];
//	[request setObject:self.titleField.text forKey:@"title"];
//	[request setObject:self.descriptionField.text forKey:@"description"];
//	[request saveInBackground];
//	SZTestNC* navController = [[SZTestNC alloc] init];
//	[self presentViewController:navController animated:YES completion:nil];
	NSLog(@"checked? %i", self.checkBox.isChecked);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[_titleField resignFirstResponder];
	return YES;
}


@end
