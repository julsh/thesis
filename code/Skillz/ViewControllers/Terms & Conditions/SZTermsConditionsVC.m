//
//  SZTermsConditionsVC.m
//  Skillz
//
//  Created by Julia Roggatz on 06.05.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZTermsConditionsVC.h"

@interface SZTermsConditionsVC ()

@end

@implementation SZTermsConditionsVC

- (void)viewDidLoad {
    [super viewDidLoad];
	[self addMenuButton];
	[self.navigationItem setTitle:@"Terms & Conditions"];
	
	UILabel* toDoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 140.0, 320.0, 120.0)];
	[toDoLabel setTextAlignment:NSTextAlignmentCenter];
	[toDoLabel setNumberOfLines:0];
	[toDoLabel setFont:[SZGlobalConstants fontWithFontType:SZFontExtraBold size:28.0]];
	[toDoLabel setTextColor:[UIColor grayColor]];
	[toDoLabel applyWhiteShadow];
	[toDoLabel setText:@"Not\nimplemented\nyet"];
	[self.view addSubview:toDoLabel];
}

@end