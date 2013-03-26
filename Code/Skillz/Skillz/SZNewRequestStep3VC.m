//
//  SZNewRequestStep3VC.m
//  Skillz
//
//  Created by Julia Roggatz on 25.03.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZNewRequestStep3VC.h"
#import "SZNewRequestStep4VC.h"
#import "SZRadioButtonControl.h"
#import "SZUtils.h"

#define BUTTON_AREA_HEIGHT 70.0

@interface SZNewRequestStep3VC ()

@property (nonatomic, strong) SZSegmentedControlVertical* segmentedControl;
@property (nonatomic, strong) UIView* detailViewContainer;
@property (nonatomic, strong) SZRadioButtonControl* option1detailView;
@property (nonatomic, strong) UIView* option2detailView;

@end

@implementation SZNewRequestStep3VC

@synthesize segmentedControl = _segmentedControl;
@synthesize detailViewContainer = _detailViewContainer;
@synthesize option1detailView = _option1detailView;
@synthesize option2detailView = _option2detailView;

- (id)init
{
    return [super initWithStepNumber:3 totalSteps:5];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.navigationController setTitle:@"Post a Request"];
	[self.mainView addSubview:[self specifyLocationLabel]];
	[self.mainView addSubview:self.segmentedControl];
	[self.mainView addSubview:self.detailViewContainer];
	// Do any additional setup after loading the view.
}

- (UILabel*)specifyLocationLabel {
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 60.0, 300.0, 30.0)];
	[label setBackgroundColor:[UIColor clearColor]];
	[label setFont:[SZGlobalConstants fontWithFontType:SZFontSemiBold size:16.0]];
	[label setTextColor:[SZGlobalConstants darkGray]];
	[label applyWhiteShadow];
	[label setText:@"Specify the location:"];
	return label;
}

- (SZSegmentedControlVertical*)segmentedControl {
	if (_segmentedControl == nil) {
		_segmentedControl = [[SZSegmentedControlVertical alloc] initWithWidth:290.0];
		[_segmentedControl addItemWithText:@"I'm willing to go somewhere else." isLast:NO];
		[_segmentedControl addItemWithText:@"People have to come to me." isLast:NO];
		[_segmentedControl addItemWithText:@"This can be done remotely." isLast:YES];
		[_segmentedControl setCenter:CGPointMake(160.0, 160.0)];
		[_segmentedControl setDelegate:self];
	}
	return _segmentedControl;
}

- (UIView*)detailViewContainer {
	if (_detailViewContainer == nil) {
		_detailViewContainer = [[UIView alloc] initWithFrame:CGRectMake(15.0, 240.0, 0.0, 0.0)];
		[_detailViewContainer setUserInteractionEnabled:YES];
	}
	return _detailViewContainer;
}

- (SZRadioButtonControl*)option1detailView {
	if (_option1detailView == nil) {
		
		_option1detailView = [[SZRadioButtonControl alloc] init];
		
		UILabel* view1 = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 180.0, 40.0)];
		UIButton* view2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[view2 setFrame:CGRectMake(0.0, 0.0, 220.0, 70.0)];
		UIButton* view3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[view3 setFrame:CGRectMake(0.0, 0.0, 1220.0, 50.0)];
		
		[_option1detailView addItemWithView:view1];
		[_option1detailView addItemWithView:view2];
		[_option1detailView addItemWithView:view3];
		
	}
	return _option1detailView;
}

- (UIView*)option2detailView {
	if (_option2detailView == nil) {
		
	}
	return _option2detailView;
}

- (void)continue:(id)sender {
	SZNewRequestStep4VC* step4 = [[SZNewRequestStep4VC alloc] init];
	[self.navigationController pushViewController:step4 animated:YES];
}

- (void)updateBounds {
	
	LogRect(self.detailViewContainer.frame);
	
	if ([[self.detailViewContainer subviews] count] > 0) {
		
		UIView* currentDetailView = [[self.detailViewContainer subviews] objectAtIndex:0];
		CGPoint detailOrigin = [currentDetailView convertPoint:currentDetailView.frame.origin toView:self.mainView];
		CGFloat totalHeight = detailOrigin.y + currentDetailView.frame.size.height + BUTTON_AREA_HEIGHT;
		
		[UIView animateWithDuration:0.3 animations:^{
			[self.mainView setContentSize:CGSizeMake(self.mainView.contentSize.width, MAX(420.0, totalHeight))];
			[self.mainView setContentOffset:CGPointMake(0, self.mainView.contentSize.height - self.mainView.bounds.size.height)];
			
			CGRect buttonFrame = self.continueButton.frame;
			buttonFrame.origin.y = self.mainView.contentSize.height - buttonFrame.size.height - 20.0;
			self.continueButton.frame = buttonFrame;
			
		} completion:^(BOOL finished) {
			self.detailViewContainer.hidden = NO;
			CGRect frame = self.detailViewContainer.frame;
			frame.size.width = currentDetailView.frame.size.width;
			frame.size.height = currentDetailView.frame.size.height;
			self.detailViewContainer.frame = frame;
		}];
	}
	else {
		[UIView animateWithDuration:0.3 animations:^{
			
			[self.mainView setContentSize:CGSizeMake(self.mainView.contentSize.width, 420.0)];
			CGRect buttonFrame = self.continueButton.frame;
			buttonFrame.origin.y = self.mainView.contentSize.height - buttonFrame.size.height - 20.0;
			self.continueButton.frame = buttonFrame;
		}];
	}
}

- (void)segmentedControlVertical:(SZSegmentedControlVertical *)control didSelectItemAtIndex:(NSInteger)index {
	for (UIView* view in [self.detailViewContainer subviews]) {
		[view removeFromSuperview];
	}
	
	if (index == 0) {
		[self.detailViewContainer addSubview:self.option1detailView];
		self.detailViewContainer.hidden = YES;
		
	}
	else if (index == 1) {
		[self.detailViewContainer addSubview:self.option2detailView];
	}
	
	[self updateBounds];
}



@end
