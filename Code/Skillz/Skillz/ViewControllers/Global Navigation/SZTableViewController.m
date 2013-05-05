//
//  SZTableViewController.m
//  Skillz
//
//  Created by Julia Roggatz on 05.05.13.
//  Copyright (c) 2013 Julia Roggatz. All rights reserved.
//

#import "SZTableViewController.h"

@interface SZTableViewController ()

@end

@implementation SZTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_pattern"]]];
	[self.navigationItem setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Back"
																			   style:UIBarButtonItemStylePlain
																			  target:nil
																			  action:nil]];
}

@end
