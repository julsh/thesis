//
//  SZBrowseVC.m
//  Skillz
//
//  Created by Julia Roggatz on 04.04.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZBrowseVC.h"
#import "SZButton.h"
#import "UILabel+Shadow.h"
#import "SZCategoriesVC.h"
#import "SZDataManager.h"

@implementation SZBrowseVC


- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.navigationItem setTitle:@"Sign In"];
	[self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Back"
																			   style:UIBarButtonItemStylePlain
																			  target:nil
																			  action:nil]];
	
	[self.view addSubview:[self doSomethingLabel]];
	[self.view addSubview:[self needSomethingDoneLabel]];
	[self.view addSubview:[self requestsButton]];
	[self.view addSubview:[self offersButton]];
}

- (UILabel*)doSomethingLabel {
	
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(40.0, 60.0, 240.0, 60.0)];
	[label setTextAlignment:NSTextAlignmentCenter];
	[label setFont:[SZGlobalConstants fontWithFontType:SZFontBold size:18.0]];
	[label setTextColor:[SZGlobalConstants gray]];
	[label applyWhiteShadow];
	[label setText:@"Want to do something?"];
	return label;

}

- (UILabel*)needSomethingDoneLabel {
	
	UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(40.0, 210.0, 240.0, 60.0)];
	[label setTextAlignment:NSTextAlignmentCenter];
	[label setFont:[SZGlobalConstants fontWithFontType:SZFontBold size:18.0]];
	[label setTextColor:[SZGlobalConstants gray]];
	[label applyWhiteShadow];
	[label setText:@"Or need something done?"];
	return label;
	
}

- (SZButton*)requestsButton {
	
	SZButton* button = [[SZButton alloc] initWithColor:SZButtonColorPetrol size:SZButtonSizeExtraLarge width:240.0];
	[button setTag:0];
	[button setTitle:@"Browse Requests" forState:UIControlStateNormal];
	[button setFrame:CGRectMake(40.0, 120.0, button.frame.size.width, button.frame.size.height)];
	[button addTarget:self action:@selector(browse:) forControlEvents:UIControlEventTouchUpInside];
	return button;
}

- (SZButton*)offersButton {
	
	SZButton* button = [[SZButton alloc] initWithColor:SZButtonColorPetrol size:SZButtonSizeExtraLarge width:240.0];
	[button setTag:1];
	[button setTitle:@"Browse Offers" forState:UIControlStateNormal];
	[button setFrame:CGRectMake(40.0, 270.0, button.frame.size.width, button.frame.size.height)];
	[button addTarget:self action:@selector(browse:) forControlEvents:UIControlEventTouchUpInside];
	return button;
}

- (void)browse:(SZButton*)sender {
	
	[self.navigationController pushViewController:[[SZCategoriesVC alloc] init] animated:YES];
	
	switch (sender.tag) {
		case 0:
			[SZDataManager sharedInstance].currentEntryType = SZEntryTypeRequest;
			break;
		case 1:
			[SZDataManager sharedInstance].currentEntryType = SZEntryTypeOffer;
			break;
	}
	
}

@end
