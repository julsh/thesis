//
//  SZViewController.m
//  Skillz
//
//  Created by Julia Roggatz on 05.05.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZViewController.h"

@interface SZViewController ()

@end

@implementation SZViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_pattern"]]];
	[self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Back"
																			   style:UIBarButtonItemStylePlain
																			  target:nil
																			  action:nil]];
}

- (void)addMenuButton {
	UIBarButtonItem* menuButton = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self.navigationController.parentViewController action:@selector(toggleMenu:)];
	[self.navigationItem setLeftBarButtonItem:menuButton];
	[self.navigationItem.leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [SZGlobalConstants fontWithFontType:SZFontBold size:12.0], UITextAttributeFont,nil] forState:UIControlStateNormal];
}

@end
