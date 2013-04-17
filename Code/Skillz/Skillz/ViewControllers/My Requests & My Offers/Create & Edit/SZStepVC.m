//
//  SZStepVC.m
//  Skillz
//
//  Created by Julia Roggatz on 25.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZStepVC.h"
#import "SZUtils.h"
#import "SZButton.h"
#import "UILabel+Shadow.h"
#import "SZForm.h"

#define BUTTON_AREA_HEIGHT 70.0


@interface SZStepVC ()

@property (nonatomic, assign) NSInteger stepNumber;
@property (nonatomic, assign) NSInteger totalSteps;
@property (nonatomic, strong) SZForm* editDescriptionForm;

@end

@implementation SZStepVC

@synthesize stepNumber = _stepNumber;
@synthesize totalSteps = _totalSteps;
@synthesize mainView = _mainView;
@synthesize detailViewContainer = _detailViewContainer;
@synthesize continueButton = _continueButton;
@synthesize editTaskFirstDisplay = _editTaskFirstDisplay;
@synthesize forms = _forms;


- (id)initWithStepNumber:(NSInteger)stepNumber totalSteps:(NSInteger)totalSteps {
	self = [super init];
	if (self) {
		self.stepNumber = stepNumber;
		self.totalSteps = totalSteps;
	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
	[self.navigationItem setRightBarButtonItem:cancelButton];
	[self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil]];
	
	
	[self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [SZGlobalConstants fontWithFontType:SZFontBold size:12.0], UITextAttributeFont,nil] forState:UIControlStateNormal];
	[self.navigationItem.backBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [SZGlobalConstants fontWithFontType:SZFontBold size:12.0], UITextAttributeFont,nil] forState:UIControlStateNormal];
	
	[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_pattern"]]];
	
	[self.view addSubview:self.mainView];
	[self.mainView addSubview:[self stepLabel]];
	[self.mainView addSubview:self.continueButton];
}

- (UIScrollView*)mainView {
	if (_mainView == nil) {
		_mainView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 416.0)];
		[_mainView setClipsToBounds:NO];
		[_mainView setContentSize:_mainView.frame.size];
		
		UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mainViewTapped:)];
		[tapRecognizer setNumberOfTapsRequired:1];
		[_mainView addGestureRecognizer:tapRecognizer];
	}
	return _mainView;
}

- (UIView*)detailViewContainer {
	if (_detailViewContainer == nil) {
		_detailViewContainer = [[UIView alloc] initWithFrame:CGRectMake(15.0, 230.0, 0.0, 0.0)];
	}
	return _detailViewContainer;
}

- (UILabel*)stepLabel {
	UILabel* stepLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 20.0, 320.0, 30.0)];
	[stepLabel setFont:[SZGlobalConstants fontWithFontType:SZFontBold size:20.0]];
	[stepLabel setTextAlignment:NSTextAlignmentCenter];
	[stepLabel setTextColor:[SZGlobalConstants darkPetrol]];
	[stepLabel applyWhiteShadow];
	[stepLabel setText:[NSString stringWithFormat:@"Step %i of %i", self.stepNumber, self.totalSteps]];
	return stepLabel;
}

- (SZButton*)continueButton {
	if (_continueButton == nil) {
		_continueButton = [[SZButton alloc] initWithColor:SZButtonColorPetrol size:SZButtonSizeLarge width:290.0];
		[_continueButton setTitle:@"Continue" forState:UIControlStateNormal];
		[_continueButton addTarget:self action:@selector(continue:) forControlEvents:UIControlEventTouchUpInside];
		[_continueButton setCenter:CGPointMake(160.0, 381.0)];
	}
	return _continueButton;
}

- (NSMutableArray*)forms {
	if (_forms == nil) {
		_forms = [[NSMutableArray alloc] init];
	}
	return _forms;
}

- (void)mainViewTapped:(id)sender {
	
	for (SZForm* form in self.forms) {
		if (form.isActive) {
			[form resign:nil completion:nil];
		}
	}
	
}

- (void)cancel:(id)sender {
	
	UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Do you really want to cancel?" message:@"All progress will be lost." delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
	[alertView setDelegate:self];
	[alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		
		[SZDataManager sharedInstance].currentEntry = nil;
		[SZDataManager sharedInstance].viewControllerStack = nil;
		[self.presentingViewController performSelector:@selector(dismiss:) withObject:self];
	}
}


- (void)segmentedControlVertical:(SZSegmentedControlVertical *)control didSelectItemAtIndex:(NSInteger)index {
	
	if (self.editDescriptionForm && self.editDescriptionForm.isActive) {
		[self.editDescriptionForm resign:nil completion:^(BOOL finished) {
			[self slideOutDetailViewAndAddNewViewWithIndex:index];
		}];
	}
	else {
		[self slideOutDetailViewAndAddNewViewWithIndex:index];
	}
}

- (void)addNewDetailView:(NSInteger)index {
	// WILL BE IMPLEMENTED INDIVIDUALLY BY SUBLASSES
}

- (void)updateBoundsAnimated:(BOOL)animated {
	
	if ([[self.detailViewContainer subviews] count] > 0) {
		
		UIView* currentDetailView = [[self.detailViewContainer subviews] objectAtIndex:0];
		CGFloat totalHeight = self.detailViewContainer.frame.origin.y + currentDetailView.frame.size.height + BUTTON_AREA_HEIGHT;
		CGFloat newHeight = MAX(416.0, totalHeight);
		
		if (animated) {
			[UIView animateWithDuration:0.3 animations:^{
				[self setScrollViewHeight:newHeight];
			} completion:^(BOOL finished) {
				[self slideInDetailViewAnimated:YES];
			}];
		}
		else {
			[self setScrollViewHeight:newHeight];
			[self slideInDetailViewAnimated:NO];
		}
	}
	else {
		if (animated) {
			[UIView animateWithDuration:0.3 animations:^{
				[self setScrollViewHeight:416.0];
			}];
		}
		else {
			[self setScrollViewHeight:416.0];
		}
	}
}

- (void)setScrollViewHeight:(CGFloat)newHeight {
	[self.mainView setContentSize:CGSizeMake(self.mainView.contentSize.width, newHeight)];
	[self.mainView setContentOffset:CGPointMake(0, self.mainView.contentSize.height - self.mainView.bounds.size.height)];
	CGRect buttonFrame = self.continueButton.frame;
	buttonFrame.origin.y = self.mainView.contentSize.height - buttonFrame.size.height - 15.0;
	self.continueButton.frame = buttonFrame;
}

- (void)slideOutDetailViewAndAddNewViewWithIndex:(NSInteger)index {
	if ([[self.detailViewContainer subviews] count] > 0) {
		[UIView animateWithDuration:0.2 animations:^{
			[self.detailViewContainer setFrame:CGRectMake(330.0,
														  self.detailViewContainer.frame.origin.y,
														  self.detailViewContainer.frame.size.width,
														  self.detailViewContainer.frame.size.height)];
		} completion:^(BOOL finished) {
			UIView* currentDetailView = [[self.detailViewContainer subviews] objectAtIndex:0];
			[currentDetailView removeFromSuperview];
			[self addNewDetailView:index];
		}];
	}
	else {
		[self addNewDetailView:index];
	}
}

- (void)slideInDetailViewAnimated:(BOOL)animated {
	if ([[self.detailViewContainer subviews] count] > 0) {
		UIView* currentDetailView = [[self.detailViewContainer subviews] objectAtIndex:0];
		self.detailViewContainer.hidden = NO;
		CGRect frame = self.detailViewContainer.frame;
		frame.size.width = currentDetailView.frame.size.width;
		frame.size.height = currentDetailView.frame.size.height;
		self.detailViewContainer.frame = frame;
		if (animated) {
			[UIView animateWithDuration:0.2 animations:^{
				[self.detailViewContainer setFrame:CGRectMake(15.0,
															  self.detailViewContainer.frame.origin.y,
															  self.detailViewContainer.frame.size.width,
															  self.detailViewContainer.frame.size.height)];
			}];
		}
		else {
			[self.detailViewContainer setFrame:CGRectMake(15.0,
														  self.detailViewContainer.frame.origin.y,
														  self.detailViewContainer.frame.size.width,
														  self.detailViewContainer.frame.size.height)];
		}
	}
}

- (void)newDetailViewAddedAnimated:(BOOL)animated {
	[self.detailViewContainer setHidden:YES];
	[self.detailViewContainer setFrame:CGRectMake(330.0,
												  self.detailViewContainer.frame.origin.y,
												  self.detailViewContainer.frame.size.width,
												  self.detailViewContainer.frame.size.height)];
	[self updateBoundsAnimated:animated];
}

- (void)editDescription:(SZButton*)sender {
	
	if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"Edit Description"]) {
		[self showDescription:sender];
	}
	
	else if ([[sender titleForState:UIControlStateNormal] isEqualToString:@"Save Changes"]) {
		[self saveAndHideDescription:sender];
	}
	
}

- (void)showDescription:(SZButton*)sender {
	
	UIView* parentView = [sender superview];
	[sender setEnabled:NO];
	
	SZFormFieldVO* descriptionField = [[SZFormFieldVO alloc] init];
	descriptionField.key = @"description";
	
	self.editDescriptionForm = [[SZForm alloc] initForTextViewWithItem:descriptionField width:290.0 height:140.0];
	[self.forms addObject:self.editDescriptionForm];
	
	NSString* description;
	if ([[SZDataManager sharedInstance].currentEntry isKindOfClass:[SZEntryObject class]]) {
		description = ((SZEntryObject*)[SZDataManager sharedInstance].currentEntry).description;
	}
	[self.editDescriptionForm setText:description forFieldAtIndex:0];
	[self.editDescriptionForm setScrollContainer:self.mainView];
	[self.editDescriptionForm setFrame:CGRectMake(330.0,
										 sender.frame.origin.y + 50.0,
										 self.editDescriptionForm.frame.size.width,
										 self.editDescriptionForm.frame.size.height)];
	[self.detailViewContainer setFrame:CGRectMake(self.detailViewContainer.frame.origin.x,
												  self.detailViewContainer.frame.origin.y,
												  self.detailViewContainer.frame.size.width,
												  self.detailViewContainer.frame.size.height + 150.0)];
	[parentView setFrame:CGRectMake(parentView.frame.origin.x,
									parentView.frame.origin.y,
									parentView.frame.size.width,
									parentView.frame.size.height + 150.0)];
	[parentView addSubview:self.editDescriptionForm];
	
	[UIView animateWithDuration:0.2 animations:^{
		[self.mainView setContentSize:CGSizeMake(self.mainView.contentSize.width, self.mainView.contentSize.height + 150.0)];
		[self.mainView setContentOffset:CGPointMake(0, self.mainView.contentSize.height - self.mainView.bounds.size.height)];
		CGRect buttonFrame = self.continueButton.frame;
		buttonFrame.origin.y = self.mainView.contentSize.height - buttonFrame.size.height - 15.0;
		self.continueButton.frame = buttonFrame;
	} completion:^(BOOL finished) {
		[UIView animateWithDuration:0.2 animations:^{
			[self.editDescriptionForm setFrame:CGRectMake(0.0,
												 self.editDescriptionForm.frame.origin.y,
												 self.editDescriptionForm.frame.size.width,
												 self.editDescriptionForm.frame.size.height)];
		} completion:^(BOOL finished) {
			[sender setEnabled:YES];
			[sender setTitle:@"Save Changes" forState:UIControlStateNormal];
		}];
	}];
}

- (void)saveAndHideDescription:(SZButton*)sender {
	
	UIView* parentView = [sender superview];
	if ([[SZDataManager sharedInstance].currentEntry isKindOfClass:[SZEntryObject class]]) {
		((SZEntryObject*)[SZDataManager sharedInstance].currentEntry).description = [self.editDescriptionForm.userInputs valueForKey:@"description"];
	}
	[self.detailViewContainer setFrame:CGRectMake(self.detailViewContainer.frame.origin.x,
												  self.detailViewContainer.frame.origin.y,
												  self.detailViewContainer.frame.size.width,
												  self.detailViewContainer.frame.size.height - 150.0)];
	[parentView setFrame:CGRectMake(parentView.frame.origin.x,
									parentView.frame.origin.y,
									parentView.frame.size.width,
									parentView.frame.size.height - 150.0)];
	
	[UIView animateWithDuration:0.2 animations:^{
		[self.editDescriptionForm setFrame:CGRectMake(330.0,
											 self.editDescriptionForm.frame.origin.y,
											 self.editDescriptionForm.frame.size.width,
											 self.editDescriptionForm.frame.size.height)];
	} completion:^(BOOL finished) {
		[self.editDescriptionForm removeFromSuperview];
		[UIView animateWithDuration:0.2 animations:^{
			[self.mainView setContentSize:CGSizeMake(self.mainView.contentSize.width, self.mainView.contentSize.height - 150.0)];
			[self.mainView setContentOffset:CGPointMake(0, self.mainView.contentSize.height - self.mainView.bounds.size.height)];
			CGRect buttonFrame = self.continueButton.frame;
			buttonFrame.origin.y = self.mainView.contentSize.height - buttonFrame.size.height - 15.0;
			self.continueButton.frame = buttonFrame;
		} completion:^(BOOL finished) {
			[sender setEnabled:YES];
			[sender setTitle:@"Edit Description" forState:UIControlStateNormal];
		}];
		
	}];
	
}

- (void)viewWillDisappear:(BOOL)animated {
	if ([self isMovingFromParentViewController]) {
		[[SZDataManager sharedInstance].viewControllerStack push:self];
	}
}

@end
