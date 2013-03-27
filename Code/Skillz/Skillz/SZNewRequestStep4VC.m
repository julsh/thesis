//
//  SZNewRequestStep4VC.m
//  Skillz
//
//  Created by Julia Roggatz on 25.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZNewRequestStep4VC.h"
#import "SZNewRequestStep5VC.h"
#import "SZSegmentedControlVertical.h"
#import "UITextView+Shadow.h"
#import "SZForm.h"
#import "SZUtils.h"

@interface SZNewRequestStep4VC ()

@property (nonatomic, strong) SZSegmentedControlVertical* segmentedControl;
@property (nonatomic, strong) UIView* option1detailView;
@property (nonatomic, strong) UIView* option2detailView;
@property (nonatomic, strong) UIView* option3detailView;

@end

@implementation SZNewRequestStep4VC

@synthesize segmentedControl = _segmentedControl;
@synthesize option1detailView = _option1detailView;
@synthesize option2detailView = _option2detailView;
@synthesize option3detailView = _option3detailView;

- (id)init
{
    return [super initWithStepNumber:4 totalSteps:5];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.navigationItem setTitle:@"Post a Request"];
	
	[self.mainView addSubview:[self specifyPriceLabel]];
	[self.mainView addSubview:self.segmentedControl];
	[self.mainView addSubview:self.detailViewContainer];
}

- (UILabel*)specifyPriceLabel {
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 60.0, 300.0, 30.0)];
	[label setBackgroundColor:[UIColor clearColor]];
	[label setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:16.0]];
	[label setTextColor:[SZGlobalConstants darkGray]];
	[label applyWhiteShadow];
	[label setText:@"How much are you willing to pay?"];
	return label;
}

- (SZSegmentedControlVertical*)segmentedControl {
	if (_segmentedControl == nil) {
		_segmentedControl = [[SZSegmentedControlVertical alloc] initWithWidth:290.0];
		[_segmentedControl addItemWithText:@"That's negotiable." isLast:NO];
		[_segmentedControl addItemWithText:@"Fixed hourly rate" isLast:NO];
		[_segmentedControl addItemWithText:@"Fixed job-based rate" isLast:YES];
		[_segmentedControl setCenter:CGPointMake(160.0, 160.0)];
		[_segmentedControl setDelegate:self];
	}
	return _segmentedControl;
}

- (UIView*)option1detailView {
	if (_option1detailView == nil) {
		_option1detailView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 290.0, 180.0)];
		
		UITextView* noticeText = [[UITextView alloc] initWithFrame:CGRectMake(0.0, 0.0, 290.0, 120.0)];
		[noticeText setTextAlignment:NSTextAlignmentJustified];
		[noticeText setBackgroundColor:[UIColor clearColor]];
		[noticeText setText:@"It might be helpful to give people a rough guidance in your request’s description on what you would          consider a reasonable proposal.\nOf course, this is completely optional."];
		[noticeText setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:14.0]];
		[noticeText setTextColor:[SZGlobalConstants darkGray]];
		[noticeText applyWhiteShadow];
		[noticeText setEditable:NO];
		
		SZButton* editButton = [[SZButton alloc] initWithColor:SZButtonColorOrange size:SZButtonSizeLarge width:290.0];
		[editButton setTitle:@"Edit Description" forState:UIControlStateNormal];
		[editButton addTarget:self action:@selector(editDescription:) forControlEvents:UIControlEventTouchUpInside];
		[editButton setFrame:CGRectMake(0.0, 130.0, editButton.frame.size.width, editButton.frame.size.height)];
		
		[_option1detailView addSubview:noticeText];
		[_option1detailView addSubview:editButton];
	}
	return _option1detailView;
}

- (UIView*)option2detailView {
	if (_option2detailView == nil) {
		_option2detailView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 35.0, 290.0, 48.0)];
		
		SZForm* priceForm = [[SZForm alloc] initWithWidth:60.0];
		[priceForm addItem:[NSDictionary dictionaryWithObjects:
							   [NSArray arrayWithObjects:@"15", [NSNumber numberWithInt:UIKeyboardTypeDecimalPad], nil] forKeys:
							   [NSArray arrayWithObjects:FORM_PLACEHOLDER, FORM_INPUT_TYPE, nil]] isLastItem:YES];
		[priceForm setScrollContainer:self.view];
		[priceForm configureKeyboard];
		[priceForm setFrame:CGRectMake(16.0, 0.0, priceForm.frame.size.width, priceForm.frame.size.height)];
		
		UILabel* priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(86.0, 0.0, 220.0, 40.0)];
		[priceLabel setBackgroundColor:[UIColor clearColor]];
		[priceLabel setText:@"Skillpoints per hour"];
		[priceLabel setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:20.0]];
		[priceLabel setTextColor:[SZGlobalConstants darkGray]];
		[priceLabel applyWhiteShadow];
		
		[_option2detailView addSubview:priceForm];
		[_option2detailView addSubview:priceLabel];
		
	}
	return _option2detailView;
}

- (UIView*)option3detailView {
	if (_option3detailView == nil) {
		_option3detailView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 5.0, 290.0, 200.0)];
		
		SZForm* priceForm = [[SZForm alloc] initWithWidth:80.0];
		[priceForm addItem:[NSDictionary dictionaryWithObjects:
							[NSArray arrayWithObjects:@"50", [NSNumber numberWithInt:UIKeyboardTypeDecimalPad], nil] forKeys:
							[NSArray arrayWithObjects:FORM_PLACEHOLDER, FORM_INPUT_TYPE, nil]] isLastItem:YES];
		[priceForm setScrollContainer:self.view];
		[priceForm configureKeyboard];
		[priceForm setFrame:CGRectMake(50.0, 0.0, priceForm.frame.size.width, priceForm.frame.size.height)];
		
		UILabel* priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(140.0, 0.0, 140.0, 40.0)];
		[priceLabel setBackgroundColor:[UIColor clearColor]];
		[priceLabel setText:@"Skillpoints"];
		[priceLabel setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:20.0]];
		[priceLabel setTextColor:[SZGlobalConstants darkGray]];
		[priceLabel applyWhiteShadow];
		
		UITextView* noticeText = [[UITextView alloc] initWithFrame:CGRectMake(0.0, 50.0, 290.0, 90.0)];
		[noticeText setTextAlignment:NSTextAlignmentJustified];
		[noticeText setBackgroundColor:[UIColor clearColor]];
		[noticeText setText:@"Please make sure your request's description contains sufficient infor-mation on what you expect from the deal."];
		[noticeText setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:14.0]];
		[noticeText setTextColor:[SZGlobalConstants darkGray]];
		[noticeText applyWhiteShadow];
		[noticeText setEditable:NO];
		
		SZButton* editButton = [[SZButton alloc] initWithColor:SZButtonColorOrange size:SZButtonSizeLarge width:290.0];
		[editButton setTitle:@"Edit Description" forState:UIControlStateNormal];
		[editButton addTarget:self action:@selector(editDescription:) forControlEvents:UIControlEventTouchUpInside];
		[editButton setFrame:CGRectMake(0.0, 155.0, editButton.frame.size.width, editButton.frame.size.height)];
		
		[_option3detailView addSubview:priceForm];
		[_option3detailView addSubview:priceLabel];
		[_option3detailView addSubview:noticeText];
		[_option3detailView addSubview:editButton];
		
		
	}
	return _option3detailView;
}

- (void)segmentedControlVertical:(SZSegmentedControlVertical *)control didSelectItemAtIndex:(NSInteger)index {
	
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

- (void)addNewDetailView:(NSInteger)index {
	
	switch (index) {
		case 0:
			[self.detailViewContainer addSubview:self.option1detailView];
			break;
		case 1:
			[self.detailViewContainer addSubview:self.option2detailView];
			break;
		case 2:
			[self.detailViewContainer addSubview:self.option3detailView];
			break;
		default:
			break;
	}
	
	[super newDetailViewAdded];
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
	
	SZForm* descriptionForm = [[SZForm alloc] initForTextViewWithWidth:290.0 height:140.0];
	descriptionForm.tag = 99;
	[descriptionForm setScrollContainer:self.view];
	[descriptionForm setFrame:CGRectMake(330.0,
										 sender.frame.origin.y + 50.0,
										 descriptionForm.frame.size.width,
										 descriptionForm.frame.size.height)];
	[self.detailViewContainer setFrame:CGRectMake(self.detailViewContainer.frame.origin.x,
												  self.detailViewContainer.frame.origin.y,
												  self.detailViewContainer.frame.size.width,
												  self.detailViewContainer.frame.size.height + 150.0)];
	[parentView setFrame:CGRectMake(parentView.frame.origin.x,
									parentView.frame.origin.y,
									parentView.frame.size.width,
									parentView.frame.size.height + 150.0)];
	[parentView addSubview:descriptionForm];
	
	[UIView animateWithDuration:0.2 animations:^{
		[self.mainView setContentSize:CGSizeMake(self.mainView.contentSize.width, self.mainView.contentSize.height + 150.0)];
		[self.mainView setContentOffset:CGPointMake(0, self.mainView.contentSize.height - self.mainView.bounds.size.height)];
		CGRect buttonFrame = self.continueButton.frame;
		buttonFrame.origin.y = self.mainView.contentSize.height - buttonFrame.size.height - 20.0;
		self.continueButton.frame = buttonFrame;
	} completion:^(BOOL finished) {
		[UIView animateWithDuration:0.2 animations:^{
			[descriptionForm setFrame:CGRectMake(0.0,
												 descriptionForm.frame.origin.y,
												 descriptionForm.frame.size.width,
												 descriptionForm.frame.size.height)];
		} completion:^(BOOL finished) {
			[sender setEnabled:YES];
			[sender setTitle:@"Save Changes" forState:UIControlStateNormal];
		}];
	}];
}

- (void)saveAndHideDescription:(SZButton*)sender {
	
	UIView* parentView = [sender superview];
	UIView* descriptionForm = [parentView viewWithTag:99];
	[self.detailViewContainer setFrame:CGRectMake(self.detailViewContainer.frame.origin.x,
												  self.detailViewContainer.frame.origin.y,
												  self.detailViewContainer.frame.size.width,
												  self.detailViewContainer.frame.size.height - 150.0)];
	[parentView setFrame:CGRectMake(parentView.frame.origin.x,
									parentView.frame.origin.y,
									parentView.frame.size.width,
									parentView.frame.size.height - 150.0)];
	
	[UIView animateWithDuration:0.2 animations:^{
		[descriptionForm setFrame:CGRectMake(330.0,
											 descriptionForm.frame.origin.y,
											 descriptionForm.frame.size.width,
											 descriptionForm.frame.size.height)];
	} completion:^(BOOL finished) {
		[descriptionForm removeFromSuperview];
		[UIView animateWithDuration:0.2 animations:^{
			[self.mainView setContentSize:CGSizeMake(self.mainView.contentSize.width, self.mainView.contentSize.height - 150.0)];
			[self.mainView setContentOffset:CGPointMake(0, self.mainView.contentSize.height - self.mainView.bounds.size.height)];
			CGRect buttonFrame = self.continueButton.frame;
			buttonFrame.origin.y = self.mainView.contentSize.height - buttonFrame.size.height - 20.0;
			self.continueButton.frame = buttonFrame;
		} completion:^(BOOL finished) {
			[sender setEnabled:YES];
			[sender setTitle:@"Edit Description" forState:UIControlStateNormal];
		}];
		
	}];
}

- (void)continue:(id)sender {
	SZNewRequestStep5VC* step5 = [[SZNewRequestStep5VC alloc] init];
	[self.navigationController pushViewController:step5 animated:YES];
}

@end
